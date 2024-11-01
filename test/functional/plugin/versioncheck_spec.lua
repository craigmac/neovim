local t = require('test.testutil')
local n = require('test.functional.testnvim')()

local clear = n.clear
local command = n.command
local eq = t.eq
local pathsep = n.get_pathsep()
local fn = n.fn
local api = n.api

local testdir = 'Xtest-versioncheck'

-- an older news.txt file
local cached_news = t.read_file('test/functional/fixtures/news.txt')

local newsfile = n.read_file("$VIMRUNTIME/doc/news.txt")

setup(function()
  n.mkdir_p(testdir)
  t.write_file(testdir .. pathsep .. 'news.txt', cached_news)
end)

teardown(function()
  n.rmdir(testdir)
end)

describe('versioncheck', function()
  before_each(function()
    -- remove -u NONE so runtime/plugin/versioncheck.lua runs
    clear({ args_rm = { '-u' } })
   t.write_file(testdir .. pathsep .. 'news.txt', cached_news)
  end)

  after_each(function()
    n.rmdir(testdir)
  end)

  it('loads', function()
    eq(true, api.nvim_get_option_value('versioncheck', { scope = "global" }))
  end)

  -- it('can be disabled by user option', function()
  --   api.nvim_set_option_value('versioncheck', false, { scope = "global" })
  --   eq(false, api.nvim_get_option_value('versioncheck', { scope = "global" })
  -- end)

  it('does not run when nvim run non-interactively', function()
    t.skip(true)
  end)

  it('only runs on prerelease builds (nightly)', function()
    t.skip(true)
  end)
  


  -- it('', function() pending() end)
end)
