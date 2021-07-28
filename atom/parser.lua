-- cheeky little bit of recursive parsing of streams, 
-- always, read a stream of objects and return an object and the remainder of the stream, or nil, or raise an error

-- streams ------------------------------------------------------------------------------

local function list_to_stream(list, starting_index)
	starting_index = starting_index or 1
	return function ()
		return list[starting_index], list_to_stream(list, starting_index + 1)
	end
end

local function character_stream(contents, index, line, column)
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

-- reduce/transform ------------------------------------------------------------------

-- default transform is identity
local function identity(value)
	return value
end

-- special value that will be ignored when parsing lists and sequences
local nothing = {}

-- combine multiple transform functions into one
local function steps(...)
	local arg = { ... }
	return function (obj)
		for i, t in ipairs(arg) do
			obj = t(obj) or obj
		end
		return obj
	end
end

local function tag(tag, fields)
	return function (obj)
		if fields then
			local list = obj
			obj = {}
			if type(fields) == 'string' then
				obj[fields] = list
			else
				for i, name in ipairs(fields) do
					obj[name] = list[i]
				end
			end
		end
		obj.tag = tag
		return obj
	end
end

local function first(obj)
	return obj[1]
end

local function display(obj)
	print(require('cjson').encode(obj))
	return obj
end

local function recurse(obj, with_obj)
	with_obj(obj)
	if #obj > 0 then
		for _, sub in ipairs(obj) do
			recurse(sub, with_obj)
		end
	end
end

-- recombine strings from the character stream
local function reduce_text(list)
	local output = {
		text = '',
	}	
	recurse(list, function (obj)
		if obj.text then
			output.text = output.text .. obj.text
		end
		if obj.line and not output.line then
			output.line = obj.line
		end
		if obj.column and not output.column then
			output.column = obj.column
		end
	end)
	return output
end


-- combine parsers --------------------------------------------------------------

local function any(parsers, transform)
	transform = transform or identity	
	return function (stream)
		for i = 1, #parsers do
			local result, remainder = parsers[i](stream)
			if result then
				return transform(result), remainder
			end
		end
	end	
end

local function list(parser, transform)
	transform = transform or identity	
	return function (stream)
		local output = {}
		while stream do
			local result, remainder = parser(stream)
			if result then
				if result ~= nothing then
					output[#output + 1] = result
				end
				stream = remainder
			else
				break
			end
		end
		if #output > 0 then
			return transform(output), stream
		end
	end	
end

local function optional(parser)
	return function (stream)
		local result, remainder = parser(stream)
		if result then
			return result, remainder
		else
			return nothing, stream
		end
	end
end

local function many(parsers)
	return list(any(parsers))
end

local function sequence(parsers, transform)
	transform = transform or identity	
	return function (stream)
		local output = {}
		local p = 1
		while stream do
			local result, remainder = parsers[p](stream)
			if result then
				if result ~= nothing then
					output[#output + 1] = result
				end
				stream = remainder
			else
				return nil
			end
			p = p + 1
			if p > #parsers then
				return transform(output), stream
			end
		end
	end	
end

-- matchers, single units of passing -----------------------------------------

local function match(lambda)
	return function (stream)
		local next, remainder = stream()
		if (lambda(next)) then
			return next, remainder
		end		
	end
end

local function character_match(pattern)
	return match(function (obj)
		return obj.text and obj.text:match(pattern)
	end)
end

local function character_equal(text)
	return match(function (obj)
		return obj.text == text
	end)
end

local function character_not_equal(text)
	return match(function (obj)
		return obj.text ~= text
	end)
end

-- white space and lists

local whitespace = list(character_match('%s'), steps(reduce_text, tag('whitespace')))
local linespace = list(character_match('[ \t]'), steps(reduce_text, tag('whitespace')))

local function ignore(parser)
	return function (stream)
		local result, remainder = parser(stream)
		if result then
			return nothing, remainder
		end
	end
end

local function trim(parser)
	return function (stream)
		local _, s1 = optional(whitespace)(stream)
		local result, s2 = parser(s1)
		if result then
			local _, s3 = optional(whitespace)(s2)
			return result, s3 or s2
		end
	end
end

local function trim_line(parser)
	return function (stream)
		local _, s1 = optional(linespace)(stream)
		local result, s2 = parser(s1)
		if result then
			local _, s3 = optional(linespace)(s2)
			return result, s3 or s2
		end
	end
end

-- separated list (eg. comma separated, optionally allow trailing separator)
local function separated_list(parser, separator, allow_hanging, transform)
	transform = transform or identity		
	return function (stream)
		local output = {}
		local is_first = true
		while stream do
			-- consume separators when required
			if is_first then
				is_first = false
			else
				local result, remainder = separator(stream)
				if result then
					stream = remainder
				else
					break
				end
			end
			
			local result, remainder = parser(stream)
			if result then
				if result ~= nothing then
					output[#output + 1] = result
				end
				stream = remainder
			else
				break
			end
		end
		
		-- consume hanging separate if allowed
		if allow_hanging then
			local result, remainder = separator(stream)
			if result then
				stream = remainder
			end
		end
		return transform(output), stream
	end
end

-- return as a module ----------------------------------------

return {
	-- streams
	list_to_stream = list_to_stream,
	character_stream = character_stream,
	
	-- reduce/transform
	identity = identity,
	nothing = nothing,
	steps = steps,
	tag = tag,
	first = first,
	display = display,
	recurse = recurse,
	reduce_text = reduce_text,
		
	-- parser combinations
	list = list,
	any = any,
	sequence = sequence,
	optional = optional,
	many = many,
	
	-- matching
	match = match,
	character_equal = character_equal,
	character_not_equal = character_not_equal,
	character_match = character_match,

	-- whitespace and lists
	whitespace = whitespace,
	linespace = linespace,
	ignore = ignore,
	trim = trim,
	trim_line = trim_line,
	separated_list = separated_list,
}