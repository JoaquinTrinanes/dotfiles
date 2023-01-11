vim.filetype.add({
	extension = {
		nu = "nushell",
	},
	pattern = {
		["%.env%..+"] = "sh",
	},
})
