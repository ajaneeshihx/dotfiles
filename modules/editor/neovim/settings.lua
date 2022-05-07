-- ===========================================================================
-- Settings
-- ===========================================================================

vim.o.termguicolors = true --- Set to truecolor
vim.o.hidden = true --- Don't unload buffers when leaving them
vim.wo.number = true --- Show line numbers
vim.wo.relativenumber = true --- Relative numbers instead of absolute
vim.o.list = true --- Reveal whitespace with dashes
vim.o.expandtab = true --- Tabs into spaces
vim.o.shiftwidth = 4 --- Amount to shift with > key
vim.o.softtabstop = 4 --- Amount to shift with <TAB> key
vim.o.ignorecase = true --- Ignore case when searching
vim.o.smartcase = true --- Check case when using capitals in search
vim.o.infercase = true --- Don't match cases when completing suggestions
vim.o.incsearch = true --- Search while typing
vim.o.visualbell = true --- No sounds
vim.o.scrolljump = 1 --- Number of lines to scroll
vim.o.scrolloff = 3 --- Margin of lines to see while scrolling
vim.o.splitright = true --- Vertical splits on the right side
vim.o.splitbelow = true --- Horizontal splits on the bottom side
vim.o.pastetoggle = "<F3>" --- Use F3 to enter raw paste mode
vim.o.clipboard = "unnamedplus" --- Uses system clipboard for yanking
vim.o.updatetime = 300 --- Faster diagnostics
vim.o.mouse = "nv" --- Mouse interaction / scrolling

-- Neovim features
vim.o.inccommand = "split" --- Live preview search and replace
--- Required for nvim-cmp completion
vim.opt.completeopt = {
    "menu",
    "menuone",
    "noselect",
}
-- Required until 0.6.0: do not source the default filetype.vim
vim.g.did_load_filetypes = 1

-- Remember last position when reopening file
vim.api.nvim_exec(
    [[
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
]],
    false
)

-- Better backup, swap and undo storage
vim.o.backup = true --- Easier to recover and more secure
vim.bo.swapfile = false --- Instead of swaps, create backups
vim.bo.undofile = true --- Keeps undos after quit

-- Create backup directories if they don't exist
-- Should be fixed in 0.6 by https://github.com/neovim/neovim/pull/15433
vim.o.backupdir = vim.fn.stdpath("cache") .. "/backup"
vim.api.nvim_exec(
    [[
    if !isdirectory(&backupdir)
        call mkdir(&backupdir, "p")
    endif
]],
    false
)

-- LaTeX options
vim.api.nvim_exec(
    [[
    au FileType tex inoremap ;bf \textbf{}<Esc>i
    au BufWritePost *.tex silent! execute "!pdflatex -output-directory=%:p:h % >/dev/null 2>&1" | redraw!
]],
    false
)

-- Highlight when yanking
vim.api.nvim_exec(
    [[
    au TextYankPost * silent! lua vim.highlight.on_yank { timeout = 250 }
]],
    false
)

-- Netrw
vim.g.netrw_liststyle = 3 -- Change style to 'tree' view
vim.g.netrw_banner = 0 -- Remove useless banner
vim.g.netrw_winsize = 15 -- Explore window takes % of page
vim.g.netrw_browse_split = 4 -- Open in previous window
vim.g.netrw_altv = 1 -- Always split left

-- VimWiki
vim.g.vimwiki_list = {
    {
        ["path"] = "$NOTES_PATH",
        ["syntax"] = "markdown",
        ["index"] = "home",
        ["ext"] = ".md",
    },
}
vim.g.vimwiki_key_mappings = {
    ["all_maps"] = 1,
    ["mouse"] = 1,
}
vim.g.vimwiki_auto_chdir = 1 -- Set local dir to Wiki when open
vim.g.vimwiki_create_link = 0 -- Don't automatically create new links
vim.g.vimwiki_listsyms = " x" -- Set checkbox symbol progression
vim.g.vimwiki_table_mappings = 0 -- VimWiki table keybinds interfere with tab completion
vim.api.nvim_exec(
    [[
    au FileType markdown inoremap ;tt <Esc>:AddTag<CR>

    function! PInsert(item)
        let @z=a:item
        norm "zpx
    endfunction

    command! AddTag call fzf#run({'source': 'rg "#[A-Za-z/]+[ |\$]" -o --no-filename --no-line-number | sort | uniq', 'sink': function('PInsert')})
]],
    false
)
