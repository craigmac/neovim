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
    eq({}, api.nvim_get_var('versioncheck'))
  end)

  it('does not load when user opts out', function()
    command('let g:versioncheck=v:false')
    eq(false, api.nvim_get_var('versioncheck'))
  end)

  it('only loads when nvim is prerelease (nightly) version', function()
    -- TODO: not sure how to test this, because plugin/versioncheck.lua
    -- checks using vim.version() I would have to change the check there?
    pending()
  end)

  it('does not load when nvim is started as a Lua interpreter', function()
    --TODO: no idea how to test this, seems to just run and exit
    --but then I get error because instance has exited?
    pending()
  end)

  it('does not load when shada file cannot be read', function()
    pending()
  end)

  it('does not load when "!" missing from shada option', function()
    pending()
  end)

  it('does not load when running under vscode', function()
    pending()
  end)

  it('does not load when running under firenvim', function()
    pending()
  end)

end)
