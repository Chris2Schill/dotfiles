local M = {}

local cursor ={ }

-- M.saveCursorPos = function()
-- function SaveCursorPos()
--     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--     cursor = {
--         line,
--         col
--     }
-- end
--
-- -- M.restoreCursor = function()
-- function RestoreCursorPos()
--     local lastline = vim.fn.line("$")
--     -- vim.fn.winrestview(original_cursor)
--     if cursor.line > lastline then
--         cursor.line = lastline
--     end
--     vim.api.nvim_win_set_cursor({ 0 }, { cursor.line, cursor.col })
-- end

M.preserve = function(arguments)
    local arguments = string.format("keepjumps keeppatterns execute %q", arguments)
    -- local original_cursor = vim.fn.winsaveview()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_command(arguments)
    local lastline = vim.fn.line("$")
    -- vim.fn.winrestview(original_cursor)
    if line > lastline then
        line = lastline
    end
    vim.api.nvim_win_set_cursor({ 0 }, { line, col })
end

return M