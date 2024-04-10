local M = {}

local api = vim.api

local function get_code_block()
    local filetype = vim.bo.filetype
    if filetype == 'markdown' then
        local line = api.nvim_win_get_cursor(0)[1]
        local lines = api.nvim_buf_get_lines(0, 0, -1, false)
        local start_line, end_line
        local code_lines = {}
        local language = ''

        -- Search for the start of the code block
        for i = line, 1, -1 do
            if lines[i]:match('^```') then
                start_line = i
                language = lines[i]:match('^```(.+)$')
                break
            end
        end

        -- Search for the end of the code block
        for i = line, #lines do
            if lines[i]:match('^```') then
                end_line = i
                break
            end
        end

        -- Extract code lines
        if start_line and end_line then
            for i = start_line + 1, end_line - 1 do
                table.insert(code_lines, lines[i])
            end
        end

        return language, code_lines
    end
end

local function write_to_file(language, contents)
    local filename = ".codexblock"
    local file = io.open(filename, 'w')
    if file then
        if language ~= '' then
            file:write('#!/usr/bin/env ' .. language .. '\n\n')
        end
        for _, line in ipairs(contents) do
            file:write(line .. '\n')
        end
        file:close()
        print('Code block written to ' .. filename)
    else
        print('Error opening file ' .. filename)
    end
end


function M.WriteMarkdownCodeBlockToFile()
    local language, code_lines = get_code_block()
    if code_lines then
        write_to_file(language, code_lines)
    end
end

return M
