-- Mirror ~/viam/rospad to tracer:~/viam/rospad (tracer2a at 10.1.67.196) on
-- every save.
-- --delete: a file deleted or renamed here goes away on tracer2a too. Excluded
-- paths are never deleted there. .git goes along, so the image labels that
-- viam-docker writes from the checkout (commit, dirty) match this tree.
-- Map databases and build output stay here: the repo holds gigabytes of
-- miti maps.
-- ClearAllForwardings: rsync must not bind a forwarded port on each save. The
-- tracer host entry has none at this time; the ttracer tunnel entry forwards
-- 8765 for Foxglove.
-- Manual full sync: :RospadSync

local src = vim.fn.expand("~/viam/rospad/")
local dest = "tracer:viam/rospad/"

local function sync(verbose)
  vim.fn.jobstart({
    "rsync", "-az", "--delete",
    "-e", "ssh -o ClearAllForwardings=yes",
    "--exclude", "build/",
    "--exclude", "install/",
    "--exclude", "log/",
    "--exclude", "logs/",
    "--exclude", "bags/",
    "--exclude", "maps/",
    "--exclude", "venv/",
    "--exclude", "__pycache__/",
    "--exclude", "*.pyc",
    "--exclude", "/.pkg/",
    "--exclude", "/.claude/",
    "--exclude", "*.db",
    "--exclude", "*.db-shm",
    "--exclude", "*.db-wal",
    "--exclude", "/config/viam-attributes.json",
    "--exclude", "/nav-locations.json",
    "--exclude", "/nav2_locations.json",
    "--exclude", ".DS_Store",
    "--exclude", "*.swp",
    src, dest,
  }, {
    on_exit = function(_, code)
      if code ~= 0 then
        vim.notify("rospad rsync to tracer failed (exit " .. code .. ")", vim.log.levels.WARN)
      elseif verbose then
        vim.notify("rospad synced to tracer", vim.log.levels.INFO)
      end
    end,
  })
end

local group = vim.api.nvim_create_augroup("RospadSync", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  pattern = src .. "*",
  callback = function() sync(false) end,
})

vim.api.nvim_create_user_command("RospadSync", function() sync(true) end, { force = true })
