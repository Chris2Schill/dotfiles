local workspace = {
    projects = {
        ["EmbedLuaInCpp"] = {
            root = "/home/cschilling/embedlua",
            buildSystem = "cmake",
            configuration_opts = {
                use_cmake_presets = false,
            },
            configurations = {
                ["debug"] = {
                    binaryDir = "/home/cschilling/embedlua/build",
                    flags = { "-DCMAKE_BUILD_TYPE=Debug" },
                },
                ["release"] = {
                    binaryDir = "/home/cschilling/embedlua/build",
                    flags = { "-DCMAKE_BUILD_TYPE=Release" },
                },
            },
            targets = {
                ["embedlua"] = {
                    cmd = "embedlua",
                    cwd = "", -- relative to binaryDir
                },
            },
        },
        ["AdventOfCode2023"] = {
            root = "/home/cschilling/AdventOfCode/2023",
            buildSystem = "cargo",
        },
        ["ERCTD"] = {
            root = "/home/cschilling/erctd",
            buildSystem = "cmake",
            configuration_opts = {
                use_cmake_presets = true,
            },
            targets = {
                ["hal"] = {
                    cmd = "hal",
                    cwd = "hal/server",
                },
                ["pal"] = {
                    cmd = "pal",
                    cwd = "hal/pal",
                },
                ["aar"] = {
                    cmd = "aar --db http://172.28.197.237:8081 --dis-logger http://172.28.197.237:8082",
                    cwd = "aar/viewer/gui",
                },
                ["bmc"] = {
                    cmd = "bmc",
                    cwd = "bmc",
                },
                ["content_server_test"] = {
                    cmd = "content_server_test",
                    cwd = "aar/viewer/core",
                },
            }

        },
        ["Test"] = {
            root = "~/test",
            buildSystem = "make",
            targets = {
                ["test"] = {
                    cmd = "test",
                    cwd = ".",
                },
                ["test2"] = {
                    cmd = "test2",
                    cwd = "."
                }
            }
        },
        ["Space Traders"] = {
            root = "/home/cschilling/spacetraders/spacetraders_tui",
            buildSystem = "cmake",
            configuration_opts = {
                use_cmake_presets = false,
            },
            configurations = {
                ["debug"] = {
                    binaryDir = "/home/cschilling/spacetraders/spacetraders_tui/build",
                    flags = { "-DCMAKE_BUILD_TYPE=Debug" }
                },
                ["release"] = {
                    binaryDir = "/home/cschilling/spacetraders/spacetraders_tui/build",
                    flags = { "-DCMAKE_BUILD_TYPE=Release" }
                },
            },
            targets = {
                ["spacetraders"] = {
                    cmd = "spacetraders",
                    cwd = "",
                },
                ["sptr"] = {
                    cmd = "sptr",
                    cwd = "gui",
                },
            }
        },
    },
}

require("schill.workspace.workspace").setup(workspace)
-- RestoreWorkspace()
