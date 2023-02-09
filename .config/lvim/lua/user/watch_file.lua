local w = vim.loop.new_fs_event()

local function watch_file(path, callback)
	w:start(
		path,
		{},
		vim.schedule_wrap(function(...)
			callback(...)
		end)
	)
end

return watch_file