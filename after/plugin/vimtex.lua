vim.g.tex_flavor='latex'
vim.g.vimtex_view_method='zathura'
vim.g.vimtex_quickfix_mode=0
vim.opt.conceallevel=1
vim.g.tex_conceal='abdmg'

-- vim.api.nvim_command('filetype plugin on')
-- vim.opt.encoding=utf8

vim.keymap.set("n", "<leader>S", "<Cmd>write<CR><Cmd>VimtexCompile<CR>")
vim.keymap.set("n", "<leader>s", "<Cmd>write<CR><CR>")
vim.keymap.set("n", "<leader>b", "<Cmd>bnext<CR>")
vim.keymap.set("n", "<leader>sp", "<Cmd>set spell!<CR>")

-- vim.keymap.set("n", "<leader>

vim.cmd([[
    let g:vimtex_toc_config = {
        \ 'name' : 'TOC',
        \ 'layers': ['content', 'todo', 'include'],
        \ 'resize' : 1,
        \ 'split_width' : 50,
        \ 'todo_sorted' : 0,
        \ 'show_help' : 1,
        \ 'show_numbers' : 1,
        \ 'mode' : 2,
        \}
]])
