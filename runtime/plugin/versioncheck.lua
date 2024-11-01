-- user flag to opt-out
if not vim.g.versioncheck then
  return
end

-- this plugin is only meant to run on prerelease builds 
if not vim.version().prerelease then
  return
end

-- detect non-interactive startups
if vim.tbl_contains(vim.v.argv, '-l') then
  return
end

-- we are not allowed read/write the shada file, which we need
if vim.tbl_contains(vim.v.argv, '-i NONE') then
  return
end

-- missing '!' in shada option means no storing/reading of global vars
if not vim.o.shada:match('!') then
  return
end

-- TODO: should this go in callback instead? need to figure out timing
-- of when these are set
if vim.g.vscode or vim.g.firenvim then
  return
end

-- global to indicate that we've loaded if we've made it here
vim.g.versioncheck = {}

local augroup = vim.api.nvim_create_augroup("versioncheck", {})

vim.api.nvim_create_autocmd('CursorHold', {
  group = augroup,
  desc = 'Offer to show detected changes to the runtime news.txt file.',
  once = true,
  nested = true,
  callback = function()
    require('versioncheck').check_for_news()
  end,
})
