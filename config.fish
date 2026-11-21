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
alias nvim "$HOME/neovimflake/result/bin/nvim";
alias matlab "/Applications/MATLAB_R2026b.app/bin/matlab -nodesktop"
abbr --add da "direnv allow"
abbr --add gd "git diff"
abbr --add gs "git status"
abbr --add nd "nix develop -c fish"

# function _git_branch_name
#   echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
# end
#
# function fish_prompt
#     set -l last_status $status
#
#     set -l blue (set_color -o 7fa0ff)
#     set -l cyan (set_color -o 9de781)
#     set -l green (set_color 4beb5f)
#
#     set -l ascii_fish "><(((\">"
#     set -l prompt_fish
#     set -l branch_name_fmt
#
#     if [ (_git_branch_name) ]
#         set prompt_fish (string join "" -- $blue $ascii_fish " ")
#     else
#         set prompt_fish (string join "" -- $cyan $ascii_fish " ")
#     end
#
#     set -l prompt (string join "" -- $green (prompt_pwd))
#     echo -ns $prompt_fish (set_color --reset) $prompt (set_color --reset) $branch_name_fmt $stat (set_color --reset) "> "
# end

function fish_prompt
    # D88D32
    echo -ns (set_color -o brblue) (prompt_pwd) (set_color -o brgreen) "> " (set_color --reset)
end
