" vim: ft=vim ts=4 sts=4 sw=4 fdm=marker

" Configurable settings {{{
let s:settings = {}
let s:settings.default_indent = 4
let s:settings.max_column = 80
let s:settings.background = 'dark'
let s:settings.main_keymap=''
let s:settings.main_spell_lang='en_us'
let s:settings.alt_keymap='ukrainian-jcuken'
let s:settings.alt_spell_lang='uk'
let s:cache_dir = '~/.vim/.cache'
" }}}

" Vundle setup and additional plugins {{{
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
	" let Vundle manage Vundle, required
	Plugin 'gmarik/Vundle.vim'

	" Additional plugins {{{
	Plugin 'tpope/vim-sensible'
	Plugin 'tpope/vim-repeat'
	Plugin 'tpope/vim-unimpaired'
	Plugin 'tpope/vim-commentary'
	Plugin 'tpope/vim-surround'
	Plugin 'justinmk/vim-sneak'
	Plugin 'tmhedberg/matchit'
	Plugin 'bling/vim-airline'
	Plugin 'moll/vim-bbye'
	Plugin 'altercation/vim-colors-solarized'
    Plugin 'airblade/vim-gitgutter'
	" }}}

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on
" let g:mapleader = ","
" }}}


" Functions {{{
function! s:toggle_keymap() "{{{
	if &keymap==""
		let &l:keymap=s:settings.alt_keymap
		let &l:spelllang=s:settings.alt_spell_lang
		echo 'Lang: UK'
	else
		let &l:keymap=s:settings.main_keymap
		let &l:spelllang=s:settings.main_spell_lang
		echo 'Lang: EN'
	endif
endfunction "}}}
function! s:get_cache_dir(suffix) "{{{
    return resolve(expand(s:cache_dir . '/' . a:suffix))
endfunction "}}}
function! EnsureExists(path) "{{{
    if !isdirectory(expand(a:path))
        call mkdir(expand(a:path))
    endif
endfunction "}}}
" }}}


" Custom keys mappings {{{
" swap ; and :
noremap ; :
noremap : ;

noremap Q :close<CR>

" Make Space key alias for Leader
map <Space> <Leader>
map <Leader>w 
noremap <Leader>W :write!<CR>
" [t]oggle [k]eymap (in current buffer)
nnoremap <Leader>tk :call <SID>toggle_keymap()<CR>
" [r]reload [v]imrc
nnoremap <Leader>rv :source $MYVIMRC<CR>
nnoremap <silent> <Leader>l :nohls<CR>:redraw!<CR>
nnoremap <leader>q :Bdelete<CR>
nnoremap <leader>Q :Bdelete<CR>:close<CR>
" }}}


" Overrinde some vim defaults here {{{
set encoding=utf-8
set hlsearch ignorecase smartcase
set expandtab
set noshelltemp                                     "use pipes
set nolist                                          "highlight whitespace
set listchars=tab:│\ ,trail:•,extends:❯,precedes:❮
set timeoutlen=500                                  "mapping timeout
set ttimeoutlen=50                                  "keycode timeout
set ttyfast mouse=
set hidden                                          "allow buffer switching without saving
set autoread                                        "auto reload if file saved externally
set wildignorecase wildmode=longest:full,full
set noerrorbells novisualbell t_vb=
set showmatch                                       "automatically highlight matching braces/brackets/etc.
set matchtime=2                                     "tens of a second to show matching parentheses
set foldenable                                      "enable folds by default
set foldmethod=syntax                               "fold via syntax of files
set foldlevelstart=99                               "open all folds by default

set cursorline
autocmd WinLeave * setlocal nocursorline
autocmd WinEnter * setlocal cursorline

let &keymap=s:settings.main_keymap
let &spelllang=s:settings.main_spell_lang
let &colorcolumn=s:settings.max_column
let &tabstop=s:settings.default_indent              "number of spaces per tab for display
let &softtabstop=s:settings.default_indent          "number of spaces per tab in insert mode
let &shiftwidth=s:settings.default_indent           "number of spaces when indenting
let &showbreak='↪ '

if has('unnamedplus')
    set clipboard=unnamedplus                        "sync with OS clipboard
endif

" vim file/folder management {{{
" persistent undo
if exists('+undofile')
    set undofile
    let &undodir = s:get_cache_dir('undo')
endif

" backups
set backup
let &backupdir = s:get_cache_dir('backup')

" swap files
set swapfile
let &directory = s:get_cache_dir('swap')

call EnsureExists(s:cache_dir)
call EnsureExists(&undodir)
call EnsureExists(&backupdir)
call EnsureExists(&directory)
"}}}
" }}}


" Plugin config overrides {{{
let g:sneak#streak = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep=' '
let g:airline#extensions#tabline#left_alt_sep='¦'
let g:airline_theme = 'solarized'
" }}}

" Enable Solarized Dark theme {{{
syntax enable
let &background = s:settings.background
" uncomment the following if you dont want to install custom terminal palette
" let g:solarized_termcolors=256
colorscheme solarized
" }}}

