
return {
{
	'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
			'bash',
			'c',
			'cpp',
			'diff',
			'html',
			'lua',
			'markdown',
			'python',
			'scala',
			'go',
			'vimdoc',
		},
    auto_install = true,
    highlight = {
    	enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true, disable = { 'ruby' } },
  },
},
}


