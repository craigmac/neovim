-- flag to skip running this module
if vim.g.versioncheck == false then return end

-- this plugin is only meant to run on prerelease builds 
if not vim.version().prerelease then return end

-- detect non-interactive startups
if vim.tbl_contains(vim.v.argv, '-l') then return end

-- we are not allowed read/write the shada file, which we need
if vim.tbl_contains(vim.v.argv, '-i NONE') then return end

-- missing '!' in shada option means no storing/reading of global vars
if not vim.o.shada:match('!') then return end

local group = vim.api.nvim_create_augroup("versioncheck", {})
vim.api.nvim_create_autocmd('CursorHold', {
  group = group,
  desc = 'Offer to show detected changes to the runtime news.txt file.',
  callback = function()
    require('versioncheck').check_for_news()
  end,
  once = true,
  nested = true,
})
