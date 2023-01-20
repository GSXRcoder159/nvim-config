-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Autocommand that reloads neovim whenever you save this file
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost packer.lua source <afile> | PackerSync
    augroup end
]])

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	use("bluz71/vim-nightfly-guicolors")
	--    use({
	-- 'rose-pine/neovim',
	-- as = 'rose-pine',
	-- config = function()
	-- vim.cmd('colorscheme rose-pine')
	-- end
	-- })

	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("nvim-treesitter/playground")
	use("theprimeagen/harpoon")
	use("mbbill/undotree")
	use("tpope/vim-fugitive")

	-- use('sirver/ultisnips')

	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{
				"neovim/nvim-lspconfig",
				sources = {
					{ name = "luasnip", option = { show_autosnippets = true } },
				},
			},
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{
				"hrsh7th/nvim-cmp",
				requires = {
					{ "kdheepak/cmp-latex-symbols" },
				},
				sources = {
					{
						name = "latex_symbols",
						option = {
							strategy = 0,
						},
					},
				},
			},
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-calc" },
			{ "f3fora/cmp-spell" },
			{ "tamago324/cmp-zsh" },
			{ "quangnguyen30192/cmp-nvim-ultisnips" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
			{
				"quangnguyen30192/cmp-nvim-ultisnips",
				config = function()
					-- optional call to setup (see customization section)
					require("cmp_nvim_ultisnips").setup({
						filetype_source = "treesitter",
						show_snippets = "all",
						documentation = function(snippet)
							return snippet.description
						end,
					})
				end,
				-- If you want to enable filetype detection based on treesitter:
				requires = { "nvim-treesitter/nvim-treesitter" },
			},
		},
		config = function()
			local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
			require("cmp").setup({
				snippet = {
					expand = function(args)
						vim.fn["UltiSnips#Anon"](args.body)
					end,
				},
				sources = {
					{ name = "ultisnips" },
					-- more sources
				},
				-- recommended configuration for <Tab> people:
				-- mapping = {
				-- ["<Tab>"] = cmp.mapping(
				-- function(fallback)
				-- cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
				-- end,
				-- { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
				-- ),
				-- ["<S-Tab>"] = cmp.mapping(
				-- function(fallback)
				-- cmp_ultisnips_mappings.jump_backwards(fallback)
				-- end,
				-- { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
				-- ),
				-- },
			})
		end,
	})

	use({ "lervag/vimtex", ft = { "plaintex", "tex", "latex", "markdown" } })
	use({ "dylanaraps/wal", as = "wal" })
	use("KeitaNakamura/tex-conceal.vim")

	use("vim-pandoc/vim-pandoc")
	use("vim-pandoc/vim-pandoc-syntax")
	-- use('godlygeek/tabular')
	-- use('preservim/vim-markdown')

	-- tmux & split window navigation
	use("christoomey/vim-tmux-navigator")
	use("szw/vim-maximizer") -- maximize and restore windows

	-- essential plugins
	use("tpope/vim-surround")
	use("vim-scripts/ReplaceWithRegister")

	-- commenting with gc
	use("numToStr/Comment.nvim")

	-- file explorer
	use("nvim-tree/nvim-tree.lua")

	-- icons
	use("kyazdani42/nvim-web-devicons")

	-- status line
	use("nvim-lualine/lualine.nvim")

	-- additional lsp packages
	-- use({ "glepnir/lspsaga.nvim", branch = "main" })
	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
		--		config = function()
		--	require("lspsaga").setup({})
		--	end,
	})
	use("onsails/lspkind.nvim")

	-- latex syntax check
	use("neomake/neomake")

	-- linting and formatting
	use("jose-elias-alvarez/null-ls.nvim")
	use("jayp0521/mason-null-ls.nvim")

	-- auto closing brackets and quotes
	use("windwp/nvim-autopairs")
	use("windwp/nvim-ts-autotag")

	-- git integration
	use("lewis6991/gitsigns.nvim")

	-- python autocompletion
	-- use("davidhalter/jedi-vim")
	-- use("zchee/deoplete-jedi")
	-- use("Shougo/context_filetype.vim")
	-- use("tell-k/vim-autopep8")
end)
