vim.api.nvim_set_var('far#enable_undo', 1)
vim.api.nvim_set_var('far#source', 'rg')
-- vim.api.nvim_set_var('far#ignore_files', '~/farignore')
vim.keymap.set('n', '<leader>far', ':Far <C-r><C-w>  /<Left><Left>', { noremap = true, silent = false })
