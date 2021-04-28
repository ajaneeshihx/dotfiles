" VimWiki
"--------

let g:vimwiki_list = [
  \ {
  \   'path': $NOTES_PATH,
  \   'syntax': 'markdown',
  \   'index': 'home',
  \   'ext': '.md'
  \ }
  \ ]
let g:vimwiki_key_mappings =
  \ {
  \   'all_maps': 1,
  \   'mouse': 1,
  \ }
let g:vimwiki_auto_chdir = 1     " Set local dir to Wiki when open
let g:vimwiki_create_link = 0    " Don't automatically create new links
let g:vimwiki_listsyms = ' x'    " Set checkbox symbol progression
let g:vimwiki_table_mappings = 0 " VimWiki table keybinds interfere with tab completion

" Insert from command-mode into buffer
function! PInsert(item)
    let @z=a:item
    norm "zpx
endfunction

command! AddTag call fzf#run({'source': 'rg "#[\w/]+[ |\$]" -o --no-filename --no-line-number | sort | uniq', 'sink': function('PInsert')})

autocmd FileType markdown inoremap ;tt <Esc>:AddTag<CR>
