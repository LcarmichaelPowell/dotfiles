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

" Don't yank after paste
xnoremap p pgvy

" remap Leader to Space/Space no longer moves cursor
let mapleader = "\<Space>" 

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

" I don't like cw, map things to leader instead
" I have no clue what leader h is mapped to so unmap it all
nnoremap <Leader>= <C-w>=
nnoremap <Leader>h <C-w>h
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>l <C-w>l

 " Maps Alt-[h,j,k,l] to resizing a window split
 " These stupid symbols are because vim doesn't seem to understand the alt
 " key on OSX.  This is what alt - { hjkl } output respectivly.  If it's not
 " working go into vim insert mode and see what characters are output
 map <silent> ˙ <C-w><
 map <silent> ∆ <C-W>-
 map <silent> ˚ <C-W>+
 map <silent> ¬ <C-w>>
 map <silent> ≠ <C-w>=

" Bring up list of buffer numbers
nnoremap <Leader>b :buffers<CR>

" Open list and edit
nnoremap <Leader>w :buffers<CR>:e#

" Open list and split
nnoremap <Leader>s :buffers<CR>:sb

" Open list and vsplit
nnoremap <Leader>v :buffers<CR>:vert sb

" Open current buffer in new tab
nnoremap <Leader>z :tabe %<CR>

" swap between header/source files
nnoremap <Leader>t :call SwapFile( "primaryExt" )<CR>
nnoremap <Leader>y :call SwapFile( "secondaryExt" )<CR>

:let curExtList = ['tin',  'tac',   'itin']
:let primaryExtTargets = { 'tin' : 'tac',
                         \ 'tac' : 'tin', 
                         \ 'itin' : 'tac', }

:let secondaryExtTargets = { 'tin' : 'itin',
                           \ 'tac' : 'itin',
                           \ 'itin' : 'tin' }

:let extSwapReqs = [ "primaryExt", "secondaryExt" ]

fu! GetTargetExt( curExt, requestIdx )
   :let targetExt = ""
   if a:requestIdx == 0
      if has_key(g:primaryExtTargets, a:curExt ) > 0
         let targetExt = g:primaryExtTargets[ a:curExt ]
      endif
   elseif a:requestIdx == 1
      if has_key(g:secondaryExtTargets, a:curExt ) > 0
         let targetExt = g:secondaryExtTargets[ a:curExt ]
      endif
   else
      echom "No ext swap instructions for request type"
   endif

   if targetExt == ""
      echom "No ext target for " . curExt
      echo "Request: " . g:extSwapReqs[ requestIdx ]
   endif

   return targetExt
endfunction

fu! SwapFile( request )
   let curPath = expand('%:p:h') . '/'
   let curRootFileName = expand('%:t:r')
   let curExt = expand('%:e')
   let curFileFullPath = expand('%:p')

   " Different request will modify these attrs
   " Set them in case the specifc request does not change part
   " of the file
   let newRootFileName = curRootFileName
   let newPath = curPath
   let newExt = curExt

   if index(g:extSwapReqs, a:request) >= 0
      let newExt = GetTargetExt( expand('%:e'), index(g:extSwapReqs, a:request) )
      if newExt == ""
         echom "I DON'T KNOW WHAT TO DO WITH THIS EXTENSION!"
         return
      endif
   else
      echom "I DON'T KNOW WHAT TO DO WITH THIS REQUEST!"
      echo a:request
   endif

   let newFileFullPath = newPath . newRootFileName . "." . newExt 
   echom newFileFullPath

   if filereadable(newFileFullPath)
      execute 'e'newFileFullPath
   else
      echom "Cannot find target file: " . newFileFullPath
      echom "Current File:" . curFileFullPath
   endif
endfunction

nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

noremap <Leader>\t :botright vertical term <CR>
"" set terminal window position
" (see possible options at :help vertical)
let g:toggle_terminal#position = 'topleft'
let g:toggle_terminal#command = 'powershell'

:imap jj <Esc>
"enter paste mode
set pastetoggle=<F3>
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
" :set termwinsize=0x100

" In the quickfix window, <CR> is used to jump to the error under the
" cursor, so undefine the mapping there.
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

syntax on

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

" Highlights all text passed the column limit (85)
nnoremap <leader>1 :call ToggleH()<CR>

" Create mappings for searching only in current pkg/Definition etc.. 
let LID_File="/src/ID"

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
Plug 'majutsushi/tagbar'
Plug 'pakutoma/toggle-terminal'

" Syntax handling
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'sheerun/vim-polyglot', { 'branch': 'master', 'do': 'git rebase master arista && git checkout arista' }
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Arista Specific Syntax
Plug 'https://gitlab.aristanetworks.com/jlerner/grokfromvim'
Plug 'https://gitlab.aristanetworks.com/vim-scripts/mts.vim'
Plug 'https://gitlab.aristanetworks.com/vim-scripts/bug.vim', { 'branch': 'master', 'do': 'git rebase master local && git checkout local' }

" System navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Session tracking
Plug 'tpope/vim-obsession'

" Utility
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'szw/vim-maximizer'
Plug 'inkarkat/vim-ingo-library'
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

"
"nnoremap <C-t> :NERDTreeToggle<CR>
"nnoremap <C-i> :NERDTreeFind<CR>

set splitbelow
set splitright

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

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

let g:AutoPairsShortcutToggle = '<Ctrl-p>'
