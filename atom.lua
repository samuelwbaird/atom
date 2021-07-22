-- atom tagged type DSL
--
-- see README.md for documentation and examples
-- 
--
--------------------------------------------------------------  

function process(input_file_name, output_file_name, format, module_name)
	local input = assert(io.open(input_file_name, 'r'), 'cannot open ' .. input_file_name)
	local contents = input:read('*a')
	input:close()
	
	-- syntax tokenise
	-- parse to ast
	
	-- comment line, symbol, sum type definition, 
	
end



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