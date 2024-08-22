local options = {
  formatters_by_ft = {
    lua = { "stylua" },
     css = { "prettier" },
     html = { "prettier" },
     javascript = { "prettier" },
     javascriptreact = { "prettier" },
     typescript = { "prettier" },
     typescriptreact = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
