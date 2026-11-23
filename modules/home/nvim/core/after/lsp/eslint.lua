-- bug with eslint running in html
-- need to do some debugging on who eslint finds the workspace root
return {
    settings = {
        workingDirectory = {
            mode = 'location'
        }
    },
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
}
