local dashboard_header = table.concat({
  "⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠀⠀⠀⣀⡤⠖⠛⠋⠉⠉⠛⠒⠦⣄⡀          ",
  "⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⡤⣴⠞⠁⠀⠀⠀⠀⠀⠀⣠⡴⢦⣄⣙⣦⣀⣀⣀⣤⣀    ",
  "⠀⠀⠀⢀⣠⠴⠖⠛⠉⠁⢀⣴⠋⠀⠀⠀⠀⠀⠀⠀⢸⡇⠚⣦⠹⠏⠁⠀⠉⠙⠳⣌⣧   ",
  "⢀⡤⠞⠉⠀⠀⠀⠀⢠⡶⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⠚⢃⡴⠚⠲⣄⠀⠀⢠⡾⢧   ",
  "⡞⠀⠀⣠⡶⠶⠾⢿⢻⡀⠀⠀⡀⠀⠀⠀⠀⢀⣠⣤⠄⠀⠀⢿⣀⣠⣆⠿⠚⠉⠛⠶⣼⣄  ",
  "⣧⠀⠀⢿⣄⠀⠀⠈⠉⠛⠛⠛⠛⠳⢶⣶⡶⠋⠁⠀⠀⠀⠀⣼⠛⠉⠀⠀⠀⢠⠀⠄⢸⣎⣷⡄",
  "⠈⠳⣄⣸⠋⠓⠦⣤⣀⠀⠀⠀⠀⠀⠀⢮⡷⣴⣶⣶⡾⠿⠛⠿⠦⣙⡒⠲⠞⠉⣉⠶⠚⠉⠁ ",
  "⠀⠀⠀⠉⠓⠒⠒⠒⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠁     ",
}, "\n")

return {
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = dashboard_header,
        },
      },
      terminal = {
        win = {
          position = "float",
          border = "rounded",
          backdrop = 60,
          height = 0.97,
          width = 0.97,
        },
      },
      explorer = {
        replace_netrw = true,
      },
      picker = {
        sources = {
          files = { hidden = true },
          explorer = { hidden = true },
        },
      },
    },
  },
}
