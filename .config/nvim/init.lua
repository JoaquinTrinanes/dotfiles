local files = {
	"config",
	"load-plugins",
	"commands",
	"lsp",
	"keymap",
	"theme",
	"render-whitespace",
}

local errors = {}

-- load all config, throw possible errors later
for _, file in ipairs(files) do
	local ok, error = pcall(require, "my." .. file)
	if not ok then
		table.insert(errors, error)
	end
end

for _, delayed_error in ipairs(errors) do
	error(delayed_error)
end
