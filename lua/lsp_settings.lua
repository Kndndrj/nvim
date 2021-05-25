-------------------------
-- LSP settings: --------
-------------------------

-- Icons
require'lspkind'.init({})

-- Compe settings for autocompletion
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
  };
}

-------------------------
-- Tab completion: ------
-------------------------
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif vim.fn.call('vsnip#available', {1}) == 1 then
    return t '<Plug>(vsnip-expand-or-jump)'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  elseif vim.fn.call('vsnip#jumpable', {-1}) == 1 then
    return t '<Plug>(vsnip-jump-prev)'
  else
    return t '<S-Tab>'
  end
end

-------------------------
-- Autopairs: -----------
-------------------------
require'nvim-autopairs'.setup()

function _G.completions()
  local npairs = require'nvim-autopairs'
  if vim.fn.pumvisible() == 1 then
    if vim.fn.complete_info()['selected'] ~= -1 then
      return vim.fn['compe#confirm']('<CR>')
    end
  end
  return npairs.check_break_line_char()
end

-------------------------
-- Language servers: ----
-------------------------

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- clang
require'lspconfig'.clangd.setup{}

-- gopls
require'lspconfig'.gopls.setup{}

-- rust-analyzer
require'lspconfig'.rust_analyzer.setup{
  capabilities = capabilities
}

-- vscode-html-languageserver
require'lspconfig'.html.setup {
  capabilities = capabilities,
  cmd = { 'vscode-html-languageserver', '--stdio' }
}

-- vscode-json-languageserver
require'lspconfig'.jsonls.setup {
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line('$'),0})
      end
    }
  }
}

-- denols (js, ts, jsx etc.)
require'lspconfig'.denols.setup{}

-- vscode-css-languageserver-bin
require'lspconfig'.cssls.setup {
  capabilities = capabilities
}

-- bash-language-server
require'lspconfig'.bashls.setup{}

-- texlab
require'lspconfig'.texlab.setup{}
