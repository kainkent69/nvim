return {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  config = function()
    local mc = require 'multicursor-nvim'

    mc.setup()

    local set = vim.keymap.set

    -- Add or skip cursor above/below the main cursor.
    set({ 'n', 'x' }, '<up>', function()
      mc.lineAddCursor(-1)
    end, { desc = 'Add cursor above' })
    set({ 'n', 'x' }, '<down>', function()
      mc.lineAddCursor(1)
    end, { desc = 'Add cursor below' })
    set({ 'n', 'x' }, '<leader><up>', function()
      mc.lineSkipCursor(-1)
    end, { desc = 'Skip cursor above' })
    set({ 'n', 'x' }, '<leader><down>', function()
      mc.lineSkipCursor(1)
    end, { desc = 'Skip cursor below' })

    -- Add or skip adding a new cursor by matching word/selection
    set({ 'n', 'x' }, '<leader>mn', function()
      mc.matchAddCursor(1)
    end, { desc = 'Add cursor to next match' })
    set({ 'n', 'x' }, '<leader>ms', function()
      mc.matchSkipCursor(1)
    end, { desc = 'Skip cursor to next match' })
    set({ 'n', 'x' }, '<leader>mN', function()
      mc.matchAddCursor(-1)
    end, { desc = 'Add cursor to previous match' })
    set({ 'n', 'x' }, '<leader>mS', function()
      mc.matchSkipCursor(-1)
    end, { desc = 'Skip cursor to previous match' })

    -- In normal/visual mode, press `mwap` will create a cursor in every match of
    -- the word captured by `iw` (or visually selected range) inside the bigger
    -- range specified by `ap`. Useful to replace a word inside a function, e.g. mwif.
    set({ 'n', 'x' }, 'mw', function()
      mc.operator { motion = 'iw', visual = true }
    end, { desc = 'Add cursors to all matches of word' })

    -- Press `mWi"ap` will create a cursor in every match of string captured by `i"` inside range `ap`.
    set('n', 'mW', mc.operator, { desc = 'Add cursors to all matches of motion' })

    -- Add all matches in the document
    set({ 'n', 'x' }, '<leader>A', mc.matchAllAddCursors, { desc = 'Add cursors to all matches in document' })

    -- Rotate the main cursor.
    set({ 'n', 'x' }, '<left>', mc.nextCursor, { desc = 'Rotate to next cursor' })
    set({ 'n', 'x' }, '<right>', mc.prevCursor, { desc = 'Rotate to previous cursor' })

    -- Delete the main cursor.
    set({ 'n', 'x' }, '<leader>mx', mc.deleteCursor, { desc = 'Delete main cursor' })

    -- Add and remove cursors with control + left click.
    set('n', '<c-leftmouse>', mc.handleMouse, { desc = 'Add/remove cursor with Ctrl+LeftMouse' })
    set('n', '<c-leftdrag>', mc.handleMouseDrag, { desc = 'Drag to add/remove cursors' })
    set('n', '<c-leftrelease>', mc.handleMouseRelease, { desc = 'Release drag' })

    -- Easy way to add and remove cursors using the main cursor.
    set({ 'n', 'x' }, '<c-q>', mc.toggleCursor, { desc = 'Toggle cursor' })

    -- Clone every cursor and disable the originals.
    set({ 'n', 'x' }, '<leader><c-q>', mc.duplicateCursors, { desc = 'Duplicate cursors' })

    set('n', '<esc>', function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      elseif mc.hasCursors() then
        mc.clearCursors()
      else
        vim.cmd 'nohlsearch'
      end
    end, { desc = 'Clear multicursor, or search highlighting' })

    -- bring back cursors if you accidentally clear them
    set('n', '<leader>bb', mc.restoreCursors, { desc = 'Restore Cursors' })

    -- Align cursor columns.
    set('n', '<leader>a', mc.alignCursors, { desc = 'Align Cursors' })

    -- Split visual selections by regex.
    set('x', 'S', mc.splitCursors, { desc = 'Split Cursor' })

    -- Append/insert for each line of visual selections.
    set('x', 'I', mc.insertVisual, { desc = 'Insert Visual' })
    set('x', 'A', mc.appendVisual, { desc = 'Append Visual' })

    -- match new cursors within visual selections by regex.
    set('x', 'M', mc.matchCursors, { desc = 'Match Cursors' })

    -- Rotate visual selection contents.
    set('x', '<leader>t', function()
      mc.transposeCursors(1)
    end, { desc = 'Transpose Cursors' })
    set('x', '<leader>T', function()
      mc.transposeCursors(-1)
    end, { desc = 'Transpose Cursors Reverse' })

    -- Jumplist support
    set({ 'x', 'n' }, '<c-i>', mc.jumpForward, { desc = 'Jump Forward' })
    set({ 'x', 'n' }, '<c-o>', mc.jumpBackward, { desc = 'Jump Backward' })

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, 'MultiCursorCursor', { link = 'Cursor' })
    hl(0, 'MultiCursorVisual', { link = 'Visual' })
    hl(0, 'MultiCursorSign', { link = 'SignColumn' })
    hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
    hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
    hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
    hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
  end,
}
