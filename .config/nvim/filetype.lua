vim.filetype.add({
    pattern = {
        ['%.env'] = 'sh',
        ['%.env%..+'] = 'sh',
        ['%..*rc'] = 'sh'
    }
})
