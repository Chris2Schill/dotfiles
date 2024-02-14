vim.g.mapleader = ','
vim.keymap.set("n", ",", "<leader>", { noremap = false, silent = true})
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")


vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end)

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.api.nvim_set_keymap('t', '<C-t>', '<C-\\><C-n>', {noremap = true, silent = true})
--vim.api.nvim_set_keymap('t', '<esc>', '<C-\\><C-n><C-w>p', {noremap = true, silent = true})

-- plugin tcomment
vim.keymap.set("n", "<C-_>", "gcc")
vim.keymap.set("i", "<C-_>", "<c-o>:normal gcc")
vim.keymap.set("v", "<C-_>", ":normal gcc")

-- plugin a.vim
vim.keymap.set("n", "<leader>h", ":A<cr>")
vim.keymap.set("n", "<leader><leader>h", "<c-w>v:A<cr>")

vim.keymap.set("n", "<c-s>", ":w<cr>")



vim.keymap.set("n", "cp", ":let @\" = expand(\"%\")<cr>")
-- vim.keymap.set("n", "<c-[>", "vi{")

vim.cmd [[packadd! vimspector]]

--vim.cmd([[ silent! execute "set <M-v>=\<Esc>v" ]])

-- vim.cmd( [[ 
--   let c='a'
--   while c <= 'z'
--     exec "set <A-".c.">=\e".c
--     exec "imap \e".c." <A-".c.">"
--     let c = nr2char(1+char2nr(c))
--   endw
-- ]])
