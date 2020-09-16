RELOAD('plenary')
RELOAD('telescope')

require('telescope')

local profiler = require('plenary.profile.lua_profiler')

local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')

PERF_DEBUG = 455
vim.api.nvim_buf_set_lines(PERF_DEBUG, 0, -1, false, {})

local cwd = vim.fn.expand("~/plugins/telescope.nvim")

profiler.start()

pickers.new {
  prompt = 'Large search',
  finder = finders.new_oneshot_job(
    {"fdfind"},
    {
      cwd = cwd,
      entry_maker = make_entry.gen_from_file {cwd = cwd},
      -- disable_devicons = true,
      -- maximum_results = 1000,
    }
  ),
  sorter = sorters.get_fuzzy_file(),
  previewer = previewers.cat.new{cwd = cwd},
}:find()


COMPLETED = false
print(vim.wait(3000, function()
  vim.cmd [[redraw!]]
  return COMPLETED
end, 100))
profiler.stop()
profiler.report('/home/tj/tmp/profiler_score.txt')
-- vim.cmd [[bd!]]
-- vim.cmd [[stopinsert]]
