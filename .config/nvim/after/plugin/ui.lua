-- local function currentProject()
--     return "Project:"..vim.g["CURRENT_PROJECT"]
-- end
--
-- local function currentConfiguration()
--     return vim.g["CURRENT_CONFIGURATION"]
-- end

-- local custom_gruvbox = require'lualine.themes.gruvbox'
-- custom_gruvbox.normal.c.bg = '#111111'
-- custom_gruvbox.insert.c.bg = '#111111'
-- custom_gruvbox.command.c.bg = '#111111'
-- custom_gruvbox.visual.c.bg = '#111111'
local colors = {
  black        = '#282828',
  white        = '#ebdbb2',
  red          = '#fb4934',
  green        = '#b8bb26',
  blue         = '#83a598',
  yellow       = '#fe8019',
  purple         = '#a89984',
  -- gray     = '#777777',
  -- darkgray     = '#222222',
  darkgray     = "#070707",
  lightgray    = '#504945',
  inactivegray = '#7c6f64',
  disabled     = '#111111',
}
local custom =  {
  normal = {
    a = {bg = colors.purple, fg = colors.black, gui = 'bold'},
    b = {bg = colors.darkgray, fg = colors.white},
    c = {bg = colors.darkgray, fg = colors.purple}
  },
  insert = {
    a = {bg = colors.blue, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.lightgray, fg = colors.white}
  },
  visual = {
    a = {bg = colors.yellow, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.inactivegray, fg = colors.black}
  },
  replace = {
    a = {bg = colors.red, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.black, fg = colors.white}
  },
  command = {
    a = {bg = colors.green, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.inactivegray, fg = colors.black}
  },
  inactive = {
    a = {bg = colors.disabled, fg = colors.purple, gui = 'bold'},
    b = {bg = colors.disabled, fg = colors.purple},
    c = {bg = colors.disabled, fg = colors.purple}
  }
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = custom,
    component_separators = { left = '|', right = '|'},
    -- section_separators = { left = '', right = ''},
    section_separators = { left = ' ', right = '|'},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'g:CURRENT_PROJECT', 'g:CURRENT_CONFIGURATION','g:exe',--[['encoding', 'fileformat', --]] 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
