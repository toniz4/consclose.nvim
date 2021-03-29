function! consclose#init()
	lua require("consclose")
endfunction

augroup ConsClose
	autocmd!
	autocmd FileType c,cpp,css,elixir,go,java,javacc,json,less,lua,objc,puppet,python,ruby,rust,scss,sh,solidity,stylus,terraform,xdefaults,zsh
				\ let b:consclose_enabled = 1 |
				\ let b:consclose_tokens = '([{'

	autocmd FileType * call consclose#init()
augroup END

call consclose#init()
