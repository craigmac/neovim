local M = {}

---@private
--- Overwrite cached news file in `stdpath('state')` with `$VIMRUNTIME/doc/news.txt`
local function _write_news_to_cache()
  local cache_fh, err = io.open(vim.fs.normalize(vim.fn.stdpath('state') .. '/news.txt'), 'w+')
  if not cache_fh then vim.notify(err) return end

  local news_fh, err = io.open(vim.fs.normalize('$VIMRUNTIME/doc/news.txt'))
  if not news_fh then vim.notify(err) return end

  local news = news_fh:read('*a')
  cache_fh:write(news)

  news_fh:close()
  cache_fh:close()
end

---@private
--- Returns whether the sha256 hash of the current `$VIMRUNTIME/doc/news.txt`
--- file is equal to the hash of the cached version.
---@return boolean Returns `true` if hashes are different
local function _can_be_diffed()
  local current_news_hash = vim.fn.sha256(vim.fs.normalize('$VIMRUNTIME/doc/news.txt'))
  local cached_news_hash = vim.fn.sha256(vim.fs.normalize(vim.fn.stdpath('state') .. '/news.txt'))
  return current_news_hash == cached_news_hash
end

---@private
--- Asks user if they'd like to see the news
---@return boolean Returns `true` if user agrees to prompt
local function _user_wants_diff()
  local result = vim.fn.confirm('VersionCheck: news file changed - view changes?', '&yes\n&no', 1)
  return result == 1
end

---@private
local function _show_news_diff()
  vim.cmd.tabedit(vim.fs.normalize('$VIMRUNTIME/doc/news.txt'))
  vim.cmd.diffsplit(vim.fs.normalize(vim.fn.stdpath('state') .. '/news.txt'))
end

---Entrypoint for module, called by `$VIMRUNTIME/runtime/plugin/versioncheck.lua`
function M.check_for_news()
  local current_version = vim.version()

  -- early exit condition - no version cached in `:help shada-file`
  if vim.g.NVIM_VERSION == nil then
    vim.g.NVIM_VERSION = current_version
    _write_news_to_cache()
    return
  end

  if vim.version.lt(vim.g.NVIM_VERSION, current_version) then
    vim.g.NVIM_VERSION = current_version
    if _user_wants_diff() then _show_news_diff() end
  elseif vim.version.eq(vim.g.NVIM_VERSION, current_version) then
    -- equal reported versions, but the contents of news file can still differ
    if _can_be_diffed() and _user_wants_diff() then
      _show_news_diff()
    end
  end
end

return M
