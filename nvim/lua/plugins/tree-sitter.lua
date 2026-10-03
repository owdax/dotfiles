return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		ts.setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		local available = {}
		for _, lang in ipairs(ts.get_available()) do
			available[lang] = true
		end

		local function start(buf, lang)
			if vim.api.nvim_buf_is_valid(buf) then
				pcall(vim.treesitter.start, buf, lang)
			end
		end

		-- Highlight every filetype with a parser. A parser nvim-treesitter knows
		-- but hasn't built yet is installed in the background first (needs the
		-- tree-sitter CLI from the Brewfile); highlighting starts when it's ready.
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(args.match)
				if not lang then
					return
				end
				if available[lang] and not vim.list_contains(ts.get_installed("parsers"), lang) then
					ts.install(lang):await(function(err)
						if not err then
							vim.schedule(function()
								start(args.buf, lang)
							end)
						end
					end)
				else
					start(args.buf, lang)
				end
			end,
		})
	end,
}
