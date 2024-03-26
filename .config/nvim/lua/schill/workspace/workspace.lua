require("lfs")
-- if isexecutable('/usr/bin/bash')
--vim.opt.shell="bash"
vim.opt.shell = vim.fn.exepath("bash")
vim.opt.shellcmdflag = "-c"
vim.opt.shellredir = ">%s 2>&1"
vim.opt.shellquote = "shellxescape="
vim.opt.shellxquote = ""
vim.opt.shellpipe = "2>&1| tee"
-- endif

local Terminal = require('toggleterm.terminal').Terminal
local Popup = require("plenary.popup")
local Menu = require("schill.workspace.menu")
local Utils = require("schill.utils")

local build_systems = {
    cmake = require('schill.workspace.build_systems.cmake'),
    make = require('schill.workspace.build_systems.make'),
    cargo = require('schill.workspace.build_systems.cargo'),
}

local BuildSystem

local function workspaceJsonFileName()
    return vim.fn.stdpath('data') .. "/workspace.json"
end


local Selection = {
    project = "",
    configuration = "",
    target = "",
}
Selection.__index = Selection

local function loadProject(pject)
    Selection.project = pject
    local project = Selection:projectFrom(Workspace)
    vim.cmd("cd " .. project.root)
    vim.cmd([[ :NERDTreeCWD ]])
    Selection:updateGlobals()
end

local function loadTarget(target)
    target = target:gsub('*', '')
    Selection.target = target
    Selection:updateGlobals()
end


function Selection:projectFrom(workspace)
    return workspace.projects[self.project]
end

function Selection:configurationFrom(workspace)
    return Selection:projectFrom(workspace).configurations[self.configuration]
end

function Selection:targetFrom(workspace)
    return Selection:projectFrom(workspace).targets[self.target]
end

function Selection:updateGlobals()
    vim.g.workspace_current_project = self.project
    vim.g.workspace_current_configuration = self.configuration:match("%S+")
    vim.g.workspace_current_target = self.target
end

function Selection:save()
    lfs.mkdir(vim.fn.stdpath('data').."/workspace")
    lfs.mkdir(vim.fn.stdpath('data').."/workspace/buildSystems")

    local state = {
        project = self.project,
        configuration = self.configuration,
        target = self.target,
    }

    local jsonobj = vim.fn.json_encode(state)

    local file = io.open(workspaceJsonFileName(), "w")
    if file ~= nil then
        file:write(jsonobj)
        file:close()
    else
        print("Error saving workspace state")
    end

    BuildSystem.save()
end

function GetBuildSystem(buildSystem)
    if buildSystem == "cmake" then
        return build_systems.cmake
    elseif buildSystem == "make" then
        return build_systems.make
    elseif buildSystem == "cargo" then
        return build_systems.cargo
    end
end

function Selection:restore()
    local file = io.open(workspaceJsonFileName(), "r")
    if file ~= nil then
        local state = vim.fn.json_decode(file:read('*a'))
        -- print("Selection="..vim.inspect.inspect(selection))
        Selection.project = state.project
        Selection.configuration = state.configuration
        Selection.target = state.target
    end
    print("Selection=" .. vim.inspect.inspect(Selection))

    loadProject(Selection.project)
    local project = Selection:projectFrom(Workspace)

    -- local cfg = project.configurations[Selection.configuration]

    BuildSystem = GetBuildSystem(project.buildSystem)
    BuildSystem.restore()
    -- BuildSystem.setup({
    --     opts = project.configuration_opts,
    --     configs = project.configurations,
    -- })
    loadTarget(Selection.target)

    self:updateGlobals()
end

function RestoreWorkspace()
    Selection:restore()
end

function RunTermHorizontal(exe, cwd)
    Terminal:new(
        {
            cmd = "./" .. exe,
            dir = cwd,
            direction = "horizontal",
            hidden = false,
        }):open()
end

