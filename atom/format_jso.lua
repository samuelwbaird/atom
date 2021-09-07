-- es6 classes javascript module output

local function write(module_name, ast, contents, write)
	write('// auto generated atom module ' .. module_name)
	write('// using tagged frozen object instances\n')
	write('/* source')
	write(contents)
	write('*/')

	local all_atoms = {}
	local atoms_mentioned = {
		boolean = true,
		int = true,
		number = true,
		string = true,
		object = true,
	}
	local mention_atom = function (atom)
		if not atoms_mentioned[atom] then
			atoms_mentioned[atom] = true
			all_atoms[#all_atoms + 1] = atom
		end
	end
	
	local is_sum_type = {}
	local defined_fields = {}
	local defined_summed = {}

	-- gather all types
	for _, exp in ipairs(ast) do
		if exp.tag == 'atom' then
			mention_atom(exp.text)
		elseif exp.tag == 'product' then
			mention_atom(exp.name.text)
			defined_fields[exp.name.text] = exp.fields.list
			for _, field in ipairs(exp.fields.list) do
				mention_atom(field.type.text)
			end
		elseif exp.tag == 'sum' then
			mention_atom(exp.name.text)
			is_sum_type[exp.name.text] = true
			local summed = {}
			for _, sub in ipairs(exp.list) do
				summed[#summed + 1] = sub.text
				mention_atom(sub.text)
			end
			defined_summed[exp.name.text] = summed
		end		
	end

	-- create look up tables for which types belong to sum types
	write('// forward declare a type map of all types to all types as required')
	write('const type_map = new Map();\n')
	
	for _, type in ipairs(all_atoms) do
		if not is_sum_type[type] then
			local fields = defined_fields[type] or {}
			local field_list = {}
			for _, field in ipairs(fields) do
				field_list[#field_list + 1] = field.name.text
			end
			write('function ' .. type .. ' (' .. table.concat(field_list, ', ') .. ') {')
			write('	const obj = {')
			write('		type: \'' ..type .. '\',')
			for _, field in ipairs(fields) do
				-- TODO: validate fields in constructors
				write('		' .. field.name.text .. ': ' .. field.name.text .. ',')
			end
			write('		is (type) {')
			write('			return type_map.get(this.type).has(type);')
			write('		},')
			write('		equals (other) {')
			write('			if (other == null) { return false; }')
			write('			if (other.type != this.type) { return false; }')
			for _, field in ipairs(fields) do
				write('			if (other.' .. field.name.text .. ' != this.' .. field.name.text .. ') { return false; }')
			end
			write('			return true;')
			write('		}')
			write('	}')
			write('	Object.freeze(obj);')
			write('	return obj;')
			write('}\n')
		else
			write('function ' .. type .. ' () {')
			write('	throw new TypeError(\'cannot construct sum value ' .. type .. '\');');
			write('}\n')
		end
	end
		
	local function gather_is(type, is_types, seen)
		is_types = is_types or {}
		seen = seen or {}
		if seen[type] then
			return
		end
		seen[type] = true
		is_types[#is_types + 1] = type
		for name, summed in pairs(defined_summed) do
			for _, t in ipairs(summed) do
				if t == type then
					gather_is(name, is_types, seen)
				end
			end
		end
		return is_types
	end
	
	write('// add references to the type map, to answer if an object _is_ of any suggested type')
	for _, type in ipairs(all_atoms) do
		if not is_sum_type[type] then
			local is_types = gather_is(type)
			write('type_map.set(\'' .. type .. '\', new Set());')
			for _, t in ipairs(is_types) do
				write('type_map.get(\'' .. type .. '\').add(\'' .. t .. '\');')
				write('type_map.get(\'' .. type .. '\').add(' .. t .. ');')
			end
		end
	end
	write('')
	
	-- universally get a type from a string or a function
	write('// string or constructor to type string')
	write('function type (string_or_constructor) {')
	for i, type in ipairs(all_atoms) do
		write(((i == 1) and '	if' or '	} else if') .. '(string_or_constructor == ' .. type .. ') {')
		write('		return \'' .. type .. '\'')
	end
	write('	} else {')
	write('		return string_or_constructor;')
	write('	}')
	write('}\n')	

	write('// associate the type string with the exported funciton')
	for i, type in ipairs(all_atoms) do
		write(type .. '.type = \'' .. type .. '\'')
	end
	write('')	

	-- define to_json and from_json, hopefully very simple for this format
	write('// any special handling to serialised and deserialised consistently')
	write('function to_json (atom) {')
	write('	return JSON.stringify(atom);')
	write('}\n')
	write('function from_json (json) {')
	write('	let obj = JSON.parse(json);')
	write('	Object.freeze(obj);')
	write('	return obj;')
	write('}\n')
		
	-- export json import/export and all types
	write('\n// export as module')
	write('export { to_json, from_json, ' .. table.concat(all_atoms, ', ') .. ' };')
end

return write