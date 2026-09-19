-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Terminal em split à direita (o padrão do LazyVim é flutuante).
-- Sobrescreve os 4 keymaps de terminal definidos em lazyvim/config/keymaps.lua.
local function term_right(opts)
  return function()
    Snacks.terminal.toggle(nil, vim.tbl_deep_extend("force", {
      win = { position = "right", width = 0.4 },
    }, opts or {}))
  end
end

local term_root = term_right({ cwd = LazyVim.root() })

vim.keymap.set({ "n", "t" }, "<C-/>", term_root, { desc = "Terminal (Root Dir)" })
vim.keymap.set({ "n", "t" }, "<C-_>", term_root, { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>ft", term_root, { desc = "Terminal (Root Dir)" })
vim.keymap.set("n", "<leader>fT", term_right(), { desc = "Terminal (cwd)" })
