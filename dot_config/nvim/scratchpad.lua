local function test(pattern)
  local root = vim.loop.cwd()
  print(root)
  local handle = vim.loop.fs_scandir(root)
  local entry = vim.loop.fs_scandir_next(handle)

  while entry do
    print(type(entry))
    if entry:match(pattern) then
      print(entry)
      return true
    end

    entry = vim.loop.fs_scandir_next(handle)
  end

  return false
end

test("styl*")
