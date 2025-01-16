local t = require('test.testutil')
local n = require('test.functional.testnvim')()

local api = n.api
local clear = n.clear
local eq = t.eq
local fn = n.fn

describe('news_plugin:', function()
  it('loads', function()
    -- `-u NONE` stops the plugin from loading
    -- `-i NONE` turns off shada, which this plugin requires
    clear({ args_rm = { '-u', '-i' } })
    api.nvim_set_client_info('nvim-tui', {}, "remote", {}, {})
    eq(1, fn.exists('news_check'))
  end)

  describe('is skipped when', function()
    it('user disables via global variable', function()
      clear({ args_rm = { '-u', '-i' } })
      api.nvim_set_var('news_check', false)
      eq(false, api.nvim_get_var('news_check'))
    end)

    it('nvim was started with --clean flag', function()
      clear({
        args = { '--clean' },
        args_rm = { '-u', '-i' }
      })
      eq(0, fn.exists('news_check'))
    end)

    -- meaning: embedded and used by something like firenvim, vscode-neovim, etc.
    -- it('nvim builtin nvim-tui UI client is not running', function()
    --   clear({ args_rm = { '-u', '-i' } })
    --   api.nvim_set_client_info('foobar', {}, "embedder", {}, {})
    --   eq(0, fn.exists('news_check'))
    -- end)

    it('shada is turned off', function()
      clear({
        args = { '-i', 'NONE' },
        args_rm = { '-u' }
      })
      eq(0, fn.exists('news_check'))
    end)

    it('shada is missing ability to store/read global vars', function()
      clear({
        args = { '--cmd', "set shada='100" },
        args_rm = { '-u', '-i' },
      })
      eq(0, fn.exists('news_check'))
    end)
  end)
end)
