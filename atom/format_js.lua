-- es6 javascript module output

local function write(module_name, ast, write)
	
	print(require('cjson').encode(ast))
	print('')
	print('')

	write('// auto generated atom module ' .. module_name)

	write('\n// late bound classes, allow these to be declared in any order')
	write('let forward_types = {};\n')
	
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

	-- define constructors for every type that is not a sum type
	write('// define all single and product types (constructable)')
	for _, type in ipairs(all_atoms) do
		if not is_sum_type[type] then
			local fields = defined_fields[type] or {}
			local field_list = {}
			for _, field in ipairs(fields) do
				field_list[#field_list + 1] = field.name.text
			end
			write('class ' .. type .. ' {')
			write('	constructor (' .. table.concat(field_list, ', ') .. ') {')
			if #fields > 0 then
				write('		this._values = {')
				for _, field in ipairs(fields) do
					write('			' .. field.name.text .. ': ' .. field.name.text .. ',')
				end
				write('		};')
			end
			write('	}')
			for _, field in ipairs(fields) do
				-- getters
				write('\n	get ' .. field.name.text .. '() {')
				write('		return this._values.' .. field.name.text .. ';')
				write('	}')
			end
			-- equals method
			write('\n	equals (other) {')
			write('		if (other.type != this.type) { return false; }')
			for _, field in ipairs(fields) do
				write('		if (other.' .. field.name.text .. ' != this.' .. field.name.text .. ') { return false; }')
			end
			write('		return true;')
			write('	}')
			write('}\n')
		end
	end

	-- define static classes for all sum types
	write('// define all sum types (not constructable)')
	for _, type in ipairs(all_atoms) do
		if is_sum_type[type] then
			write('class ' .. type .. ' {')
			write('	constructor () {')
			write('		throw new TypeError(\'cannot construct sum value ' .. type .. '\');');
			write('	}')
			write('}\n')
		end
	end
	
	-- generic type references
	write('// static type checking')
	for _, type in ipairs(all_atoms) do
		write('forward_types[\'' .. type .. '\'] = ' .. type .. ';')
		write(type .. '.type = ' .. type .. ';')
		if defined_summed[type] then
			write(type .. '.types = [' .. table.concat(defined_summed[type], ', ') .. '];')
			write(type .. '.is = function (value) { return [' .. table.concat(defined_summed[type]) .. '].find(t => t == ' .. type .. ') != undefined;')
		else
			write(type .. '.types = [' .. type .. '];')
			write(type .. '.is = function (value) { return value.type == ' .. type .. '};');
		end
		write('')
	end
	
	-- export json import/export and all types
	write('\n// export as module')
	write('export { to_json, from_json, ' .. table.concat(all_atoms, ', ') .. ' };')
end

return write