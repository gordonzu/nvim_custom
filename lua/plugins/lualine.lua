return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			local lualine = require("lualine")
			local material = require("lualine.themes.material")

			lualine.setup({
				options = {
					theme = material,
					section_separators = "",
					component_separators = "",
				},

				sections = {
					lualine_a = {
						function()
							local mode_map = {
								["n"] = "N",
								["i"] = "I",
								["v"] = "V",
								["V"] = "VL",
								[""] = "VB", -- Visual Block
								["c"] = "C",
								["s"] = "S",
								["S"] = "SL",
								[""] = "SB", -- Select Block
								["R"] = "R",
								["r"] = "r",
								["!"] = "SH",
								["t"] = "T",
							}
							return mode_map[vim.api.nvim_get_mode().mode] or "UNK"
						end,
					},

					lualine_b = { "branch", "diff" },
					lualine_c = {
						{ "filename" },
						{ trouble, mode = "diagnostics", icons = true },
						{ path = 1 },
						{ symbols = { modified = " ●", readonly = " ", unnamed = " [No Name]" } },
					},
					lualine_x = {
						{ "diagnostics" },

						{
							function()
								local clients = vim.lsp.get_clients({ bufnr = 0 })
								if not clients or next(clients) == nil then
									return ""
								end
								local names = {}
								for _, client in ipairs(clients) do
									table.insert(names, client.name)
								end
								return " " .. table.concat(names, ", ")
							end,
						},

						{ "encoding" },
						{ "fileformat" },
						{ "filetype" },
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
}
