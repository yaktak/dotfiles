export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export GOPATH=$HOME/go
set -x PATH $GOPATH/bin $PATH
# source (salias --init | psub)

alias ssh='~/bin/ssh-with-changing-profile.sh'

alias lla='ls -la'

alias d='docker'
alias dc='docker-compose'
alias dce='docker-compose exec'
alias dcel='docker-compose exec laravel'
alias dcee='docker-compose exec ethnam'

alias g='git'
alias gco='git branch -a | fzf | xargs git checkout'

function fish_prompt --description 'Write out the prompt'
    printf '%s %s' (set_color green)(prompt_pwd) (set_color yellow)"(*´∀`) < "
end

# function hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
#     for mode in default insert visual
#         fish_default_key_bindings -M $mode
#     end
#     fish_vi_key_bindings --no-erase
# end
# set -g fish_key_bindings hybrid_bindings

function vagrant -d "Wrapper for vagrant command"
    switch $argv[1]
        case 'ssh'
            ~/bin/vagrant-ssh-with-changing-profile.sh
        case '*'
            command vagrant $argv
     end
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

# set normal (set_color normal)
# set magenta (set_color magenta)
# set yellow (set_color yellow)
# set green (set_color green)
# set red (set_color red)
# set gray (set_color -o black)

# # Fish git prompt
# set __fish_git_prompt_showdirtystate 'yes'
# set __fish_git_prompt_showstashstate 'yes'
# set __fish_git_prompt_showuntrackedfiles 'yes'
# set __fish_git_prompt_showupstream 'yes'
# set __fish_git_prompt_color_branch yellow
# set __fish_git_prompt_color_upstream_ahead green
# set __fish_git_prompt_color_upstream_behind red

# # Status Chars
# set __fish_git_prompt_char_dirtystate '⚡'
# set __fish_git_prompt_char_stagedstate '→'
# set __fish_git_prompt_char_untrackedfiles '☡'
# set __fish_git_prompt_char_stashstate '↩'
# set __fish_git_prompt_char_upstream_ahead '+'
# set __fish_git_prompt_char_upstream_behind '-'

# function fish_prompt
#   set last_status $status

#   set_color $fish_color_cwd
#   printf '%s' (prompt_pwd)
#   set_color normal

#   printf '%s ' (__fish_git_prompt)

#   set_color normal
# end
