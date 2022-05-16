-- build the atom file parser from the generic parser

local parser = require('atom/parser')

-- local debug = parser.display
local debug = function () end

-- parse a comment to end of line
local parse_comment = parser.sequence({
	parser.character_equal('-'),
	parser.character_equal('-'),
	parser.list(parser.character_not_equal('\n')),
}, parser.steps(parser.reduce_text, parser.tag('comment')))

local parse_ignorable = parser.many({ parse_comment, parser.whitespace })

-- parse a valid atom or token
local parse_atom = parser.trim_line(parser.sequence({
	parser.ignore(parser.optional(parse_ignorable)),
	parser.character_match('%a'),
	parser.list(parser.character_match('[%w_]')),
	parser.ignore(parser.optional(parse_ignorable)),
}, parser.steps(parser.reduce_text, parser.tag('atom'))))

-- parse a sum type, states: in, up, out, over
local parse_sum_type = parser.sequence({
	parse_atom,
	parser.ignore(parser.character_equal(':')),
	parser.separated_list(parse_atom, parser.character_equal(','), false),
}, parser.steps(parser.tag('sum', { 'name', 'list' }), debug))

-- parse a product type, playing { level: int, difficulty: int, }
local parse_field = parser.sequence({
	parse_atom,
	parser.ignore(parser.character_equal(':')),
	parse_atom,
}, parser.steps(parser.tag('field', { 'name', 'type' })))

local parse_product_type = parser.sequence({
	parse_atom,
	parser.ignore(parser.trim(parser.character_equal('{'))),
	parser.separated_list(parse_field, parser.trim(parser.character_equal(',')), true, parser.tag('fields', 'list')),
	parser.ignore(parser.optional(parse_ignorable)),
	parser.ignore(parser.trim(parser.character_equal('}'))),
}, parser.steps(parser.tag('product', { 'name', 'fields' }), debug))

-- allow for an atom to be declared with no additional definition
local parse_simple = parser.sequence({
	parse_atom,
}, parser.steps(parser.first, debug))

-- any one of these is considered a complete statement
local parse_statement = parser.any({
	-- parse sum type definition
	parse_sum_type,
	-- parse product type definition
	parse_product_type,
	-- -- an atom just mentioned independently with no type definition
	parse_simple,
})

-- if all other parsers failed, there must be a syntax error at this character
local function parse_syntax_error(stream)
	local character, remainder = stream()
	print('syntax error on line ' .. character.line .. ':' .. character.column)
	os.exit()
end

-- return the combined parser that will parse the full file
local full_ast_parser = parser.many({ parse_statement, parse_comment, parser.whitespace, parse_syntax_error })

return function (contents)
	return full_ast_parser(parser.character_stream(contents))
end
