local Popup = require("plenary.popup")

local win_id = 0

function CloseMenu()
    vim.api.nvim_win_close(win_id, true)
end

function ShowMenu(title, opts, cb)
    local height = 10
    local width = 60
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

    win_id = Popup.create(opts, {
        title = title,
        highlight = "MyProjectWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        callback = cb,
    })
    local bufnr = vim.api.nvim_win_get_buf(win_id)

    vim.api.nvim_buf_set_option(bufnr, "readonly", true)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<cr>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "d", "<cmd>lua DebugToggle()<cr>", { silent = false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "i", "", { silent = true })
end

return {
    show = ShowMenu,
    close = CloseMenu,
    win_id = win_id
}
