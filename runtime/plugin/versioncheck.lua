local enable = vim.F.if_nil(vim.g.versioncheck, vim.g.vscode, vim.g.firenvim, true)
if not enable then
  return
end

-- end if not using a prerelease (nightly) build
if not vim.version().prerelease then
  return
end

-- end if nvim was started as lua interpreter
if vim.tbl_contains(vim.v.argv, '-l') then
  return
end

-- end if we can't read/write the shada file
if vim.tbl_contains(vim.v.argv, '-i NONE') then
  return
end

-- end if missing ability to store/read global vars in shada file
if not vim.o.shada:match('!') then
  return
end

vim.g.versioncheck = true

local augroup = vim.api.nvim_create_augroup("versioncheck", {})

vim.api.nvim_create_autocmd('CursorHold', {
  group = augroup,
  desc = 'Notify user changes have been detected in the news.txt file.',
  once = true,
  nested = true,
  callback = function()
    require('versioncheck').check_for_news()
  end,
})
