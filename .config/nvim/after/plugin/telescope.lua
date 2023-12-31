local builtin = require('telescope.builtin')

-- TODO: check for OS and on linux use <c-p> mapping
-- IF CTRL-P DOES NOT WORK CHECK UR DOCKER .config SETTINGS
-- YOU NEED "detachKeys": "ctrl-z,z"
vim.keymap.set('n', '<C-p>', builtin.find_files, {})

vim.keymap.set('n', '<a-m>', builtin.find_files, {}) -- REMAP CTRL-P to CTRL-\ on WINDOWS IN POWERTOYS
vim.keymap.set('n', '<a-c>', builtin.commands, {}) -- REMAP CTRL-P to CTRL-\ on WINDOWS IN POWERTOYS
vim.keymap.set('n', '<leader>pf', builtin.git_files, {})
vim.keymap.set('n', '<a-g>', builtin.live_grep, {})
vim.keymap.set('n', '<a-q>', builtin.quickfix, {})

vim.keymap.set('n', '<a-f>', function()
    local current_word = vim.call('expand', '<cword>');
	builtin.grep_string({search = current_word});
end)
