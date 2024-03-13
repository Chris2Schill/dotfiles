-- if isexecutable('/usr/bin/bash')
    --vim.opt.shell="bash"
    vim.opt.shell = vim.fn.exepath("bash")
    vim.opt.shellcmdflag="-c"
    vim.opt.shellredir=">%s 2>&1"
    vim.opt.shellquote="shellxescape="
    vim.opt.shellxquote=""
    vim.opt.shellpipe="2>&1| tee"
-- endif

local Terminal  = require('toggleterm.terminal').Terminal

-- Show Terminal
vim.keymap.set("n", "<leader>br", ":1ToggleTerm<cr>" )

-- build
vim.keymap.set("n", "<leader>m", ":BuildExe<cr>")
vim.api.nvim_create_user_command("BuildExe", function()
    vim.cmd(":Make -j10 -C " .. vim.g["BUILD_DIRECTORY"])
end, {})

-- run
vim.keymap.set("n", "<leader>r", ":RunExe<cr>")
vim.api.nvim_create_user_command("RunExe", function()
    if vim.g["exe"] ~= nil then
        if vim.g["debug"] == "true" then
            vim.cmd(':call vimspector#Launch()')
        else
            RunTarget(vim.g["exe"])
        end
    else
        vim.cmd([[ :echo 'variable g:exe is not set to a proper target :let g:exe = "program" ']])
    end
end, {})

-- kill
vim.keymap.set("n", "<leader>k", ':KillExe<cr>')
vim.api.nvim_create_user_command("KillExe", function()
    -- vim.cmd(':TermExec cmd="pkill -9 '.. vim.g["exe"] .. '"');
    Terminal:new(
    {
        cmd = "./"..vim.g.exe,
        direction = "float",
        hidden = false,
        count = 10,
    }):open()
end, {})


local function isDebugMode()
    return vim.g.debug == "true"
end

function DebugToggle()
    CloseMenu()
    if vim.g.debug == "true" then
        vim.g.debug = "false"
    else
        vim.g.debug = "true"
    end
    RunMenu()
end


