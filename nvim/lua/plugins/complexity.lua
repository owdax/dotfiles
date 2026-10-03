return {
	dir = vim.fn.expand("~/repositories/complexity.nvim"),
	name = "complexity.nvim",
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
