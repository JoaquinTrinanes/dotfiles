vim.api.nvim_create_user_command('Autoformat',
    function()
        vim.lsp.buf.format()
    end,
    {}
    )
