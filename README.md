# ghq-cache

Show frequently used repositories first in [`ghq list`](https://github.com/motemen/ghq).

## Installation

```bash
brew install motemen/ghq/ghq
gem install ghq-cache
```

## Usage

```bash
# Build `ghq list` cache to ~/.ghq-cache
# with ordering of host, user or repositories.
ghq-cache update

# Log your repository access to update ~/.ghq-cache order.
ghq-cache log /Users/k0kubun/src/github.com/k0kubun/ghq-cache
```

### Recommended usage

```bash
export GOPATH=$HOME
export GHQ="/usr/local/bin/ghq"
export GIT="/usr/local/bin/git"

function ghq() {
  case $1 in
    get )
      $GHQ $@

      # hook after ghq get
      (ghq-cache update &)
      ;;
    list )
      if [ ! -e ~/.ghq-cache ]; then
        ghq-cache update
      fi

      # use ghq list ordered by ghq-cache
      cat ~/.ghq-cache
      ;;
    * )
      $GHQ $@
      ;;
  esac
}

function git() {
	case $1 in
		init )
			$GIT $@
			(ghq-cache update &)
			;;
		clone )
			$GIT $@
			(ghq-cache update &)
			;;
		* )
			$GIT $@
			;;
	esac
}

function peco-src() {
  local selected_dir=$(ghq list | peco --query "$LBUFFER" --prompt "[ghq list]")
  if [ -n "$selected_dir" ]; then
    full_dir="${GOPATH}/src/${selected_dir}"

    # Log repository access to ghq-cache
    (ghq-cache log $full_dir &)

    BUFFER="cd ${full_dir}"
    zle accept-line
  fi
  zle redisplay
}
zle -N peco-src
stty -ixon
bindkey '^s' peco-src
```

## License

MIT License
