set nocompatible              " be iMproved, required
filetype off                  " required


" All of your Plugins must be added before the following line
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"

" Include the system settings
:if filereadable( "/etc/vimrc" )
   source /etc/vimrc
:endif

if filereadable("cscope.out")
   silent exe "cs add /src/cscope.out"
endif

if filereadable("py_cscope.out")
   silent exe "cs add /src/py_cscope.out"
endif
"
" Don't yank after paste
xnoremap p pgvy


"nnoremap * *<C-O>:%s///gn<CR>

"hl search stuff
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

"Change Buffer Mappings"
map <F5> :buffers<CR>
map <F1> :bprev<CR>
map <F2> :bnext<CR>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

noremap <Leader>\t :botright vertical term <CR>
"" set terminal window position
" (see possible options at :help vertical)
let g:toggle_terminal#position = 'topleft'
let g:toggle_terminal#command = 'powershell'

:imap jj <Esc>
"enter paste mode
set pastetoggle=<C-P>
" Put your own customizations below 

" tabstop:          Width of tab character
" softtabstop:      Fine tunes the amount of white space to be added
" shiftwidth        Determines the amount of whitespace to add in normal mode
" expandtab:        When on uses space instead of tabs
set runtimepath^=~/.vim/bundle/ctrlp.vim
set tabstop=3
set softtabstop=3
set shiftwidth=3
set expandtab
set nu
set ignorecase
set smartcase
set clipboard+=unnamed
set foldmethod=indent 
set foldlevel=42
set relativenumber number
set noshowcmd

" Ripgrep/fzf stuff
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
let g:rg_derive_root='true'

nnoremap \ :Rg<CR>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>s :BLines<cr>


" In the quickfix window, <CR> is used to jump to the error under the
" cursor, so undefine the mapping there.
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

syntax on
" Use new regular expression engine
set re=0

:match ErrorMsg '\%>85v.\+'
let s:activatedh = 1 
function! ToggleH()
   if s:activatedh == 0
      let s:activatedh = 1 
      match ErrorMsg '\%>85v.\+'
   else
      let s:activatedh = 0 
      match none
   endif
endfunction

if filereadable("cscope.out")
   silent exe "cs add /src/cscope.out"
endif

if filereadable("py_cscope.out")
   silent exe "cs add /src/py_cscope.out"
endif

" Highlights all text passed the column limit (85)
nnoremap <leader>1 :call ToggleH()<CR>

" Disable Arrow keys until I can stop being an idiot
" Disable Arrow keys in Normal mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

call plug#end()
" Plugins

" Themes and GUIs
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'majutsushi/tagbar'
Plug 'pakutoma/toggle-terminal'

" Syntax handling
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'

" System navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kevinhwang91/rnvimr'

" Session tracking
Plug 'tpope/vim-obsession'

" Utility
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'szw/vim-maximizer'
Plug 'inkarkat/vim-ingo-library'
Plug 'jiangmiao/auto-pairs'
Plug 'haya14busa/incsearch.vim'
Plug 'zhou13/vim-easyescape'

" All of your Plugins must be added before the following line
call plug#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" Dirvish
let g:loaded_netrwPlugin = 1

" Airline
let g:airline_theme='onedark'
let g:airline_highlighting_cache=1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#formatter = 'short_path'


" easy escape"
let g:easyescape_chars = { "j": 1, "k": 1  }
"let g:easyescape_timeout = 100
"timeout requires python3
cnoremap jk <ESC>
cnoremap kj <ESC>

" Add current function name to the status line
let g:airline#extensions#tagbar#enabled = 1

" Enhanced CPP highligh options
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

" Python highlighting options
let g:python_highlight_class_vars = 1
let g:python_highlight_func_calls = 1
let g:python_highlight_string_formatting = 1
let g:python_highlight_string_format = 1
let g:python_highlight_exceptions = 1

let g:tagbar_autoclose = 1
let g:tagbar_position = 'bottom'
let g:tagbar_height = 30
nnoremap <silent> - :TagbarToggle<CR>

" Remove trailing white spaces
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" make grep use ripgrep instead
set grepprg=rg\ --vimgrep
set grepformat^=%f:%l:%c:%m


set noshowmode  " to get rid of thing like --INSERT--
set noshowcmd  " to get rid of display of last command
set shortmess+=F  " to get rid of the file name displayed in the command line bar"

