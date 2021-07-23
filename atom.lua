-- atom tagged type DSL
--
-- see README.md for documentation and examples
-- 
--
--------------------------------------------------------------  

function process(input_file_name, output_file_name, format, module_name)
	print('processing ' .. input_file_name .. ' format:' .. format)
	
	-- read the file contents
	local input = assert(io.open(input_file_name, 'r'), 'cannot open ' .. input_file_name)
	local contents = input:read('*a')
	input:close()
	
	-- parse into a valid AST or error
	local ast = parse(character_stream(contents), parse_format)
	
	-- comment line, symbol, sum type definition, 
	
end

-- parsers, read a stream of objects and return an object and the remainder of the stream, or nil, or raise an error

function list_to_stream(list, starting_index)
	starting_index = starting_index or 1
	return function ()
		return list[starting_index], list_to_stream(list, starting_index + 1)
	end
end

function character_stream(contents, index, line, column)
	index = index or 1
	if index > #contents then
		return nil
	end
	
	line = line or 1
	column = column or 0
	local character = contents:sub(index, index)
	if character == '\n' then
		line = line + 1
		column = 0
	else
		column = column + 1
	end
	return function()
		return { text = character, line = line, column = column }, character_stream(contents, index + 1, line, column)
	end
end

function identity(value)
	return value
end

function parse(stream, parser)
	if not stream then
		return
	end
	
	local result, remainder = parser(stream)
	if result then
		return parse(remainder, parser)
	end
end

function parse_any(parsers)
	return function (stream)
		for i = 1, #parsers do
			local result, remainder = parsers[i](stream)
			if result then
				return result, remainder
			end
		end
	end	
end

function parse_list(parser, minimum_length, transform)
	transform = transform or identity	
	minimum_length = minimum_length or 1
	return function (stream)
		local output = {}
		while stream do
			local result, remainder = parser(stream)
			if result then
				output[#output + 1] = result
				stream = remainder
			elseif #output < minimum_length then
				return nil
			else
				return transform(output), stream
			end
		end
		return transform(output), stream
	end	
end

function parse_many(parsers, minimum_length)
	return parse_list(parse_any(parsers), minimum_length)
end

function parse_sequence(parsers, transform)
	transform = transform or identity	
	return function (stream)
		local output = {}
		local p = 1
		while stream do
			local result, remainder = parsers[p](stream)
			if result then
				output[#output + 1] = result
				stream = remainder
			else
				return nil, stream
			end
			p = p + 1
			if p > #parsers then
				return transform(output), stream
			end
		end
	end	
end

function parse_character_match(pattern)
	return function (stream)
		local next, remainder = stream()
		if next.text:match(pattern) then
			return next, remainder
		end		
	end
end

function parse_character_equal(character)
	return function (stream)
		local next, remainder = stream()
		if next.text == character then
			return next, remainder
		end		
	end
end

function parse_character_not_equal(character)
	return function (stream)
		local next, remainder = stream()
		if next.text ~= character then
			return next, remainder
		end		
	end
end

function transform_steps(...)
	local arg = { ... }
	return function (obj)
		for _, t in ipairs(arg) do
			obj = t(obj) or obj
		end
		return obj
	end
end

function transform_combine_string(list)
	if #list == 0 then
		return list
	end
	
	local output = {
		text = list[1].text,
		line = list[1].line,
		column = list[1].column
	}
	for i = 2, #list do
		output.text = output.text .. list[i].text or ''
	end
	return output	
end

function display(obj)
	print(require('cjson').encode(obj))
end

function transform_tag(tag)
	return function (obj)
		obj.tag = tag
	end
end

parse_comment = parse_sequence({
	parse_character_equal('-'),
	parse_character_equal('-'),
	parse_list(parse_character_not_equal('\n'), 0, transform_combine_string),
}, transform_steps(transform_combine_string, transform_tag('comment'), display))

parse_whitespace = parse_list(parse_character_match('%s'), 1, transform_steps(transform_combine_string, transform_tag('whitespace')))
parse_optional_whitespace = parse_list(parse_character_match('%s'), 0, transform_steps(transform_combine_string, transform_tag('whitespace')))

parse_atom = parse_sequence({
	parse_character_match('%a'),
	parse_list(parse_character_match('[%w_]'), 0, transform_combine_string),
}, transform_steps(transform_combine_string, transform_tag('atom')))

function filter_atoms(list, add_to_list)
	local atoms = add_to_list or {}
	for _, obj in ipairs(list) do
		if obj.tag == 'atom' then
			atoms[#atoms + 1] = obj.text
		end
		if #obj > 0 then
			filter_atoms(obj, atoms)
		end
	end	
	return {
		atoms = atoms,
	}
end

parse_sum_type = parse_sequence({
	parse_atom,
	parse_optional_whitespace,
	parse_character_equal(':'),
	parse_list(parse_sequence({
		parse_optional_whitespace,
		parse_atom,
		parse_optional_whitespace,
		parse_character_equal(','),
	})),
	parse_optional_whitespace,
	parse_atom,
}, transform_steps(filter_atoms, transform_tag('sum'), display))

parse_simple = parse_sequence({
	parse_atom,
}, transform_steps(display))

parse_statement = parse_any({
	-- parse sum type definition
	parse_sum_type,
	-- parse product type definition
	
	-- an atom just mentioned independently with no type definition
	-- parse_simple,	
})


function parse_syntax_error(stream)
	local character, remainder = stream()
	print('syntax error on line ' .. character.line .. ':' .. character.column)
	os.exit()
end

parse_format = parse_many({ parse_comment, parse_statement, parse_whitespace, parse_syntax_error })




-- output formats

-- having defined all of the program, begin by processing arguments ----------------------------

function show_example_and_exit(error)
	print(error)
	print('eg. lua atom.lua --input=examples/simple.atom --output="output/simple.js" --format=js --name="simple_types"')
	print('  supported formats are: lua, js')
	print('  name and output are optional')
	os.exit()
end

-- capture the command line arguments
function validate_arguments_and_begin()
	-- check for present value arguments
	local arguments = {
		input = true, output = true, format = true, name = true
	}
	for _, a in ipairs(arg) do
		local key, value = a:match('%-%-([^=]+)=(.+)')
		if not key or not value then
			show_example_and_exit('invalid argument format ' .. a)
		elseif type(arguments[key]) == 'string' then
			show_example_and_exit('duplicate argument ' .. key)
		elseif not arguments[key] then
			show_example_and_exit('unknown argument ' .. key)
		else
			arguments[key] = value
		end
	end
	-- check the required parameters
	local format = arguments.format
	if format ~= 'lua' and format ~= 'js' then
		show_example_and_exit('invalid format')
	end
	local input = arguments.input
	if type(input) ~= 'string' then
		show_example_and_exit('invalid input file')
	end
	-- make up the default parameters if required
	local name_without_extension = input:match('([^%.]+)')
	local output = arguments.output
	if type(output) ~= 'string' then
		output = name_without_extension .. '.' .. format
	end
	local name = arguments.name 
	if type(name) ~= 'string' then
		local basename = name_without_extension
		if basename:find('/') then
			basename = name_without_extension:match('([^/]+)$')
		end
		name = basename
	end
	process(input, output, format, name)
end

validate_arguments_and_begin();