return {

  {"numToStr/Comment.nvim", 
		opts = {
			vim.keymap.set('n', '<leader>/', function() 
				require('Comment.api').toggle.linewise.current()
			end),

			vim.keymap.set('v', '<leader>/', function()
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
					'nx',
					false
				)
				require('Comment.api').toggle.linewise(vim.fn.visualmode())
			end),
		},
	},

}
