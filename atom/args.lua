-- some basic command line args handling
local error = error
local args = {}
local args_by_value = {}

-- begin by loading in the command line args
local function load(command_line_args, on_error)
	error = on_error
	for i = 1, #command_line_args do
		args[i] = command_line_args[i]
	end
end

local function get(name, required_or_default, validation)
	if args_by_value[name] then
		return args_by_value[name]
	end
	
	for i = 1, #args do
		if args[i]:sub(1, #name + 2) == '--' .. name then
			local key, value = args[i]:match('%-%-([^=]+)=(.+)')
			if not key or not value then
				error(args[i] .. 'argument should be formatted --' .. name .. '=value' )
			end
			table.remove(args, i)
			if validation and not validation(value) then
				error('invalid value ' .. value)
			end
			args_by_value[name] = value
			return value
		end
	end
	
	if required_or_default == true then
		error('missing required parameter ' .. name)
	elseif type(required_or_default) == 'function' then
		args_by_value[name] = required_or_default()
	else
		args_by_value[name] = required_or_default
	end
	
	return args_by_value[name]
end

local function validate_unknown()
	if #args > 0 then
		error('unknown argument ' .. args[1])
	end
end

return {
	load = load,
	get = get,
	validate_unknown = validate_unknown,
}