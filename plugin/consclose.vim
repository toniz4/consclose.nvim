" function! ConsClose()
" 	lua for k in pairs(package.loaded) do if k:match("^consclose") then package.loaded[k] = nil end end
" 	lua require("consclose")
" endfunction

function! consclose#init()
	lua require("consclose")
	if !exists('g:consclose_no_mappings')
		imap <expr><CR> v:lua.consCR()
	endif
endfunction

augroup ConsClose
	autocmd!
	autocmd FileType c,cpp,css,elixir,go,java,javacc,json,less,lua,objc,puppet,python,ruby,rust,scss,sh,solidity,stylus,terraform,xdefaults,zsh
				\ let b:consclose_enabled = 1 |
				\ let b:consclose_tokens = '([{'

	autocmd FileType * call consclose#init()
augroup END

