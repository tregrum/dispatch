local writecb = require("dispatch.writecodeblock")

local M = {}

function M.setup(opts)
  opts = opts or {}

  M.write_markdown_code_block = writecb.WriteMarkdownCodeBlockToFile

  vim.keymap.set("n", "<C-x>", M.write_markdown_code_block)
end

return M
