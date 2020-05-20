" Basic initial config ----------------------------------------------------- {{{
let mapleader = "-"
let maplocalleader = "+"
set nocompatible
filetype indent plugin on
syntax enable
" }}}

" Colorscheme -------------------------------------------------------------- {{{
set bg=light
if $COLORTERM == 'truecolor'
	set termguicolors
endif

if has('gui_running')
	let g:PaperColor_Theme_Options = {
	  \   'theme': {
	  \     'default': {
	  \       'allow_bold': 0
	  \     },
	  \   }
	  \ }
else
	let g:PaperColor_Theme_Options = {
	  \   'theme': {
	  \     'default': {
	  \       'transparent_background': 1,
	  \       'allow_bold': 0
	  \     },
	  \   }
	  \ }
endif

""  \   	'default.light': {
""  \        'override' : {
""  \		      'color07': ['#000000','']
""  \			}
""  \     }

"colorscheme PaperColor
colorscheme lucius
"highlight clear SpellBad
"highlight SpellBad cterm=underline

" highlight the 81 column
set colorcolumn=81
highlight ColorColumn ctermbg=Grey ctermfg=Black
" }}}

" Basic settings ----------------------------------------------------------- {{{
if has('mouse')
	set mouse=a
endif

if has('gui_running')
	set guioptions-=T
	set guioptions-=m
	set guioptions+=e
	set t_Co=256
	set guitablabel=%M\ %t
endif

" Search down into subfolders, with tab-completion for all file operations
set path+=**
set wildignore=*.o,*.obj,*.pdf,*.ps,*.eps,*.jpg,*.png
" Display all matching files when tab complete
set wildmenu
set autoindent
set smarttab
set hlsearch
set incsearch
set number
set relativenumber
set showcmd
set encoding=utf-8
set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set wrap linebreak nolist
set showmode
" minimum context lines to keep when moving up down
"set so=5
" a buffer becomes hidden when it is abandoned
set hidden
set ignorecase
set smartcase
set nobackup
set nowritebackup
set noswapfile

" Indent options for c code
" :0 -> 0 indent for case labels
set cinoptions=:0

" For indentation:
"    tabstop, shiftwidth and expandtab
"    check also softtabstop
set tabstop=4 shiftwidth=4 noexpandtab

" Paragraph formating: see :help fo-table
"    not sure for:
"     - a (automatic formating)
"     - w (trailing white paragraph continues)
set fo=tcroqn2bj
set textwidth=80
" }}}

" vimwiki stuff ------------------------------------------------------------ {{{
" an option to converto to html found in:
"    https://gist.github.com/enpassant/0496e3db19e32e110edca03647c36541
"The wikis
let wiki_1 = {}
let wiki_1.path = '~/vimwiki/'
let wiki_1.path_html = '~/vimwiki_html/'
let wiki_1.nested_syntaxes = {'python': 'python', 'sh': 'sh', 'c': 'c', 'c++': 'cpp'}
let wiki_1.ext = '.md'
let wiki_1.folding = 'syntax'
let wiki_1.syntax = 'markdown'
let wiki_1.autoexport = 1
let wiki_1.maxhi = 1

let wiki_1.template_path = '~/vimwiki/templates/'
let wiki_1.template_default = 'GitHub'
let wiki_1.template_ext = '.html5'
let wiki_1.css_name = 'github-markdown.css'
let wiki_1.custom_wiki2html = 'wiki2html.sh'
" let wiki_1.custom_wiki2html = 'misaka_md2html.py'
" let wiki_1.custom_wiki2html = 'vimwiki_markdown'
" let wiki_1.custom_wiki2html = '$GOPATH/bin/vimwiki-godown'
" let wiki_1.custom_wiki2html_args = 'xyz/'

let g:vimwiki_list = [wiki_1]

" only set the filetype of vimwiki for files in the wiki
let g:vimwiki_global_ext = 0

let g:vimwiki_diary_months = {
      \ 1: 'Enero', 2: 'Febrero', 3: 'Marzo',
      \ 4: 'Abril', 5: 'Mayo', 6: 'Junio',
      \ 7: 'Julio', 8: 'Agosto', 9: 'Septiembre',
      \ 10: 'Octubre', 11: 'Noviembre', 12: 'Diciembre'
      \ }
" for preview with pandoc
command! -nargs=* RunSilent
      \ | execute ':silent !'.'<args>'
      \ | execute ':redraw!'
