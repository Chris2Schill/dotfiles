local binaryDir = "."

local function setup()
end

local function build()
    vim.g.makeprg = "make"
    vim.cmd(":Make -j10 -C " .. binaryDir)
end

local function showConfigurationsMenu(callback)
    callback("")
end

local function getBinaryDir()
    return binaryDir
end

local function getConfigurationName()
    return ""
end

local function save()
end

local function restore()
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
