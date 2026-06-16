local M = {}

M.git = {
  branch = "",
  added = "",
  modified = "",
  removed = "",
}

M.git_status = {
  ["!"] = " ",
  ["?"] = M.git.added,
  ["A"] = M.git.added,
  ["C"] = M.git.added,
  ["D"] = M.git.removed,
  ["M"] = M.git.modified,
  ["R"] = M.git.modified,
  ["T"] = M.git.modified,
  ["U"] = M.git.modified,
  [" "] = " ",
}

return M