nnoremap <Leader>pc :RunSilent pandoc -o /tmp/vim-pandoc-out.pdf %<CR>
nnoremap <Leader>pp :RunSilent zathura /tmp/vim-pandoc-out.pdf<CR>

" This is useful for attachments stored in local directories, as done in zim
augroup vimwiki
	autocmd!
	autocmd Filetype vimwiki silent! :lcd %:p:h<cr>
"	autocmd FileType vimwiki call SetMarkdownOptions()
augroup END

"function! SetMarkdownOptions()
"	call VimwikiSet('syntax', 'markdown')
"	call VimwikiSet('custom_wiki2html', 'wiki2html.sh')
"endfunction

" }}}

" winresizer plugin stuff -------------------------------------------------- {{{
let g:winresizer_gui_enable = 1
" }}}

" Satus line ------------------------------------------------- {{{
set laststatus=2           " always show statusline
set statusline=[%n]\       " buffer number
set statusline+=%.20f      " Path to the file, with max 20 chars
set statusline+=%m         " Modified flag
set statusline+=\ -\       " Separator
set statusline+=FileType:  " Label
set statusline+=%y         " Filetype of the file
set statusline+=%=         " Change to the right side
set statusline+=c=%2c,\    " Current column
set statusline+=l=%4l/%-4L " Current line/Total, 4 dig. each (total left aligned)
set statusline+=[%p%%]
" }}}

" Some simple functions ---------------------------------------------------- {{{

func! DeleteTrailingWS()
     exe "normal mz"
     %s/\s\+$//ge
     exe "normal `z"
endfunc

function! FoldColumnToggle()
	if &foldcolumn
		setlocal foldcolumn=0
	else
		setlocal foldcolumn=4
	endif
endfunction

function! QuickfixIsOpen()
	let quickfix_win_list = filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')
	return len(quickfix_win_list) > 0
endfunction

function! QuickfixToggle()
	if  QuickfixIsOpen()
		cclose
		let g:quickfix_is_open = 0
		execute g:quickfix_return_to_window . "wincmd w"
	else
		let g:quickfix_return_to_window = winnr()
		botright copen
	endif
endfunction

function! GrepOnOperator(type, dir)
	let saved_unnamed_register = @@
	if a:type ==# 'v'
		normal! `<v`>y
	elseif a:type ==# 'char'
		normal! `[v`]y
	else
		return
	endif

	if a:dir
		silent execute "grep! -R " . shellescape(@@) . " ."
	else
		silent execute "grep! " . shellescape(@@) . " %"
	endif
	if  !QuickfixIsOpen()
		let g:quickfix_return_to_window = winnr()
		botright copen
	endif



	let @@ = saved_unnamed_register
endfunction

function! GrepOnFileOperator(type)
	call GrepOnOperator(a:type, 0)
endfunction

function! GrepOnDirOperator(type)
	call GrepOnOperator(a:type, 1)
endfunction

" }}}

" <leader> mappings ------------------------------------------- {{{
" for the functions above
nnoremap <silent> <leader>ts :call DeleteTrailingWS()<CR>
nnoremap <silent> <leader>f :call FoldColumnToggle()<cr>
nnoremap <silent> <leader>q :call QuickfixToggle()<cr>
nnoremap <silent> <leader>g :set operatorfunc=GrepOnFileOperator<cr>g@
nnoremap <silent> <leader>G :set operatorfunc=GrepOnDirOperator<cr>g@
vnoremap <silent> <leader>g :<c-u>call GrepOnFileOperator(visualmode())<cr>
vnoremap <silent> <leader>G :<c-u>call GrepOnDirOperator(visualmode())<cr>

nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>et :tabnew $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>cd :lcd %:p:h<cr>
nnoremap <leader>h :nohlsearch<cr>
nnoremap <leader>R :setlocal relativenumber!<cr>
nnoremap <leader>N :setlocal number!<cr>

" surround word
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
" surround visual selection
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>

" use <leader>H/L to mover to top bottom of window
" just because H and L are remaped to other things below
nnoremap <leader>H H
nnoremap <leader>L L
vnoremap <leader>H H
vnoremap <leader>L L

" }}}

" General n/v/i mappings ------------------------------------------- {{{

" use the man plugin to open man pages on a split window
runtime ftplugin/man.vim
nnoremap K :<C-U>exe "Man" v:count "<C-R><C-W>"<CR>
" open alternate buffer in a split
nnoremap <leader>a :execute "split " . bufname("#")<cr>
" open file under cursor in a split, using gf command
nnoremap gsf :execute "split\nnormal! gf"<cr>


