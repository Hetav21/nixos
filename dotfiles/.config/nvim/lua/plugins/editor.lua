-- Editor: Enhancements

return {
  -- Marks (use "'" prefix for delete to avoid conflict with explorer d/m keys)
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      default_mappings = false,
      mappings = {
        set_next = "m,",
        toggle = "m;",
        preview = "m:",
        next = "m]",
        prev = "m[",
        delete = "'d",
        delete_line = "'D",
        delete_buf = "'x",
        set_bookmark0 = "m0",
        set_bookmark1 = "m1",
        set_bookmark2 = "m2",
        set_bookmark3 = "m3",
        set_bookmark4 = "m4",
        set_bookmark5 = "m5",
        set_bookmark6 = "m6",
        set_bookmark7 = "m7",
        set_bookmark8 = "m8",
        set_bookmark9 = "m9",
        delete_bookmark = "'=",
        delete_bookmark0 = "'0",
        delete_bookmark1 = "'1",
        delete_bookmark2 = "'2",
        delete_bookmark3 = "'3",
        delete_bookmark4 = "'4",
        delete_bookmark5 = "'5",
        delete_bookmark6 = "'6",
        delete_bookmark7 = "'7",
        delete_bookmark8 = "'8",
        delete_bookmark9 = "'9",
        prev_bookmark = "m{",
        next_bookmark = "m}",
        prev_bookmark0 = "[0",
        prev_bookmark1 = "[1",
        prev_bookmark2 = "[2",
        prev_bookmark3 = "[3",
        prev_bookmark4 = "[4",
        prev_bookmark5 = "[5",
        prev_bookmark6 = "[6",
        prev_bookmark7 = "[7",
        prev_bookmark8 = "[8",
        prev_bookmark9 = "[9",
        next_bookmark0 = "]0",
        next_bookmark1 = "]1",
        next_bookmark2 = "]2",
        next_bookmark3 = "]3",
        next_bookmark4 = "]4",
        next_bookmark5 = "]5",
        next_bookmark6 = "]6",
        next_bookmark7 = "]7",
        next_bookmark8 = "]8",
        next_bookmark9 = "]9",
      },
    },
  },

  -- Todo Comments
  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        multiline = true,
      },
    },
  },

  -- Better Quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {},
  },

  -- Session Management
  {
    "folke/persistence.nvim",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize" },
    },
  },

  -- Undo Tree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
    },
  },

  -- Hardtime (habit training)
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      enabled = false,
      max_count = 4,
    },
    keys = {
      { "<leader>uH", "<cmd>Hardtime toggle<cr>", desc = "Toggle Hardtime" },
    },
  },
}
