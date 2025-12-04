return {
	{
		'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
		dependencies = { 'nvim-lua/plenary.nvim' },

		config = function()

			local builtin = require('telescope.builtin')

			vim.keymap.set('n', '<space>ff', function()
				local opts = require('telescope.themes').get_ivy({})
				builtin.find_files(opts)
			end)

			vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[S]earch [H]elp' })
			vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
			vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
			vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
			vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
			vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[S]earch [R]esume' })
			vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

			vim.keymap.set('n', '<leader>/', function()
      	builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
        	winblend = 10,
       	 	previewer = false,
      	}))
    	end, { desc = '[/] Fuzzily search in current buffer' })

    	vim.keymap.set('n', '<leader>s/', function()
      	builtin.live_grep({
        	grep_open_files = true,
        	prompt_title = 'Live Grep in Open Files',
      	})
    	end, { desc = '[S]earch [/] in Open Files' })

    	vim.keymap.set('n', '<leader>fc', function()
      	builtin.find_files({ cwd = vim.fn.stdpath('config') })
    	end, { desc = '[S]earch [N]eovim config files' })
  end,
	},
}
