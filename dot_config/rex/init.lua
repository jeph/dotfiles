-- Vim-style pane navigation, replacing the default alt+cmd+arrow focus keys.
rex.bind("ctrl+h", "pane.focus.left")
rex.bind("ctrl+j", "pane.focus.down")
rex.bind("ctrl+k", "pane.focus.up")
rex.bind("ctrl+l", "pane.focus.right")

rex.unbind("alt+cmd+left", "pane.focus.left")
rex.unbind("alt+cmd+down", "pane.focus.down")
rex.unbind("alt+cmd+up", "pane.focus.up")
rex.unbind("alt+cmd+right", "pane.focus.right")

-- Move panes: Ctrl+Shift with the same direction keys as focus.
rex.bind("ctrl+shift+h", "pane.move.left")
rex.bind("ctrl+shift+j", "pane.move.down")
rex.bind("ctrl+shift+k", "pane.move.up")
rex.bind("ctrl+shift+l", "pane.move.right")

-- Split panes: Alt+Shift; the new pane opens on that side.
rex.bind("alt+shift+h", "pane.split.left")
rex.bind("alt+shift+j", "pane.split.down")
rex.bind("alt+shift+k", "pane.split.up")
rex.bind("alt+shift+l", "pane.split.right")
