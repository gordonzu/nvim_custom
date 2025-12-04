return {
	{
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
				lua = { 'stylua' },
				python = { 'black' },
				go = { 'goimports', 'gofmt' },
				csharp = { 'csharpier' },
				scala = { 'scalafmt' },
			},
			format_on_save = {
				timeout_ms = 500,
    		lsp_format = "fallback",
			},
    },
  },
}
