local M = {}

local function getGitBranch()
    local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
    if handle then
        local branch = handle:read("*a"):gsub("%s+", "")
        handle:close()
        return branch ~= "" and branch or ""
    end
    return ""
end

local function fileIsExisting(filePath)
    local file = io.open(filePath, "r")
    if file then
        file:close()
        return true
    else
        return false
    end
end

local function create_file_with_dir(dir, filename)
    local filepath = dir .. "/" .. filename
    -- Check if the directory exists, and if not, create it
    if not fileIsExisting(filepath) then
        if dir and os.execute("mkdir -p " .. dir) then
            -- Create the file
            local file = io.open(filepath, "w")
            if file then
                file:close()
                print("File created: " .. filepath)
            else
                print("Failed to create file: " .. filepath)
            end
        end
    end
end

function M.setup(opts)
    local cwd = vim.fn.getcwd()
    local gitBranch = getGitBranch()
    local sessionName = "git-branch-" .. gitBranch .. ".vim"
    local sessionDir = cwd .. "/" .. (rawget(opts, "sessionDir") or ".tmp")

    local sessionFilePath = sessionDir .. "/" .. sessionName
    create_file_with_dir(sessionDir, sessionName)
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            local cmd = vim.api.nvim_parse_cmd(("source " .. sessionFilePath), {})
            vim.api.nvim_cmd(cmd, {})
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(bufnr) then
                    vim.api.nvim_buf_call(bufnr, function()
                        vim.cmd("doautocmd BufRead")
                    end)
                end
            end
        end
    })
    vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
            local cmd = vim.api.nvim_parse_cmd(("mksession! " .. sessionFilePath), {})
            vim.api.nvim_cmd(cmd, {})
            print("create session when leave: " .. sessionFilePath)
        end
    })
end

return M
