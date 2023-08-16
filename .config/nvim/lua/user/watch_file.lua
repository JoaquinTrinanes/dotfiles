local w = vim.loop.new_fs_event()

---@param path string
---@param callback function
local function watch_file(path, callback)
  if w == nil then
    return
  end
  w:start(
    path,
    {},
    vim.schedule_wrap(function(...)
      callback(...)
    end)
  )
end

return watch_file
