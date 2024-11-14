local t = require('test.testutil')
local n = require('test.functional.testnvim')()

local clear = n.clear
local eq = t.eq
local pathsep = n.get_pathsep()
local api = n.api
local write_file = t.write_file
local read_file = t.read_file
local command = n.command

local testdir = 'Xtest-versioncheck'

local cached_news = read_file('test/functional/fixtures/versioncheck/old_news.txt')
local news = read_file("test/functional/fixtures/versioncheck/news.txt")

describe('versioncheck', function()
  setup(function()
    n.mkdir_p(testdir)
    write_file(testdir .. pathsep .. 'Xcached_news.txt', cached_news)
    write_file(testdir .. pathsep .. 'Xnews.txt', news)
  end)

  before_each(function()
    -- remove default flag so that runtime/plugin/versioncheck.lua will be run
    clear({ args_rm = { '-u' } })
  end)

  teardown(function()
    n.rmdir(testdir)
  end)

  it('loads', function()
    eq(true api.nvim_get_var('versioncheck'))
  end)
  
  -- editorconfig_spec does it this way, using lua values
  -- it('can be disabled globally', function()
  --   api.nvim_set_var('editorconfig', false)
  --   api.nvim_set_option_value('shiftwidth', 42, {})
  --   test_case('3_space.txt', { shiftwidth = 42 })
  -- end)

  it('can be disabled globally', function()
    api.nvim_set_var('editorconfig', false)
    -- clear({
    --   args_rm = { '-u' },
    --   init = [[
    --     let g:versioncheck=v:false
    --     " Let's verify the variable is actually set
    --     echo g:versioncheck
    --   ]]
    -- })
    -- First verify that our global variable was set correctly
    -- eq(false, api.nvim_get_var('versioncheck'))
    
    -- Now reload the plugin to see if it respects the setting
    -- command('runtime plugin/versioncheck.lua')
    
    -- Check the variable again
    -- eq(nil, api.nvim_get_var('versioncheck'))
  end)

  -- it('only loads when nvim is prerelease (nightly) version', function()
  --     local real_version = vim.version
  --     vim.version = function() 
  --       return {
  --         major = 0,
  --         minor = 9,
  --         patch = 2,
  --         prerelease = false
  --       }
  --     end
  --   eq(nil, api.nvim_get_var('versioncheck'))
  --   vim.version = real_version
  -- end)

  -- it('does not load when nvim is started as a Lua interpreter', function()
  --   clear({ args = { '-l' } })
  --   eq(nil, api.nvim_get_var('versioncheck'))
  -- end)

  -- it('does not load when shada file cannot be read', function()
  --   before_each(function()
  --     clear({ args = { '-i', 'NONE' } })
  --   end)
  --   eq(nil, api.nvim_get_var('versioncheck'))
  -- end)

  -- it('does not load when "!" missing from shada option', function()
  --   before_each(function()
  --     command('set shada=\'100')
  --   end)
  --   eq(nil, api.nvim_get_var('versioncheck'))
  -- end)

  -- it('does not load when running under vscode', function()
  --   before_each(function() 
  --     command('let g:vscode=v:true')
  --   end)
  --   eq(nil, api.nvim_get_var('versioncheck'))
  -- end)

  -- it('does not load when running under firenvim', function()
  --   before_each(function()
  --     command('let g:firenvim=v:true')
  --   end)
  --   eq(nil, api.nvim_get_var('versioncheck'))
  -- end)

end)
