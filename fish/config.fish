# environment variables
set --export PHP_INI_SCAN_DIR "$HOME/.config/herd-lite/bin"
set --export PATH $PHP_INI_SCAN_DIR $PATH
set --export EDITOR nvim

# aliasses
alias .. 'cd ..'
alias ... 'cd ../..'
alias cls clear
alias ls 'eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions -G --group-directories-first'
alias lsa 'eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions -a -G --group-directories-first'
alias tree 'tree -CA'
alias ~w 'cd /mnt/c/Users/Kling'

# abbreviations
abbr -a editfish "$EDITOR ~/.config/fish/config.fish"
abbr -a fishrc 'source ~/.config/fish/config.fish'

# starship init
starship init fish | source

# always use latest node version
# need to install it first with "nvm install latest"
nvm use latest -s

# function to run yazi and sync shell cwd with yazi
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

