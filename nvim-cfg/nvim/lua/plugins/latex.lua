return {
  -- O extra lazyvim.plugins.extras.lang.tex traz o vimtex em HEAD, que desde
  -- 2026-07-22 exige nvim 0.12.4 e aborta com `echoerr` no ftplugin/tex.vim.
  -- Esse erro mata a cadeia de autocmds FileType do buffer: o texlab não
  -- anexava, o treesitter não configurava os folds e os binds de fold não
  -- eram criados. v2.18 é a última tag que roda em nvim 0.10+.
  { "lervag/vimtex", tag = "v2.18" },
}
