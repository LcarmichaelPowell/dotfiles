set runtimepath^=/.vim runtimepath+=~/.vim/after

let &packpath = &runtimepath
let g:ale_linters = {
  \ 'typescript': ['deno'],
  \}

let g:ale_fixers = {
  \ 'typescript': ['deno'],
  \}

let g:ale_fix_on_save = 1

if executable("deno")
  augroup LspTypeScript
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
    \ "name": "deno lsp",
    \ "cmd": {server_info -> ["deno", "lsp"]},
    \ "root_uri": {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), "tsconfig.json"))},
    \ "allowlist": ["typescript", "typescript.tsx"],
    \ "initialization_options": {
    \     "enable": v:true,
    \     "lint": v:true,
    \     "unstable": v:true,
    \   },
    \ })
  augroup END
endif

source ~/.vimrc
source ~/.config/nvim/ranger.conf
