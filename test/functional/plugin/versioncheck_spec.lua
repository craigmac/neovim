local t = require('test.testutil')
local n = require('test.functional.testnvim')()

local clear = n.clear
local eq = t.eq
local pathsep = n.get_pathsep()
local api = n.api
local write_file = t.write_file
local rmdir = n.rmdir
local mkdir_p = n.mkdir_p

setup(function()
  local testdir = 'Xtest-versioncheck'
  local cached_news = t.read_file('test/functional/fixtures/news.txt')
  print(cached_news)

  mkdir_p(testdir)
  write_file(testdir .. pathsep .. 'news.txt', cached_news)

  -- TODO: do i need to change the runtimepath value in clear() args like
  -- done in health_spec?
end)

-- teardown(function()
--   rmdir(testdir)
-- end)

describe('versioncheck', function()
  before_each(function()
    -- TODO: research the clear() args needed to run this plugin
    -- remove -u NONE so runtime/plugin/versioncheck.lua runs
    clear({ args_rm = { '-u' } })
  end)

  it('does not run when nvim is started as a Lua interpreter', function()
    clear({ args = { '-l' } })
    eq(false, api.nvim_get_option_value('versioncheck', { scope = "global" }))
  end)

  it('does not run when nvim is a prerelease build (nightly)', function()
    pending()
    -- eq(false, api.nvim_get_option_value('versioncheck', { scope = "global" }))
  end)

  it('does not run when user opts out', function()
    api.nvim_set_var('versioncheck', false)
    eq(false, api.nvim_get_option_value('versioncheck', { scope = "global" }))
  end)

  it('creates a cached news.txt file if it does not exist', function()
    pending()
  end)

end)