local console_app = Terminal:new(
    {
        -- cmd = "/home/cschilling/spacetraders/spacetraders_tui/build/spacetraders",
        cmd = "/home/cschilling/spacetraders/spacetraders_tui/build/gui/sptr",
        -- cmd = "LD_LIBRARY_PATH=/usr/local/lib /home/cschilling/spacetraders/spacetraders_tui/build/notcute/scroll_area",
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

function RunFloating(exe, cwd)
    Terminal:new(
    {
        cmd = "./"..exe,
        dir = cwd,
        direction = "float",
        hidden = false,
        count = 10,
        float_opts = {
            width = function()
                return math.floor(vim.o.columns * 0.5)
            end,
            height = function()
                return math.floor(vim.o.lines * 0.6)
            end,
        },
    }):open()
end

-- vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>lua _console_app_toggle()<CR>", {noremap = true, silent = true})


-- Generic cmake build
-- vim.keymap.set("n", "<leader>k", ':1TermExec cmd="pkill -9 aar"<cr>')

vim.api.nvim_create_user_command("Erctd3rdPartyInstall", function()
    vim.cmd('1TermExec cmd="pushd /root/erctd/scripts && ./build+install_thirdparty.sh && popd"')
end, {})

local popup = require("plenary.popup")
local job = require("plenary.job")
local BuildDirectoryWindowId
local BUILD_DIRECTORY = "BUILD_DIRECTORY"
local CURRENT_PROJECT = "CURRENT_PROJECT"
local CURRENT_CONFIGURATION = "CURRENT_CONFIGURATION"

local nvim_workspace = {
    currentProject = "current_project",
    buildDirectory = "buildDirectory",
    currentConfiguration = "current_configuration",
}

function ShowMenu(title, opts, cb)
  local height = 10
  local width = 60
  local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

  BuildDirectoryWindowId = popup.create(opts, {
        title = title,
        highlight = "MyProjectWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        callback = cb,
  })
  local bufnr = vim.api.nvim_win_get_buf(BuildDirectoryWindowId)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<cr>", { silent=false })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "d", "<cmd>lua DebugToggle()<cr>",  { silent=false })
end

function CloseMenu()
  vim.api.nvim_win_close(BuildDirectoryWindowId, true)
end

function CMakePresetsMenu()
    local presets = {}
    job:new({
        command = "cmake",
        args = {"--list-presets"},
        on_exit = function(j, _)
            presets = j:result();
        end,
    }):sync()

    local opts = {}
    for i,s in ipairs(presets) do
        if i>2 then
            s = s:gsub('^%s*(.-)%s*$', '%1') -- remove leading whitespace
            s = s:gsub('"', "") -- remove quotes around preset
            table.insert(opts, s)
        end
    end

    ShowMenu("CMake Configuration Presets", opts, function(_, selection)
        local tokens = {}
        tokens[1], tokens[2] = selection:match("%S+")
        vim.cmd([[ :TermExec cmd="cmake --preset ]] .. tokens[1] .. [["]])
    end)
end

function CMakeConfigureDebug(_, _)
    Terminal:new( {
        cmd = "mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Debug ..",
        direction = "float",
        hidden = false,
        count = 20,
        float_opts = {
            width = function()
                return math.floor(vim.o.columns * 0.6)
            end,
            height = function()
                return math.floor(vim.o.lines * 0.9)
            end,
        },
        close_on_exit = false,
    }):open()
end

function CMakeConfigureRelease(_, _)
    Terminal:new( {
        cmd = "mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..",
        direction = "float",
        hidden = false,
        count = 20,
        float_opts = {
            width = function()
                return math.floor(vim.o.columns * 0.6)
            end,
            height = function()
                return math.floor(vim.o.lines * 0.9)
            end,
        },
        close_on_exit = false,
    }):open()
end


function CMakeConfigurePreset(preset, _)
    Terminal:new( {
        cmd = "cmake --preset "..preset,
        direction = "float",
        hidden = false,
        count = 20,
        float_opts = {
            width = function()
                return math.floor(vim.o.columns * 0.6)
            end,
            height = function()
                return math.floor(vim.o.lines * 0.9)
            end,
        },
        close_on_exit = true,
        on_exit = RunMenu,
    }):open()
end

local projects = {
    ["ERCTD"] = {
        cwd="/home/cschilling/erctd",
        configurations = {
            ["linux-gcc-x64-debug"] = {
                path="/home/cschilling/erctd/build/linux-gcc-x64-debug",
                on_load = CMakeConfigurePreset,
            },
            ["linux-gcc-x64-release"] = {
                path="/home/cschilling/erctd/build/linux-gcc-x64-release",
                on_load = CMakeConfigurePreset,
            }
        },
        launch = {
            ["hal"] = {
                target = "hal",
                cwd = "hal/server",
            },
            ["pal"] = {
                target = "pal",
                cwd = "hal/pal",
            },
            ["aar"] = {
                target = "aar --db http://172.28.197.237:8081 --dis-logger http://172.28.197.237:8082",
                cwd = "aar/viewer/gui",
            },
            ["bmc"] = {
                target = "bmc",
                cwd = "bmc",
            },
        }

    },
    ["Neovim Config"] = {
        cwd="~/.config/nvim",
    },
    ["Space Traders"] = {
        cwd="/home/cschilling/spacetraders/spacetraders_tui",
        configurations = {
            ["debug"] = {
                path="/home/cschilling/spacetraders/spacetraders_tui/build",
                on_load = CMakeConfigureDebug,
            },
            ["release"] = {
                path="/home/cschilling/spacetraders/spacetraders_tui/build",
                on_load = CMakeConfigureRelease,
            },
        },
        launch = {
            ["spacetraders"] = {
                target = "spacetraders",
                cwd = "",
            },
            ["sptr"] = {
                target = "sptr",
                cwd = "gui",
            },
        }
    },
}

local function get_keys(t)
  local keys={}
  for key,_ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end

local Project = {
    
}

-- function Project:new(o)
--     o = o or {}
--     setmetatable(o, self)
--     self.__index = self
--     return o
-- end


function getCurrentProject()
    return projects[vim.g.CURRENT_PROJECT]
end

function getCurrentConfiguration()
    return getConfiguration(getCurrentProject(), vim.g.CURRENT_CONFIGURATION)
end

function getCurrentLaunch()
    return getCurrentProject().launch
end

function getConfigurations(project)
    local cfg = project.configurations
    if cfg ~= nil then table.sort(cfg) end
    return cfg
end

function getConfiguration(project, cfg)
    local cfgs = getConfigurations(project)
    if cfgs ~= nil then
        return cfgs[cfg]
    end
    return nil
end

function getCurrentTarget()
    return vim.g.exe
end

function ConfigurationsMenu()
    local configurations = getConfigurations(getCurrentProject())
    if configurations == nil then
        return
    end

    local opts = get_keys(configurations)
    table.sort(opts)

    ShowMenu("Build Configurations", opts, function(_, selection)
        local cfg = configurations[selection]
        vim.g[CURRENT_CONFIGURATION] = selection
        vim.g[BUILD_DIRECTORY] = cfg.path
        cfg.on_load(selection, cfg)
    end)
end


function ProjectsMenu()
    local pjects = get_keys(projects)
    table.sort(pjects)
    ShowMenu("Projects", pjects, function(_, selection)
        vim.g[CURRENT_PROJECT] = selection
        vim.cmd("cd "..projects[selection].cwd)
        vim.cmd([[ :NERDTreeCWD ]])
        ConfigurationsMenu()
    end)
end

function RunTarget(exe)
    local project = projects[vim.g[CURRENT_PROJECT]]
    local launch = project.launch[exe]
    RunFloating(exe, vim.g[BUILD_DIRECTORY].."/"..launch.cwd)
end

function RunMenu()
    local project = projects[vim.g[CURRENT_PROJECT]]
    local tgts = get_keys(project.launch)
    table.sort(tgts)

    local title = "";
    if isDebugMode() then
        title = "Debug Targets"
    else
        title = "Run Targets"
    end

    for i,t in ipairs(tgts) do
        if t == vim.g.exe then
            t = t.."*"
            tgts[i] = t
        end
    end

    ShowMenu(title, tgts, function(_, selection)
        selection = selection:gsub('*','')
        vim.g["exe"] = selection
        RunTarget(selection)
    end)
end

vim.keymap.set("n", "<leader>ps", ProjectsMenu)
vim.keymap.set("n", "<leader>pc", ConfigurationsMenu)
vim.keymap.set("n", "<leader>cm", CMakePresetsMenu)
vim.keymap.set("n", "<leader><leader>r", RunMenu)
