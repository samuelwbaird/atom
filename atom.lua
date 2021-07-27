-- atom tagged type DSL
--
-- see README.md for documentation and examples
-- 
--
--------------------------------------------------------------  

local parser = require('atom/atom_file_parser')
local args = require('atom/args')

function show_example_and_exit(error)
	print(error)
	print('eg. lua atom.lua --input=examples/simple.atom --output="output/simple.js" --format=js --name="simple_types"')
	print('  supported formats are: lua, js')
	print('  name and output are optional')
	os.exit()
end

-- load and parse the arguments
args.load(arg, show_example_and_exit)
local input_file_name = args.get('input', true)
local format = args.get('format', true, function (value) return value == 'lua' or value == 'js' end)
local name_without_extension = input_file_name:match('([^%.]+)')
local basename = name_without_extension
if basename:find('/') then
	basename = name_without_extension:match('([^/]+)$')
end
local output_file_name = args.get('output', function ()
	return name_without_extension .. '.' .. format
end)
local module_name = args.get('name', function ()
	return basename
end)
args.validate_unknown()

print('processing ' .. input_file_name .. ' format:' .. format)

-- read the file contents
local input = assert(io.open(input_file_name, 'r'), 'cannot open ' .. input_file_name)
local contents = input:read('*a')
input:close()

-- parse into a valid AST or error
local ast = parser(contents)

-- output format
local output_format = require('atom/format_' .. format)
local output = assert(io.open(output_file_name, 'wb'), 'cannot write to ' .. output_file_name)
output_format(module_name, ast, function (line)
	output:write(line .. '\n')
end)
output:close()

