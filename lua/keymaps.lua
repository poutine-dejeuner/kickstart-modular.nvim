vim.keymap.set('n', '<leader><CR>', function()
  vim.cmd 'write'
  vim.fn.system 'tmux send-keys -t last-window C-p Enter'
end, { noremap = true, silent = true })

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('i', 'jk', '<Esc>')
-- vim.keymap.set('n', '<A-h>', '<cmd>ToggleTerm<CR>')
vim.keymap.set('n', '<C-t>', function()
  require('toggle-bool').toggle_bool()
end, { noremap = true, silent = true })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to [G]o [D]efinition' })

-- [[ visual line navigation ]]
-- These keymaps will navigate visual lines when the cursor is on a wrapped line
vim.keymap.set('n', 'j', 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })
vim.keymap.set('n', 'k', 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set('t', '<Esc><Ec>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- [[ Integration avec tmux ]]
-- ce code va se déplacer vers une fenêtre nvim si elle existe, sinon il va se
-- déplacer vers une fenêtre tmux avec `tmux select-pane`
local function smart_move(direction, tmux_cmd)
  local curwin = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. direction)
  if curwin == vim.api.nvim_get_current_win() then
    vim.fn.system('tmux select-pane ' .. tmux_cmd)
  end
end

vim.keymap.set('n', '<C-h>', function()
  smart_move('h', '-L')
end, { silent = true })
vim.keymap.set('n', '<C-j>', function()
  smart_move('j', '-D')
end, { silent = true })
vim.keymap.set('n', '<C-k>', function()
  smart_move('k', '-U')
end, { silent = true })
vim.keymap.set('n', '<C-l>', function()
  smart_move('l', '-R')
end, { silent = true })

-- Sauter d'une demi-fenêtre de lignes visuelles
local scroll_visual = function(dir)
  local height = vim.api.nvim_win_get_height(0)
  local count = math.floor(height / 2)
  return dir == 'down' and count .. 'gj' or count .. 'gk'
end
vim.keymap.set('n', '<C-d>', function()
  return scroll_visual 'down'
end, { expr = true })
vim.keymap.set('n', '<C-u>', function()
  return scroll_visual 'up'
end, { expr = true })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- navigation de buffers
vim.keymap.set('n', '<leader>n', ':bn<cr>')
vim.keymap.set('n', '<leader>p', ':bp<cr>')
vim.keymap.set('n', '<leader>x', ':bd<cr>')

vim.keymap.set('v', '<leader>c', function()
  -- 1. Demander à l'utilisateur de saisir le caractère <C>
  local char = vim.fn.input('Caractère de séparation : ')
  
  -- Si l'utilisateur n'a rien saisi ou a fait Échap, on annule
  if char == "" then return end

  -- 2. Sauvegarder le contenu et le type du registre sans-nom
  local old_reg = vim.fn.getreg('"')
  local old_regtype = vim.fn.getregtype('"')

  -- 3. Couper la sélection visuelle (sélection automatique du registre '"')
  -- 'gv' re-sélectionne le bloc, 'd' le coupe
  vim.cmd('normal! d')

  -- 4. Récupérer le texte qui vient d'être coupé
  local selection = vim.fn.getreg('"')

  -- 5. Construire la nouvelle chaîne : <C><sélection><C>
  local new_text = char .. selection .. char

  -- 6. Placer le nouveau texte dans le registre et le coller
  vim.fn.setreg('"', new_text, 'v')
  vim.cmd('normal! p')

  -- 7. Restaurer l'ancien registre pour ne pas polluer l'historique de yank
  vim.fn.setreg('"', old_reg, old_regtype)
end, { silent = true, desc = "Envelopper la sélection entre deux caractères identiques" })

-- vim: ts=2 sts=2 sw=2 et
