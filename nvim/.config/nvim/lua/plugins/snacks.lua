return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      hidden = true,
      ignored = true,
      exclude = {
        ".git",
        "node_modules",
        "__pycache__",
        ".DS_Store",
        "thumbs.db",
      },
      sources = {
        files = {
          hidden = true,
          ignored = true,
        },
        git_files = {
          untracked = true,
          submodules = true,
        },
        grep = {
          hidden = true,
          ignored = true,
        },
        smart = {
          hidden = true,
          ignored = true,
        },
        explorer = {
          exclude = {
            ".git",
            "node_modules",
            "__pycache__",
            ".DS_Store",
            "thumbs.db",
          },
        },
      },
    },
  },
}
