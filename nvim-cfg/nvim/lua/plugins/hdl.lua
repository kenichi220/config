return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "verilog" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        svls = {},
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "svls" })
    end,
  },
}
