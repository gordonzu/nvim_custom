return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			styles = {
				commentStyle = { italic = true },
				keywordStyle = { italic = false },
				functionStyle = { italic = false },
				statementStyle = { italic = false },
				typeStyle = { italic = false },
			},

			overrides = function()
				return {
					["@variable.builtin"] = { italic = false },
				}
			end,
		})
		vim.cmd("set background=dark")
		vim.cmd("colorscheme kanagawa-dragon")
	end,
}
