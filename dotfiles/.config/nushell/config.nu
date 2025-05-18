$env.config.color_config = {
  separator: "#6e6a86"
  leading_trailing_space_bg: "#908caa"
  header: "#31748f"
  date: "#f6c177"
  filesize: "#c4a7e7"
  row_index: "#9ccfd8"
  bool: "#eb6f92"
  int: "#31748f"
  duration: "#eb6f92"
  range: "#eb6f92"
  float: "#eb6f92"
  string: "#908caa"
  nothing: "#eb6f92"
  binary: "#eb6f92"
  cellpath: "#eb6f92"
  hints: dark_gray

  shape_garbage: { fg: "#524f67" bg: "#eb6f92" }
  shape_bool: "#c4a7e7"
  shape_int: { fg: "#f6c177" attr: b }
  shape_float: { fg: "#f6c177" attr: b }
  shape_range: { fg: "#ebbcba" attr: b }
  shape_internalcall: { fg: "#9ccfd8" attr: b }
  shape_external: "#9ccfd8"
  shape_externalarg: { fg: "#31748f" attr: b }
  shape_literal: "#c4a7e7"
  shape_operator: "#ebbcba"
  shape_signature: { fg: "#31748f" attr: b }
  shape_string: "#31748f"
  shape_filepath: "#c4a7e7"
  shape_globpattern: { fg: "#c4a7e7" attr: b }
  shape_variable: "#f6c177"
  shape_flag: { fg: "#c4a7e7" attr: b }
  shape_custom: { attr: b }
}

source ~/.cache/carapace/init.nu

let carapace_completer = {|spans|
carapace $spans.0 nushell $spans | from json
}
$env.config = {
 show_banner: false,
 completions: {
 case_sensitive: false # case-sensitive completions
 quick: true    # set to false to prevent auto-selecting completions
 partial: true    # set to false to prevent partial filling of the prompt
 algorithm: "fuzzy"    # prefix or fuzzy
 external: {
 # set to false to prevent nushell looking into $env.PATH to find more suggestions
     enable: true
 # set to lower can improve completion performance at the cost of omitting some options
     max_results: 100
     completer: $carapace_completer # check 'carapace_completer'
   }
 }
}
$env.PATH = ($env.PATH |
split row (char esep) |
prepend ~/.apps |
append /usr/bin/env
)

# Core Utils Aliases
alias l = eza -lh  --icons=auto
alias ls = eza -1   --icons=auto # short list
alias ll = eza -lha --icons=auto --sort=name --group-directories-first # long list all
alias ld = eza -lhD --icons=auto # long list dirs
alias tree = tree -a -I .git
alias cat = bat
alias c = clear # clear terminal
alias e = exit
alias grep = rg --color=auto
alias ssn = sudo shutdown now
alias srn = sudo reboot now

# Git Aliases
alias gac = git add . and git commit -m
alias gs = git status
alias gpush = git push origin
alias lg = lazygit

# Downloads Aliases
alias yd = yt-dlp -f "bestvideo+bestaudio" --embed-chapters --external-downloader aria2c --concurrent-fragments 8 --throttled-rate 100K
alias td = yt-dlp --external-downloader aria2c -o "%(title)s."
alias download = aria2c --split=16 --max-connection-per-server=16 --timeout=600 --max-download-limit=10M --file-allocation=none

# VPN Aliases
alias vu = sudo tailscale up --exit-node=raspberrypi --accept-routes
alias vd = sudo tailscale down
def warp [] {
    sudo systemctl "$1" warp-svc
}

# Other Aliases
alias rebuild = sh /etc/nixos/rebuild.sh
alias rebuild-log = tail -f /etc/nixos/nixos-switch.log
alias ff = fastfetch
alias files-space = sudo ncdu --exclude /.snapshots /
alias ld = lazydocker
alias docker-clean = docker container prune -f and docker image prune -f and docker network prune -f and docker volume prune -f
alias crdown = mpv --yt-dlp-raw-options=cookies-from-browser=brave
alias cr = cargo run
alias battery = upower -i /org/freedesktop/UPower/devices/battery_BAT1
alias y = yazi
def lsfind [] {
    ll "$1" | grep "$2"
}

# X11 Clipboard Aliases `xsel`
# alias pbcopy='xsel --input --clipboard'
# alias pbpaste='xsel --output --clipboard'

# Wayland Clipboard Aliases `wl-clipboard`
alias pbcopy = wl-copy
alias pbpaste = wl-paste

# Shell Intgrations
## eval "$(fzf --zsh)"

# Starship
use ~/.cache/starship/init.nu

# NPM global packages
$env.PATH = ($env.PATH | append ~/.npm-global/bin)

# Command Run
date
microfetch

