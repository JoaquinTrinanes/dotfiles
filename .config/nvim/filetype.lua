vim.filetype.add({
    pattern = {
        ['%.env'] = 'sh',
        ['%.env%..+'] = 'sh',
        ['%..*rc'] = 'sh',
        ['.*'] = {
            priority = -math.huge,
            function(_, bufnr, _)
                local firstLine = vim.filetype.getlines(bufnr, 1)
                if vim.filetype.matchregex(firstLine, "^\\s*[\\[\\{]") then
                    return 'json'
                end
            end
        }
    }
})
