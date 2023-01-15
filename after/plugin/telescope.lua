local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fs', builtin.live_grep, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- local telescoscope = pcall(require, "telescope")
-- if not telescope_setup then
--     return
-- end
--
-- local actions_setup, actions = pcall(require, "telescope.actions")
-- if not actions_setup then
--     return
-- end
--
-- telescope.setup({
--     defaults = {
--         mappings = {
--             i = {
--                 ["<C-k>"] = actions.move_selection_previous,
--                 ["<C-j>"] = actions.move_selection_next,
--                 ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
--             }
--         }
--     }
-- })

-- telescope.load_extension("fzf")

