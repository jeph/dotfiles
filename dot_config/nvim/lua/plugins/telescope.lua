return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>ff", LazyVim.pick("files", { hidden = true }), desc = "Find Files (root dir)" },
    { "<leader><leader>", LazyVim.pick("files", { hidden = true }), desc = "Find Files (root dir)" },
  },
}
