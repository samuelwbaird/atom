-- es6 javascript module output

local function write(module_name, ast, write)
	write('// auto generated atom module ' .. module_name)

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
	
	print(require('cjson').encode(ast))

	-- define simple types
	for _, exp in ipairs(ast) do
		if exp.tag == 'atom' then
			mention_atom(exp.text)
		end		
	end

	-- define product types
	for _, exp in ipairs(ast) do
		if exp.tag == 'sum' then
		end		
	end

	-- define sum types
	for _, exp in ipairs(ast) do
		if exp.tag == 'sum' then
		end		
	end

	
	-- export json import/export and all types
	write('export { to_json, from_json, ' .. table.concat(all_atoms, ', ') .. ' };')
end

return write