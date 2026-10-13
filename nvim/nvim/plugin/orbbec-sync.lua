-- Mirror ~/viam/scratchpad/latency-char/orbbec to miti:~/viam/orbbec on every save.
-- Build artifacts and the .git dir are excluded, so each side keeps its own
-- git state and build tree. Manual full sync: :OrbbecSync

local src = vim.fn.expand("~/viam/scratchpad/latency-char/orbbec/")
local dest = "miti:viam/orbbec/"

local function sync(verbose)
  vim.fn.jobstart({
    "rsync", "-az", "--delete",
    "--exclude", ".git/",
    "--exclude", "build*/",
    "--exclude", "venv/",
    "--exclude", "tmp_cpp_sdk/",
    "--exclude", "OrbbecSDK_*",
    "--exclude", "packaging/appimages/deploy/",
    "--exclude", "packaging/appimages/appimage-build/",
    "--exclude", "packaging/appimages/AppDir/",
    "--exclude", "*.AppImage*",
    "--exclude", "module.tar.gz",
    "--exclude", "CMakeUserPresets.json",
    "--exclude", ".VIAM_RELOAD_ARCHIVE.tar.gz",
    src, dest,
  }, {
    on_exit = function(_, code)
      if code ~= 0 then
        vim.notify("orbbec rsync to miti failed (exit " .. code .. ")", vim.log.levels.WARN)
      elseif verbose then
        vim.notify("orbbec synced to miti", vim.log.levels.INFO)
      end
    end,
  })
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = src .. "*",
  callback = function() sync(false) end,
})

vim.api.nvim_create_user_command("OrbbecSync", function() sync(true) end, {})
