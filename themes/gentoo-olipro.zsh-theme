autoload -U colors && colors

autoload -Uz vcs_info

+vi-hgbookmarks() {
	bookmarks=$(hg id -B)
	if [[ -n $bookmarks ]] {
		bookmarks=${bookmarks// /,}
		bookmarks="$bookmarks:"
	}
	hook_com[misc]=$bookmarks
}

zstyle ':vcs_info:*' stagedstr '%F{green}●'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*:*' hgrevformat '%h'
zstyle ':vcs_info:hg*:*' branchformat '%r'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:hg+set-message:*' hooks hgbookmarks
zstyle ':vcs_info:*' enable git svn hg

theme_precmd () {
	if [[ -z $(git ls-files --other --exclude-standard --directory 2> /dev/null) && -z $(hg st -u 2> /dev/null) ]] {
		zstyle ':vcs_info:*' formats '(%m%b) %c%u %F{blue}'
		zstyle ':vcs_info:*' actionformats '[%m%b|%a] %c%u %F{blue}'
	} else {
		zstyle ':vcs_info:*' formats '(%m%b) %c%u%F{red}● %F{blue}'
		zstyle ':vcs_info:*' actionformats '[%m%b|%a] %c%u%F{red}● %F{blue}'
	}

	vcs_info
}
setopt prompt_subst
PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) ${${vcs_info_msg_0_}:gs/  / /}%#%{$reset_color%} '
RPROMPT='%(?..%{$fg[red]%}%? ◄ %{$reset_color%})'
autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
