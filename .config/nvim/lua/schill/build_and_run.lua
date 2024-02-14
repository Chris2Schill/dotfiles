--if isexecutable('/usr/bin/bash')
    --vim.opt.shell="bash"
    vim.opt.shell = vim.fn.exepath("bash")
    vim.opt.shellcmdflag="-c"
    vim.opt.shellredir=">%s 2>&1"
    vim.opt.shellquote="shellxescape="
    vim.opt.shellxquote=""
    vim.opt.shellpipe="2>&1| tee"
--endif
TMP="/tmp"

--vim.keymap.set("n", "<F5>", ':Dispatch "cmake --build -j10 --preset win32-gcc-x64-mingw-debug"<cr>')

vim.keymap.set("n", "<leader>br", ":ToggleTerm<cr>" )
-- vim.keymap.set("n", "<leader>c", ':1TermExec cmd="cmake --preset win32-gcc-x64-mingw-debug-with-unit-testing"<cr>')
-- vim.keymap.set("n", "<leader>m", ':1TermExec cmd="cmake --build -j10 --preset win32-gcc-x64-mingw-debug-with-unit-testing"<cr>')
-- vim.keymap.set("n", "<leader>rt", ':1TermExec cmd="pushd build/win32-gcc-x64-mingw-debug-with-unit-testing && ctest ; popd"<cr>')

-- linux debug
vim.keymap.set("n", "<leader>c", ':1TermExec cmd="cmake --preset linux-gcc-x64-debug"<cr>')
-- vim.keymap.set("n", "<leader>m", ':1TermExec cmd="cmake --build -j10 --preset linux-gcc-x64-debug"<cr>')


-- build
vim.keymap.set("n", "<leader>m", ":BuildExe<cr>")
vim.api.nvim_create_user_command("BuildExe", function()
    vim.cmd(':1TermExec cmd="clear ;clear && cmake --build . -j10"');
end, {})

-- run
vim.keymap.set("n", "<leader>r", ":RunExe<cr>")
-- vim.keymap.set("n", "<leader>r", ':2TermExec cmd="/root/erctd/build/linux-gcc-x64-debug/aar/viewer/gui/aar"<cr>')

vim.api.nvim_create_user_command("RunExe", function()
    if vim.g["exe"] ~= nil then
        if vim.g["debug"] == "true" then
            vim.cmd(':call vimspector#Launch()')
        else
            vim.cmd(':2TermExec cmd="./'.. vim.g["exe"] .. '"');
        end
    else
        vim.cmd([[ :echo 'variable g:exe is not set to a proper target :let g:exe = "program" ']])
    end

end, {})

-- kill
vim.keymap.set("n", "<leader>k", ':KillExe<cr>')
vim.api.nvim_create_user_command("KillExe", function()
    vim.cmd(':2TermExec cmd="pkill -9 '.. vim.g["exe"] .. '"');
end, {})


local Terminal  = require('toggleterm.terminal').Terminal
local console_app = Terminal:new(
    {
        -- cmd = "LD_LIBRARY_PATH=/usr/local/lib /root/spacetraders/spacetraders_tui/build/spacetraders",
        cmd = "LD_LIBRARY_PATH=/usr/local/lib /root/spacetraders/spacetraders_tui/build/notcute/scroll_area",
        -- cmd = "/root/erctd/build/linux-gcc-x64-debug/aar/viewer/gui/aar --db http://172.28.192.1:8081 --dks-logger http://172.28.192.1:8082",
        -- cmd = "LD_LIBRARY_PATH=/usr/local/lib /root/erctd/build/linux-gcc-x64-debug/hal/server/udp_backend",
        -- cmd = "LD_LIBRARY_PATH=/usr/local/lib /root/erctd/build/linux-gcc-x64-debug/hal/server/plugins/fsi_simio/icd_codegen /root/erctd/hal/server/plugins/fsi_simio/sio_host.icd",
        -- cmd = "/root/erctd/build/linux-gcc-x64-debug/hal/server/plugins/fsi_simio/fsi_simio_host_emulator",
        -- cmd = "/root/erctd/build/linux-gcc-x64-debug/hal/pal/pal",
        direction = "float",
        hidden = true,
        count = 10,
        float_opts = {
            width = function()
                return math.floor(vim.o.columns * 0.5)
            end,
            height = function()
                return math.floor(vim.o.lines * 0.6)
            end,
        }
    }
)

function _console_app_toggle()
    console_app:open()
end

vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>lua _console_app_toggle()<CR>", {noremap = true, silent = true})


-- Generic cmake build
-- vim.keymap.set("n", "<leader>k", ':1TermExec cmd="pkill -9 aar"<cr>')


-- vim.keymap.set("n", "<leader>c", ':1TermExec cmd="cmake --preset win32-gcc-x64-mingw-debug-with-unit-testing"<cr>')
-- vim.keymap.set("n", "<leader>m", ':1TermExec cmd="cmake --build -j10 --preset win32-gcc-x64-mingw-debug-with-unit-testing"<cr>')
-- vim.keymap.set("n", "<leader>rt", ':1TermExec cmd="pushd build/win32-gcc-x64-mingw-debug-with-unit-testing && ctest ; popd"<cr>')

-- vim.keymap.set("n", "<leader>m", ':1TermExec cmd="go build && ./learngo"<cr>')
--vim.keymap.set("n", "<leader>r", ':TermExec cmd="pushd ./build/win32-gcc-x64-mingw-debug/imguiapp/ && ./imguiapp.exe && popd"<cr>')
--

vim.api.nvim_create_user_command("Erctd3rdPartyInstall", function()
    vim.cmd('1TermExec cmd="pushd /root/erctd/scripts && ./build+install_thirdparty.sh && popd"')
end, {})

