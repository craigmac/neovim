--- @brief
--- VersionCheck is a runtime plugin enabled only on prerelease ("nightly")
--- builds. It's meant to help those tracking Nvim HEAD see what, if anything,
--- has changed in the runtime news.txt file since the last time nvim was
--- started.

--- @brief [g:versioncheck]()
---
--- VersionCheck is enabled by default on prerelease ("nightly") builds.
--- To disable it, add to your config:
---
--- ```lua
--- vim.g.versioncheck = false
--- ```
local M = {}

--- @private
--- Overwrite any cached news.txt file with current runtime news.txt contents
local function write_news_to_cache()
  local cache_fh, err = io.open(vim.fs.normalize(vim.fn.stdpath('state') .. '/news.txt'), 'w+')
  if err then error(err) end

  local news_fh, err = io.open(vim.fs.normalize('$VIMRUNTIME/doc/news.txt'))
  if err then error(err) end


  local news = news_fh:read('*a')
  if news then cache_fh:write(news) end

  news_fh:close()
  cache_fh:close()
end

--- @private
--- @return boolean true if hashes match
local function hashes_match()
  local current_news_hash = vim.fn.sha256(vim.fs.normalize('$VIMRUNTIME/doc/news.txt'))
  local cached_news_hash = vim.fn.sha256(vim.fs.normalize(vim.fn.stdpath('state') .. '/news.txt'))
  return current_news_hash == cached_news_hash
end

--- @private
--- Asks user if they'd like to see the news
---@return boolean Returns `true` if user agrees to prompt
local function user_wants_diff()
  local result = vim.fn.confirm('VersionCheck: news file changed - view changes?', '&yes\n&no', 1)
  return result == 1
end

---@private
local function show_news_diff()
  vim.cmd.tabedit(vim.fs.normalize('$VIMRUNTIME/doc/news.txt'))
  vim.cmd.diffsplit(vim.fs.normalize(vim.fn.stdpath('state') .. '/news.txt'))
end

function M.check_for_news()
  local current_version = vim.version()

  -- early exit condition - no version cached in `:help shada-file`
  if vim.g.NVIM_VERSION == nil then
    vim.g.NVIM_VERSION = current_version
    write_news_to_cache()
    return
  end

  if vim.version.lt(vim.g.NVIM_VERSION, current_version) then
    vim.g.NVIM_VERSION = current_version
    if user_wants_diff() then show_news_diff() end
  elseif vim.version.eq(vim.g.NVIM_VERSION, current_version) then
    -- vim.version() variables are reporting equal,
    -- but the contents of news file can still differ so check hashes
    if not hashes_match() and user_wants_diff() then
      show_news_diff()
    end
  end
end

return M