-- Local plugin under development, not published. Only load it on machines
-- that have the checkout; elsewhere every BufReadPost would error.
local dir = vim.fn.expand("~/repositories/complexity.nvim")

return {
	dir = dir,
	name = "complexity.nvim",
	cond = vim.uv.fs_stat(dir) ~= nil,
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		position = "above",
		show_value = true,
	},
	keys = {
		{ "<leader>cx", "<cmd>Complexity toggle<cr>", desc = "Toggle complexity hints" },
		{ "<leader>cX", "<cmd>Complexity report<cr>", desc = "Complexity report" },
	},
}
