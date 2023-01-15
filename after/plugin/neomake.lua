local neomake_setup, neomake = pcall(require, "neomake")
if not neomake_setup then
    return
end

vim.cmd([[
    call neomake#configure#automake('nrwi', 500)
]])

vim.g.neomake_open_list = 2