" window movement
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" very magic reg expression mode (see :help magic)
nnoremap / /\v
nnoremap ? ?\v

" grep
"nnoremap <leader>G :silent execute "grep -R " . shellescape(expand("<cWORD>"))  . " ."<cr>:copen<cr>
"nnoremap <leader>g :silent execute "grep -R " . shellescape(expand("<cWORD>"))  . " %"<cr>:copen<cr>

inoremap <c-f> <right>
" convert current WORD to upper/lower case
inoremap <c-u> <esc>viwUea
inoremap <c-l> <esc>viwuea

" use H and L to move to begin-end line
nnoremap H 0
vnoremap H 0
nnoremap L $
vnoremap L $

" Note: try to change it by configuring CapsLock as Esc
" use jk to leave insert mode, back to normal mode
inoremap jk <esc>

" Automatic pairing
inoremap ( ()<left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap <expr> "  strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap <expr> '  strpart(getline('.'), col('.')-1, 1) == "'" ? "\<Right>" : "''\<Left>"

"insert date
nnoremap <F5> "=strftime("%F")<CR>P
inoremap <F5> <C-R>=strftime("%F")<CR>

nnoremap <S-q> gqip<Bar>:echo "Rewrapped paragraph"<CR>
nnoremap <C-S-q> vipJgqq<Bar>:echo "Rewrapped paragraph"<CR>

" Compute expression using the = register, must be at the beginning of the expression
nnoremap <leader>x yt=A<C-R>=<C-R>"<CR>

" }}}

" Operator pending mappings ------------------------------- {{{
"onoremap in( :<c-u>normal! f(vi(<cr>
"onoremap il( :<c-u>normal! F)vi(<cr>
"onoremap an( :<c-u>normal! f(va(<cr>
"onoremap al( :<c-u>normal! F)va(<cr>
"onoremap in{ :<c-u>normal! f{vi{<cr>
"onoremap il{ :<c-u>normal! F}vi{<cr>
"onoremap an{ :<c-u>normal! f{va{<cr>
"onoremap al{ :<c-u>normal! F}va{<cr>
"onoremap in" :<c-u>normal! f"vi"<cr>
"onoremap il" :<c-u>normal! F"vi"<cr>
"onoremap an" :<c-u>normal! f"va"<cr>
"onoremap al" :<c-u>normal! F"va"<cr>

onoremap in( :<c-u>execute "normal! /(\r:nohlsearch\rvi)"<cr>
onoremap in) :<c-u>execute "normal! /(\r:nohlsearch\rvi)"<cr>
onoremap il( :<c-u>execute "normal! ?(\r:nohlsearch\rvi)"<cr>
onoremap il) :<c-u>execute "normal! ?(\r:nohlsearch\rvi)"<cr>

onoremap an( :<c-u>execute "normal! /(\r:nohlsearch\rva)"<cr>
onoremap an) :<c-u>execute "normal! /(\r:nohlsearch\rva)"<cr>
onoremap al( :<c-u>execute "normal! ?(\r:nohlsearch\rva)"<cr>
onoremap al) :<c-u>execute "normal! ?(\r:nohlsearch\rva)"<cr>

onoremap in{ :<c-u>execute "normal! /{\r:nohlsearch\rvi}"<cr>
onoremap in} :<c-u>execute "normal! /{\r:nohlsearch\rvi}"<cr>
onoremap il{ :<c-u>execute "normal! ?{\r:nohlsearch\rvi}"<cr>
onoremap il} :<c-u>execute "normal! ?{\r:nohlsearch\rvi}"<cr>

onoremap an{ :<c-u>execute "normal! /{\r:nohlsearch\rva}"<cr>
onoremap an} :<c-u>execute "normal! /{\r:nohlsearch\rva}"<cr>
onoremap al{ :<c-u>execute "normal! ?{\r:nohlsearch\rva}"<cr>
onoremap al} :<c-u>execute "normal! ?{\r:nohlsearch\rva}"<cr>

onoremap in" :<c-u>execute "normal! /\"\r:nohlsearch\rvi\""<cr>
onoremap il" :<c-u>execute "normal! ?\"\r:nohlsearch\rvi\""<cr>
onoremap an" :<c-u>execute "normal! /\"\r:nohlsearch\rva\""<cr>
onoremap al" :<c-u>execute "normal! ?\"\r:nohlsearch\rva\""<cr>
" }}}

" Trailing white spaces ------------------------------ {{{
" Highlight trailing spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
augroup trailspace
	autocmd!
	autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()
augroup END
" }}}

" Default Folding configuration ------------------------------ {{{
augroup foldingconf
	autocmd!
	autocmd Syntax perl normal zR
augroup END
" }}}

" c/c++ file setttings ------------------------------------------- {{{

func! Eatchar(pat)
	let c = nr2char(getchar(0))
	return (c =~ a:pat) ? '' : c
endfunc

" modify to avoid using this abbreviations on comments.
" tip in https://vim.fandom.com/wiki/C/C%2B%2B_function_abbreviations
augroup filetype_c
	autocmd!
	autocmd FileType c,cpp nnoremap <buffer> <localleader>c I//<esc>
	autocmd FileType c,cpp vnoremap <buffer> <localleader>c <esc>`<O/*<esc>`>o*/<esc>
	autocmd FileType c,cpp iabbrev <buffer> #d #define
	autocmd FileType c,cpp iabbrev <buffer> #i #include
	autocmd FileType c,cpp iabbrev <buffer> if if ()<left><C-R>=Eatchar('\s')<CR>
	autocmd FileType c,cpp iabbrev <buffer> for for ()<left><C-R>=Eatchar('\s')<CR>
	autocmd FileType c,cpp iabbrev <buffer> while while ()<left><C-R>=Eatchar('\s')<CR>
	autocmd FileType c,cpp iabbrev <buffer> main int main(int argc, char *argv[])<cr>{<cr>}<esc>O<C-R>=Eatchar('\s')<CR>
	autocmd FileType c,cpp iabbrev <buffer> { {<CR>}<esc>%a<C-R>=Eatchar('\s')<CR>
"}
	autocmd FileType c,cpp setlocal foldmethod=syntax
	autocmd FileType c,cpp normal zR
augroup END

augroup newfile_c
	autocmd!
	autocmd BufNewFile *.h,*.hpp,*.hh exe "normal! gga#ifndef _".expand("%:t")."_"
	autocmd BufNewFile *.h,*.hpp,*.hh 1,1s/\./_/
	autocmd BufNewFile *.h,*.hpp,*.hh normal! gg2wviwU
	autocmd BufNewFile *.h,*.hpp,*.hh normal! ggyyp
	autocmd BufNewFile *.h,*.hpp,*.hh 2,2s/ifndef/define/
	autocmd BufNewFile *.h,*.hpp,*.hh exe "normal! 2Go\<esc>o#endif\<esc>ki"
augroup END
" }}}

" latex file settings ------------------------------------- {{{
augroup filetype_tex
	autocmd!
    autocmd BufNewFile,BufRead *.cls set filetype=tex
"	autocmd FileType tex setlocal ts=2 sw=2 expandtab spell fo+=aw
	autocmd FileType tex setlocal ts=2 sw=2 expandtab spell fo+=w
	autocmd FileType tex setlocal wildignore+=*.aux,*.log,*.nav,*.out,*.snm,*.toc,*.vrb,*.bcf
	autocmd FileType tex nnoremap <buffer> <leader>k viw<esc>a}<esc>bi\emph{<esc>
"}
	autocmd FileType tex vnoremap <buffer> <leader>k <esc>`>a}<esc>`<i\emph{<esc>
"}
	autocmd FileType tex nnoremap <buffer> <leadr>t viw<esc>a}<esc>bi\texttt{<esc>
"}
	autocmd FileType tex vnoremap <buffer> <leadr>t <esc>`>a}<esc>`<i\texttt{<esc>
"}
augroup END
" }}}

" python file settings --------------------------------------- {{{
augroup filetype_python
	autocmd!
	autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
	autocmd FileType python :iabbrev <buffer> if if:<left>
	autocmd FileType python setlocal foldmethod=indent
	autocmd FileType python normal zR
augroup END
" }}}

" shell file settings ---------------------------------------- {{{
augroup filetype_sh
	autocmd!
	autocmd FileType sh nnoremap <buffer> <localleader>c I#<esc>
augroup END
" }}}

" Vimscript file settings ------------------------------------ {{{
augroup filetype_vim
	autocmd!
	autocmd FileType vim nnoremap <buffer> <localleader>c I"<esc>
	autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Mutt file settings ------------------------------------ {{{
augroup filetype_mutt
	autocmd!
	autocmd BufRead /tmp/mutt-* set tw=72
augroup END
" }}}

" mail file settings ------------------------------------- {{{
augroup filetype_mail
	autocmd!
	autocmd FileType mail setlocal tw=72 fo+=w comments+=nb:>
augroup END
" }}}

