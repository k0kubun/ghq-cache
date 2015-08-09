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
ghq-cache refresh

# Log your repository access to update ~/.ghq-cache order.
ghq-cache log /Users/k0kubun/src/github.com/k0kubun/ghq-cache
```

### Recommended usage

```bash
export GHQ="/usr/local/bin/ghq"

function ghq() {
  case $1 in
    get )
      $GHQ $@

      # hook after ghq get
      ghq-cache refresh &
      ;;
    list )
      if [ ! -e ~/.ghq-cache ]; then
        ghq-cache refresh
      fi

      # use ghq list ordered by ghq-cache
      cat ~/.ghq-cache
    * )
      $GHQ $@
      ;;
  esac
}
```

## License

MIT License
