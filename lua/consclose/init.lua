local rTermcodes = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function strToTokens(tokenStr)
	tokens = {}
	tokens.open = {}
	tokens.close = {}

	for char in tokenStr:gmatch"."  do
		if char == '{' then
			table.insert(tokens.open, '{')
			table.insert(tokens.close, '}')
		elseif char == '[' then
			table.insert(tokens.open, '[')
			table.insert(tokens.close, ']')
		elseif char == '(' then
			table.insert(tokens.open, '(')
			table.insert(tokens.close, ')')
		end
	end
	return tokens
end

local function getClosingToken(tokens, line)
	local tok = ''
	-- Match tokens only at the end of the line.
	line = string.match(line, "%p*$")
	for char in line:gmatch"." do
		for n,t in ipairs(tokens.open) do
			if char == t then tok = tokens.close[n] .. tok end
			-- If there is a closing token in the matched line,
			-- ignore the open token (i.e 'int main(){', will ignore '(')
			if char == tokens.close[n] then tok = '' end
		end
	end
	if tok == '' then return else return tok end
end

local consCR = function()
	if vim.b.consclose_enabled == nil then return '\n' end

	local line = vim.fn.getline('.')

	-- If not in the end of the line, just make a new line
	if vim.fn.getpos('.')[3] ~= string.len(line) + 1 then return '\n' end

	local ln = vim.fn.line('.') - 1
	local indent = string.match(line, '^%s*')

	local tokenTable = strToTokens(vim.b.consclose_tokens)

	local token = getClosingToken(tokenTable, line)
	if token == nil then return '\n' end

	return rTermcodes("\n<Esc>a" .. indent .. token .. "<C-O>O<Esc>a" .. indent .. "<Tab><Esc>A")
end

if vim.g.conclose_no_mappings ~= nil then
	_G.consCR =  function()
		return consCR()
	end
	local opts = {expr = true, noremap = true}
	vim.api.nvim_set_keymap('i', '<CR>', 'v:lua.consCR()', opts)
end

return {
	consCR = consCR
}