function RunFloating(exe, cwd)
    Terminal:new(
        {
            cmd = "./" .. exe,
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

local function isDebugMode()
    return vim.g.debug == "true"
end

function DebugToggle()
    Menu.close()
    if vim.g.debug == "true" then
        vim.g.debug = "false"
    else
        vim.g.debug = "true"
    end
    TargetsMenu()
end

local function get_keys(t)
    local keys = {}
    for key, _ in pairs(t) do
        table.insert(keys, key)
    end
    return keys
end


function ProjectsMenu()
    local projects = get_keys(Workspace.projects)
    table.sort(projects)
    Menu.show("Projects", projects, function(_, selection)
        loadProject(selection)
        ConfigurationsMenu()
        Selection:save()
    end)
end

function ConfigurationsMenu()
    local configurations = Selection:projectFrom(Workspace).configurations

    local callback = function(selection)
        -- loadConfiguration(selection)
        Selection.configuration = selection
        TargetsMenu()
        Selection:save()
    end

    local project = Selection:projectFrom(Workspace)

    local buildSystem = project.buildSystem
    local configuration_opts = project.configuration_opts
    -- local targets = project.targets

    BuildSystem = GetBuildSystem(buildSystem)
    BuildSystem.setup({
        opts = configuration_opts,
        configs = configurations,
        -- targets = targets,
    })
    BuildSystem.showConfigurationsMenu(callback)
end

function RunTarget(target)
    -- print(vim.inspect.inspect(target))
    -- local project = Selection:projectFrom(Workspace)
    -- local cfg = Selection:configurationFrom(Workspace)
    local tgt = Selection:targetFrom(Workspace)

    local cwd = BuildSystem.getBinaryDir().."/"..tgt.cwd
    print(cwd)
    RunTermHorizontal(tgt.cmd, cwd)
end

function TargetsMenu()
    local project = Selection:projectFrom(Workspace)
    local tgts = get_keys(project.targets)
    table.sort(tgts)

    local title = "";
    if isDebugMode() then
        title = "Debug Targets"
    else
        title = "Run Targets"
    end

    -- Add a '*' to the seleted target
    for i, t in ipairs(tgts) do
        if t == Selection.target then
            t = t .. "*"
            tgts[i] = t
        end
    end

    Menu.show(title, tgts, function(_, selection)
        Selection.target = selection
        loadTarget(selection)
        Selection:save()
        -- RunTarget(selection)
    end)
end

vim.keymap.set("n", "<leader>ps", ProjectsMenu)       -- show workspaces
vim.keymap.set("n", "<leader>pc", ConfigurationsMenu) -- show configurations
-- vim.keymap.set("n", "<leader>cm", CMakePresetsMenu)   -- show cmake presets
vim.keymap.set("n", "<leader><leader>r", TargetsMenu) -- show run targets
vim.keymap.set("n", "<leader>br", ":1ToggleTerm<cr>") -- Show Terminal

vim.keymap.set("n", "<leader>m", ":BuildExe<cr>")     -- do build
vim.keymap.set("n", "<leader>r", ":RunExe<cr>")       -- do run
vim.keymap.set("n", "<leader>k", ':KillExe<cr>')      -- dokill

-- :BuildExe
vim.api.nvim_create_user_command("BuildExe", function()
    BuildSystem.build()
end, {})

-- :RunExe
vim.api.nvim_create_user_command("RunExe", function()
    local target = Selection:targetFrom(Workspace)
    if Selection.target ~= nil then
        if vim.g["debug"] == "true" then
            vim.cmd(":call vimspector#LaunchWithSettings(#{configuration: '"..Selection.target.."'}"..")")
        else
            RunTarget(Selection.target)
        end
    else
        vim.cmd([[ :echo 'variable g:exe is not set to a proper target :let g:exe = "program" ']])
    end
end, {})

-- :KillExe
vim.api.nvim_create_user_command("KillExe", function()
    -- vim.cmd(':TermExec cmd="pkill -9 '.. vim.g["exe"] .. '"');
    Terminal:new(
        {
            cmd = "./" .. Selection.target,
            direction = "float",
            hidden = false,
            count = 10,
        }):open()
end, {})


vim.api.nvim_create_user_command("Erctd3rdPartyInstall", function()
    vim.cmd('1TermExec cmd="pushd /root/erctd/scripts && ./build+install_thirdparty.sh && popd"')
end, {})


local function setup(workspace)
    Workspace = workspace
end

return {
    setup = setup,
}
