-- atom tagged type DSL
--
-- see README.md for documentation and examples
-- 
--
--------------------------------------------------------------  

local parser = require('parser')

-- top level process
function process(input_file_name, output_file_name, format, module_name)
	print('processing ' .. input_file_name .. ' format:' .. format)
	
	-- read the file contents
	local input = assert(io.open(input_file_name, 'r'), 'cannot open ' .. input_file_name)
	local contents = input:read('*a')
	input:close()
	
	-- parse into a valid AST or error
	local ast = atom_file_parser(parser.character_stream(contents))
	
	-- comment line, symbol, sum type definition, 
	
end

-- parse a valid atom or token
local parse_atom = parser.trim_line(parser.sequence({
	parser.character_match('%a'),
	parser.list(parser.character_match('[%w_]')),
}, parser.steps(parser.reduce_text, parser.tag('atom'))))

-- parse a sum type, states: in, up, out, over
local parse_sum_type = parser.sequence({
	parse_atom,
	parser.ignore(parser.character_equal(':')),
	parser.separated_list(parse_atom, parser.character_equal(','), false),
}, parser.steps(parser.tag('sum'), parser.display))

-- parse a product type, playing { level: int, difficulty: int, }
local parse_field = parser.sequence({
	parse_atom,
	parser.ignore(parser.character_equal(':')),
	parse_atom,
}, parser.steps(parser.tag('field')))

local parse_product_type = parser.sequence({
	parse_atom,
	parser.ignore(parser.trim(parser.character_equal('{'))),
	parser.separated_list(parse_field, parser.trim(parser.character_equal(',')), true, parser.tag('fields')),
	parser.ignore(parser.trim(parser.character_equal('}'))),
}, parser.steps(parser.tag('product'), parser.display))

-- allow for an atom to be declared with no additional definition
local parse_simple = parser.sequence({
	parse_atom,
}, parser.steps(parser.display))

-- any one of these is considered a complete statement
local parse_statement = parser.any({
	-- parse sum type definition
	parse_sum_type,
	-- parse product type definition
	parse_product_type,
	-- -- an atom just mentioned independently with no type definition
	parse_simple,
})

-- parse a comment to end of line
local parse_comment = parser.sequence({
	parser.character_equal('-'),
	parser.character_equal('-'),
	parser.list(parser.character_not_equal('\n')),
}, parser.steps(parser.reduce_text, parser.tag('comment')))

-- if all other parsers failed, there must be a syntax error at this character
local function parse_syntax_error(stream)
	local character, remainder = stream()
	print('syntax error on line ' .. character.line .. ':' .. character.column)
	os.exit()
end

atom_file_parser = parser.many({ parse_statement, parse_comment, parser.whitespace, parse_syntax_error })

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