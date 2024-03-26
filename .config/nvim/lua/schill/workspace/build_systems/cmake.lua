local Terminal = require('toggleterm.terminal').Terminal
local Job = require("plenary.job")
local Menu = require("schill.workspace.menu")

-- Options data structure
local configuration_opts = {
    use_cmake_presets = false
}
local configurations = {}
local configuration
local configurationName = ""
local configurationLoadedCb

local function get_keys(t)
    local keys = {}
    for key, _ in pairs(t) do
        table.insert(keys, key)
    end
    return keys
end

function CMakeConfigure(flags)
    local args = ""
    for _,flag in ipairs(flags) do
        args = args.." "..flag.." "
    end

    Terminal:new({
        cmd = "mkdir -p build && cd build && cmake "..args.."..",
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
        on_exit = function() configurationLoadedCb(configurationName) end,
    }):open()
end

function CMakeConfigurePreset(presetDesc)

    local preset =  presetDesc:match("%S+")

    Terminal:new({
        cmd = "cmake --preset " .. preset,
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
        on_exit = function() configurationLoadedCb(configurationName) end,
    }):open()
end

-- Returns a list of configurations derived from CMakePresets.json
local function loadCMakePresets()
    print("loading cmake presets")
    local presets = {}
    Job:new({
        command = "cmake",
        args = { "--list-presets" },
        on_exit = function(j, _)
            presets = j:result();
        end,
    }):sync()

    local count = 0
    local opts = {}
    for i, s in ipairs(presets) do
        if i > 2 then
            s = s:gsub('^%s*(.-)%s*$', '%1') -- remove leading whitespace
            s = s:gsub('"', "")              -- remove quotes around preset
            table.insert(opts, s)
        end
        count = count + 1
    end

    local cfgs = {}
    for _, preset in ipairs(opts) do
        cfgs[preset] = {
            -- TODO: get actual build directory from the CMakePresets.json file
            binaryDir = "build/" .. preset:match("%S+"),
        }
    end

    if count == 0 then
        print("Failed to load CMake Presets")
        cfgs = nil
    end
    return cfgs
end

local function setup(s)
    configuration_opts = s.opts

    if configuration_opts.use_cmake_presets then
        local cfgs = loadCMakePresets()
        if cfgs == nil then
            print("Failed to load CMake Presets")
            return
        end

        configurations = cfgs
    else
        configurations = s.configs
    end
end

local function loadConfiguration(config)
    configurationName = config
    configuration = configurations[config]
    -- Selection:updateGlobals()
    local flags = ""
    if configuration.flags ~= nil then
        flags = configuration.flags
    end

    if configuration_opts.use_cmake_presets then
        CMakeConfigurePreset(config)
    else
        CMakeConfigure(flags)
    end
end

local function showConfigurationsMenu(callback)
    configurationLoadedCb = callback
    local windowTitle = "CMake Build Configurations"
    if configuration_opts.use_cmake_presets then
        windowTitle = "CMake Configuration Presets"
    end

    if configurations == nil then
        -- print("No build configurations specified for " .. Selection.project)
        print("No build configurations specified.")
        return
    end

    local cfgs = get_keys(configurations)
    table.sort(cfgs)

    Menu.show(windowTitle, cfgs, function(_, selection)
        loadConfiguration(selection)
    end)
end

local function build()
    if configuration ~= nil then
        vim.g.makeprg = "make"
        vim.cmd(":Make -j10 -C " .. configuration.binaryDir)
    end
end

local function getBinaryDir()
    return configuration.binaryDir
end

local function getConfigurationName()
    return configurationName
end

local function save()
    local state = {
        configurationName = configurationName,
        configurations = configurations,
        configuration_opts = configuration_opts,
    }
    local jsonobj = vim.fn.json_encode(state)

    local filename = vim.fn.stdpath('data') .. "/workspace/buildSystems/cmake.json"
    local file = io.open(filename, "w")
    if file ~= nil then
        file:write(jsonobj)
        file:close()
    else
        print("Error saving workspace.buildSystems.cmake state")
    end
end

local function restore()
    local filename = vim.fn.stdpath('data') .. "/workspace/buildSystems/cmake.json"
    local file = io.open(filename, "r")
    if file ~= nil then
        local state = vim.fn.json_decode(file:read('*a'))
        setup({
            opts = state.configuration_opts,
            configs = state.configurations,
        })
        loadConfiguration(state.configurationName)
    end
end

return {
    setup = setup,
    build = build,
    showConfigurationsMenu = showConfigurationsMenu,
    getConfigurationName = getConfigurationName,
    getBinaryDir = getBinaryDir,
    save = save,
    restore = restore,
}
