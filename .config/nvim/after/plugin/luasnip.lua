local ls = require("luasnip")

vim.keymap.set({"i"} , "<c-k>", function() ls.jump(1) end, {silent = true})
vim.keymap.set({"i"} , "<c-j>", function() ls.jump(-1) end, {silent = true})
