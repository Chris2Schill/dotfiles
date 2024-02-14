-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
--vim.cmd [[packadd packer.nvim]]
--

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end


local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- My plugins here
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    -- or                          , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use('ellisonleao/gruvbox.nvim')
  use('tomtom/tcomment_vim')

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  -- use {'nvim-treesitter/nvim-treesitter',
  --         -- commit = '3f44b89',
  --         run = ':TSUpdate'
  --     }
  use('nvim-treesitter/nvim-treesitter-textobjects')
  use('nvim-treesitter/playground')
  use('ThePrimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-repeat')
  use('tpope/vim-fugitive')
  use('tpope/vim-dispatch')
  use('radenling/vim-dispatch-neovim')
  use('akinsho/toggleterm.nvim')
  --use('voldikss/vim-floaterm')
  use('vim-scripts/a.vim')
  use('preservim/nerdtree')
  use('brooth/far.vim')
  use('christoomey/vim-tmux-navigator')

  use {
    requires = { "nvim-treesitter/nvim-treesitter" },
    "Badhi/nvim-treesitter-cpp-tools",
}
  -- use{'famiu/feline.nvim', branch = '0.5-compat'}

  -- use {
  --     'Vonr/align.nvim',
  --     branch = "v2"
  -- }
  use {'echasnovski/mini.align'}

  use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  use( 'puremourning/vimspector'
      --cmd = { "VimspectorInstall", "VimspectorUpdate" },
      --fn = { "vimspector#Launch()", "vimspector#ToggleBreakpoint", "vimspector#Continue" }
  )

  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v2.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},             -- Required
		  {                                      -- Optional
		  'williamboman/mason.nvim',
		  run = function()
			  pcall(vim.cmd, 'MasonUpdate')
		  end,
          },
          {'williamboman/mason-lspconfig.nvim'}, -- Optional

          -- Autocompletion
          {'hrsh7th/nvim-cmp'},     -- Required
          {'hrsh7th/cmp-nvim-lsp'}, -- Required
          {'L3MON4D3/LuaSnip'},     -- Required
      }
  }

  use {
      'folke/trouble.nvim',
      requires = {
          { "nvim-tree/nvim-web-devicons" }
      }
  }

	
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

--return require('packer').startup(function(use)
  -- Packer can manage itself
 -- use 'wbthomason/packer.nvim'
--end)


