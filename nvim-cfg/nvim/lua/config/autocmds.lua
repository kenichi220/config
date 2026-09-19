-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ---------------------------------------------------------------------------
-- Folding por seção, estilo orgmode
--
--   * arquivos de texto/markup abrem com TUDO retraído (foldlevel = 0)
--   * z<Tab>   cicla o fold sob o cursor
--   * z<S-Tab> cicla todos os folds do buffer
--
-- Mora aqui e não em lua/plugins/ por duas razões:
--   1. um segundo spec de "LazyVim/LazyVim" com init/opts colide com o spec do
--      próprio LazyVim e a função é descartada;
--   2. este arquivo é carregado no startup quando o nvim abre um arquivo, então
--      o autocmd existe antes do primeiro FileType disparar.
--
-- O foldmethod é definido aqui de propósito, em vez de herdar o padrão do
-- LazyVim: LazyVim.set_default() recusa a mudar a opção se algum plugin já
-- mexeu nela no buffer — com o extra lang.tex (vimtex) carregado, o .tex caía
-- em foldmethod=indent e os folds de \section sumiam.
--
-- Requer o parser treesitter da linguagem (`:TSInstall latex markdown bibtex`).
-- ---------------------------------------------------------------------------

-- foldlevel de repouso por filetype: o nível em que o arquivo abre e ao qual
-- z<S-Tab> volta. 0 = tudo retraído.
--
-- No LaTeX o nível 0 já dá a visão de outline do orgmode: com queries/latex/
-- folds.scm restrito a (section)/(subsection), o \begin{document} deixou de ser
-- um fold e as seções passaram a ser o nível mais alto. Nível 0: só as linhas
-- de \section; nível 1: seções abertas, \subsection retraídas.
local FOLDED_FT = {
  markdown = 0,
  tex = 0,
  plaintex = 0,
  bib = 0,
  org = 0,
  norg = 0,
  rst = 0,
  asciidoc = 0,
}

---Aplica o folding e os binds num buffer, se o filetype for de texto e houver
---parser. Sem parser o foldexpr só devolveria 0, então é melhor não mexer.
---@param buf integer
local function setup_folds(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local base = FOLDED_FT[vim.bo[buf].filetype]
  if base == nil then
    return
  end

  local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
  if not lang or not pcall(vim.treesitter.get_parser, buf, lang) then
    return
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt_local.foldenable = true
      vim.opt_local.foldlevel = base
    end)
  end

  -- O treesitter monta a árvore de forma assíncrona: no FileType o
  -- foldlevel ainda não tem fold em que pegar. zx recalcula e reaplica.
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_current_buf() == buf then
      pcall(vim.cmd, "normal! zx")
    end
  end)

  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
  end

  map("z<Tab>", "za", "Fold: cicla sob o cursor")
  map("z<S-Tab>", function()
    -- Alterna entre o outline (nível de repouso) e o arquivo todo aberto.
    if vim.wo.foldlevel > base then
      vim.wo.foldlevel = base
    else
      vim.cmd("normal! zR")
    end
  end, "Fold: outline <-> tudo aberto")
end

vim.opt.foldtext = "" -- linha fechada mostra o próprio texto, com highlight
vim.opt.foldcolumn = "0"
vim.opt.fillchars:append({ fold = " " })

local fold_group = vim.api.nvim_create_augroup("fold_by_section", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = fold_group,
  pattern = vim.tbl_keys(FOLDED_FT),
  callback = function(ev)
    setup_folds(ev.buf)
  end,
})

-- Buffers que já estavam abertos quando este arquivo carregou.
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  setup_folds(buf)
end
