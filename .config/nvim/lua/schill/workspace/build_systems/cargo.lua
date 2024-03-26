local Job = require("plenary.job")

local binaryDir = "."

local function setup()
end

local function build()
    vim.g.makeprg = "cargo"
    vim.cmd(":Make -j10 -C " .. binaryDir)
end

local function showConfigurationsMenu(callback)
    callback("")
end

local function getConfigurationName()
    return ""
end

local function getBinaryDir()
    return binaryDir
end

local function save()
end

local function restore()
end

local function loadTargets()
    print("loading cargo bins")
    local bins = {}

    Job:new({
        command = "cargo",
        args = { "run", "--bin" },
        on_stderr = function(s,j)
            -- print(vim.inspect(j))
            print(vim.inspect(j))
            -- bins = j:result()
        end,
        on_exit = function(j, ret)
            -- print("ret="..ret)
            print("j="..vim.inspect(j))
            -- bins = j:result()
        end,
    }):sync()
    for k,v in pairs(bins) do
        print(k.."="..v)
    end
    -- print(bins)
    --
    -- local count = 0
    -- local opts = {}
    -- for i, s in ipairs(presets) do
    --     if i > 2 then
    --         s = s:gsub('^%s*(.-)%s*$', '%1') -- remove leading whitespace
    --         s = s:gsub('"', "")              -- remove quotes around preset
    --         table.insert(opts, s)
    --     end
    --     count = count + 1
    -- end
    --
    -- local cfgs = {}
    -- for _, preset in ipairs(opts) do
    --     cfgs[preset] = {
    --         -- TODO: get actual build directory from the CMakePresets.json file
    --         binaryDir = "build/" .. preset:match("%S+"),
    --     }
    -- end
    --
    -- if count == 0 then
    --     print("Failed to load CMake Presets")
    --     cfgs = nil
    -- end
    -- return cfgs
end

return {
    setup = setup,
    build = build,
    showConfigurationsMenu = showConfigurationsMenu,
    getConfigurationName = getConfigurationName,
    showTargetsMenu = loadTargets(),
    getBinaryDir = getBinaryDir,
    save = save,
    restore = restore,
}
