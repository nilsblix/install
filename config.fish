if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

if test -d /run/current-system/sw/bin
    fish_add_path /run/current-system/sw/bin
end

direnv hook fish | source
set -U fish_greeting

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
	    builtin cd -- "$cwd"
	end
    command rm -f -- "$tmp"
end

fzf --fish | source

bind \cc 'echo; commandline ""; commandline -f repaint'

alias codex "nix run github:numtide/llm-agents.nix#codex"
alias da "direnv allow"
alias gd "git diff"
alias gs "git status"
alias nd "nix develop -c fish"
alias nvim "$HOME/neovimflake/result/bin/nvim";
