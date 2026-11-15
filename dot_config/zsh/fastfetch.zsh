# Fastfetch greeting for interactive zsh, sourced from ~/.zshrc.
[[ -o interactive ]] && (( $+commands[fastfetch] )) || return 0
#
# ~/.config/fastfetch/config.jsonc draws an 86-column box with the logo beside
# the stats, which wraps in a narrower terminal. Below that width the greeting
# uses narrow.jsonc instead: a 53-column box with the logo above the stats.
fastfetch_wide_columns=86

# tmux cannot place kitty images itself. Inside tmux the image is sent to the
# terminal through tmux's passthrough as a "virtual" placement of image 42, and
# the logo becomes a 30x15 grid of U+10EEEE placeholder cells that the terminal
# paints the image over. A cell names its image by foreground colour (256-colour
# index = image id) and its row and column by two combining marks. Everything is
# spelled as UTF-8 bytes so that it does not depend on the locale.
fastfetch_placeholder_image=42
fastfetch_placeholder_logo=
() {
  # The first 30 marks of kitty's rowcolumn-diacritics.txt: index N means row/column N
  local -a marks=(
    $'\xcc\x85' $'\xcc\x8d' $'\xcc\x8e' $'\xcc\x90' $'\xcc\x92' $'\xcc\xbd'
    $'\xcc\xbe' $'\xcc\xbf' $'\xcd\x86' $'\xcd\x8a' $'\xcd\x8b' $'\xcd\x8c'
    $'\xcd\x90' $'\xcd\x91' $'\xcd\x92' $'\xcd\x97' $'\xcd\x9b' $'\xcd\xa3'
    $'\xcd\xa4' $'\xcd\xa5' $'\xcd\xa6' $'\xcd\xa7' $'\xcd\xa8' $'\xcd\xa9'
    $'\xcd\xaa' $'\xcd\xab' $'\xcd\xac' $'\xcd\xad' $'\xcd\xae' $'\xcd\xaf'
  )
  local row column
  for row in {1..15}; do
    fastfetch_placeholder_logo+=$'\e[38;5;'${fastfetch_placeholder_image}m
    for column in {1..30}; do
      fastfetch_placeholder_logo+=$'\xf4\x8e\xbb\xae'$marks[row]$marks[column]
    done
    fastfetch_placeholder_logo+=$'\e[39m\n'
  done
}

# Sets REPLY to how the slowpoke image is sent:
#   kitty  kitty graphics protocol, as the config files say (Ghostty, Herdr, kitty)
#   tmux   through tmux to a Ghostty or kitty client (see above)
#   none   inside tmux attached from another terminal, so the logo is left out
fastfetch_image_mode() {
  REPLY=kitty
  [[ -n $TMUX ]] || return 0
  # The TERM and the self-reported name of the terminal tmux is attached from
  local client=$(tmux display-message -p '#{allow-passthrough} #{client_termname} #{client_termtype}' 2>/dev/null)
  if [[ $client == (on|all)' '*(ghostty|kitty)* ]]; then
    REPLY=tmux
  else
    REPLY=none
  fi
}

# Draws the greeting in the layout and image mode that fit this terminal.
# Arguments are passed on to fastfetch.
fastfetch_greeting() {
  local -a args
  (( COLUMNS >= fastfetch_wide_columns )) || args+=(-c ~/.config/fastfetch/narrow.jsonc)
  fastfetch_image_mode
  case $REPLY in
    tmux)
      # Transmit the PNG; tmux passes on what is between \ePtmux; and \e\\,
      # with every ESC inside doubled
      print -rn -- $'\ePtmux;\e\e_Gf=100,a=T,U=1,q=2,c=30,r=15,i='${fastfetch_placeholder_image}';'"$(base64 < ~/.config/fastfetch/slowpoke.png | tr -d '\n')"$'\e\e\\\e\\'
      args+=(--logo-type data-raw --logo $fastfetch_placeholder_logo)
      ;;
    none)
      args+=(--logo none)
      ;;
  esac
  command fastfetch $args "$@"
}

# A bare `fastfetch` draws the greeting; anything else goes to the binary untouched.
fastfetch() {
  if (( $# )); then
    command fastfetch "$@"
  else
    fastfetch_greeting
  fi
}

fastfetch

# The terminal cannot reflow the box, so while a greeting is the last thing on
# screen, a resize that crosses the layout threshold clears the screen and
# draws the other layout. fastfetch_drawn_wide holds the layout of that
# greeting (1 or 0) and is unset once any other command has run, so that
# command output is never cleared.
fastfetch_drawn_wide=$(( COLUMNS >= fastfetch_wide_columns ))

# preexec hook; $3 is the command line about to run
fastfetch_track_greeting() {
  if [[ $3 == fastfetch ]]; then
    fastfetch_drawn_wide=$(( COLUMNS >= fastfetch_wide_columns ))
  else
    unset fastfetch_drawn_wide
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook preexec fastfetch_track_greeting

# zsh redraws the prompt on every resize by moving the cursor up from where it
# believes the cursor is, so anything printed at the prompt has to leave the
# cursor exactly where zsh expects it, at every moment a resize can be handled.
# Printing from the WINCH trap itself can interrupt one of those redraws
# halfway, so the trap only wakes a zle -F handler, which runs as a widget once
# zsh is idle at the prompt again.
zmodload zsh/system
() {
  local fifo=${TMPDIR:-/tmp}/fastfetch-resize.$$.$RANDOM
  mkfifo -m 600 $fifo || return
  exec {fastfetch_resize_fd}<>$fifo
  rm -f $fifo
}

fastfetch_on_winch() {
  (( ${+fastfetch_drawn_wide} )) && print -nu $fastfetch_resize_fd .
}

fastfetch_redraw() {
  local wakeups drawing wide ps1=$PS1 cursor=$CURSOR clear=$'\e[H\e[2J'
  sysread -i $fastfetch_resize_fd -s 4096 wakeups
  # Not while a multi-line command is being typed (PS2)
  [[ $CONTEXT == start ]] && (( ${+fastfetch_drawn_wide} )) || return 0
  (( (wide = COLUMNS >= fastfetch_wide_columns) != fastfetch_drawn_wide )) || return 0
  # Capture the drawing, so that it reaches the terminal in one write
  drawing=$(fastfetch_greeting --pipe false)
  # Resized back across the threshold in the meantime; that resize has
  # already queued another call
  (( wide == (COLUMNS >= fastfetch_wide_columns) )) || return 0
  # With shell integration (OSC 133 marks in the prompt) the terminal counts
  # what is printed at the prompt as part of the prompt, and Ghostty erases the
  # prompt on every resize. Declare the drawing to be command output instead.
  [[ $PS1 == *$'\e]133;A'* ]] && clear=$'\e]133;C\a'$clear
  {
    # Shrink what zsh displays to a single line with the cursor at its start.
    # From then on zsh's idea of the cursor is "at the start of my display",
    # which stays true after the greeting is printed, so a resize handled at
    # any point redraws in the right place.
    PS1= CURSOR=0
    zle reset-prompt
    print -rn -- $clear$drawing$'\n'
  } always {
    PS1=$ps1 CURSOR=$cursor
    zle reset-prompt
  }
  fastfetch_drawn_wide=$wide
}

if (( ${+fastfetch_resize_fd} )); then
  zle -N fastfetch_redraw
  zle -F -w $fastfetch_resize_fd fastfetch_redraw
  trap fastfetch_on_winch WINCH
fi
