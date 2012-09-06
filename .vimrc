" My personalized vimrc file.
"
" Maintainer chliviu
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

call pathogen#infect()

" Powerful omnicompletion/keyword completion based on context
let g:SuperTabDefaultCompletionType = "context"
" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif


" set your colorscheme. 
if &diff
    set background=dark
    colorscheme peaksea
else
    colorscheme desert
endif

" This caters for the scenario when vimdiff is called while inside a vim buffer
au FilterWritePost * if &diff | set bg=dark | colorscheme peaksea | else | colorscheme desert | endif
au BufWinLeave * colorscheme desert

filetype plugin on

set nofoldenable

set clipboard=unnamed
set title

" crontab edit
if $VIM_CRONTAB == "true"
	set nobackup
	set nowritebackup
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set nobackup		" keep a backup file
endif

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq
"
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" mac mods
let mapleader = ","
map <Esc>[B <C-Down>
map <Esc>[D <C-Left>
map <Esc>[C <C-Right>
map <Esc>[A <C-Up>


map <C-Up> :tabnew<CR>
"map <C-Down> :tabclose<CR>
map <C-Down> :q<CR>
map <C-Left> gT
map <C-Right> gt
"
"map file save
map <F2> :w<CR>

"map browse files
map <F3> :o .<CR>
map <F4> :Ex <CR>
map <F5> :nohl <CR>

au BufNewFile,BufRead *.map setf map
"
" Only do this part when compiled with support for autocommands.
if has("autocmd")
	" In many terminal emulators the mouse works just fine, thus enable it.
	set mouse=r

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=78

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		autocmd BufReadPost *
					\ if line("'\"") > 0 && line("'\"") <= line("$") |
					\   exe "normal! g`\"" |
					\ endif

	augroup END

	" Drupal PHP files with strange extensions
	augroup drupal
		autocmd BufNewFile,BufRead *.module set filetype=php
		autocmd BufNewFile,BufRead *.engine set filetype=php
	augroup END

	" flex
	au BufNewFile,BufRead *.mxml set filetype=mxml
	au BufNewFile,BufRead *.as set filetype=actionscript

	au BufNewFile,BufRead *.py set filetype=python


	" autoclose tags
	" use ctrl-_ to close the last opened tag
	" au Filetype html,xml,xsl source ~/.vim/plugin/closetag/closetag.vim 

	" htmldjango
	au FileType htmldjango setlocal shiftwidth=4
	au FileType htmldjango setlocal tabstop=4
	au FileType htmldjango setlocal softtabstop=4
	au FileType htmldjango setlocal expandtab

	" crontab
	au FileType crontab set nobackup nowritebackup

	" ragtag, quick inserting for tags
	let g:allml_global_maps = 1 

	"autocompletion for basic languages
	autocmd FileType python set omnifunc=pythoncomplete#Complete
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS
	autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
	autocmd FileType php set omnifunc=phpcomplete#CompletePHP
	autocmd FileType c set omnifunc=ccomplete#Complete

	" Convenient command to see the difference between the current buffer and the
	" file it was loaded from, thus the changes you made.
	 "command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis 
				 "\ | wincmd p | diffthis

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
"
" show line numbers
set nu

"Django
"for templates
imap {{     {{ }}<Esc>hhi
imap {%     {% %}<Esc>hhi
imap {#     {# #}<Esc>hhi

""" Maps to opening main Django files 
map mo /models.py<CR><CR>
map ur /urls.py<CR><CR>
map vi /views.py<CR><CR>
map fo /forms.py<CR><CR>
map tp /templates<CR><CR>
map ad /admin.py<CR><CR>
map ut /utils.py<CR><CR>

set statusline=%m%F%r%h%w\ %y\ [line:%04l\ col:%04v]\ [%p%%]\ [lines:%L]
set laststatus=2
set shiftwidth=4
set ic
set scs
set tabstop=4
set autoread

" put some quick abbreviations
ab javoid href="javascript:void(0);"
ab jaclick onclick="javascript:"
ab br <br />

" python settings
autocmd BufRead *.py setlocal shiftwidth=4
autocmd BufRead *.py setlocal tabstop=4
autocmd BufRead *.py setlocal softtabstop=4
autocmd BufRead *.py setlocal expandtab

" python/django unit tests
let g:makeprg_django_app = 'python\ manage.py\ test\ -v\ 0'
let g:makeprg_django_project = 'python\ manage.py\ test'
set errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

function! RunTestsForFile(args)
    if @% =~ '\.py$'
        let expandstr = '%:p:h' " dirname
        while expand(expandstr) != '/'
            let testpath = expand(expandstr)
            if len(getfperm(testpath . '/tests')) > 0 || len(getfperm(testpath . '/tests.py')) > 0
                call RunTests(expand(expandstr . ':t'), a:args)
                return
            endif
            let expandstr .= ':h'
        endwhile
    endif
    call RunTests('', a:args)
endfunction

function! RunTests(target, args)
    silent ! echo
    silent ! echo -e "\033[1;36mRunning all unit tests\033[0m"
    silent w
    if len(a:target)
        execute 'set makeprg=' . g:makeprg_django_app
    else
        execute 'set makeprg=' . g:makeprg_django_project
    endif
    exec "make! " . a:target . " " . a:args
endfunction

function! JumpToError()
    let has_valid_error = 0
    for error in getqflist()
        if error['valid']
            let has_valid_error = 1
            break
        endif
    endfor
    if has_valid_error
        for error in getqflist()
            if error['valid']
                break
            endif
        endfor
        let error_message = substitute(error['text'], '^ *', '', 'g')
        silent cc!
        exec ":sbuffer " . error['bufnr']
        call RedBar()
        echo error_message
    else
        call GreenBar()
        echo "All tests passed"
    endif
endfunction

function! RedBar()
    hi RedBar ctermfg=white ctermbg=red guibg=red
    echohl RedBar
    echon repeat(" ",&columns - 1)
    echohl
endfunction

function! GreenBar()
    hi GreenBar ctermfg=white ctermbg=green guibg=green
    echohl GreenBar
    echon repeat(" ",&columns - 1)
    echohl
endfunction

nnoremap <leader>a :call RunTests('', '')<cr>:redraw<cr>:call JumpToError()<cr>
nnoremap <leader>y :call RunTestsForFile('--failfast')<cr>:redraw<cr>:call JumpToError()<cr>
