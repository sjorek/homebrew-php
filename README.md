# [homebrew-php](https://sjorek.github.io/homebrew-php/)

The repository is for missing PHP-related homebrew, like `composer` and
provides bash-completion for the latter.

## Installation

1. Install [homebrew](https://brew.sh)
3. Tap the shivammathur/php repository
3. Tap the sjorek/php repository
4. *IMPORTANT* Uninstall all php-formulae from homebrew/core first!
5. Install the formulae you want

### Example

```console
# Install [homebrew](https://brew.sh)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Tap the shivammathur/php repository
brew tap shivammathur/php

# Tap the sjorek/php repository
brew tap sjorek/php

# Uninstall all homebrew/core/php* formulae
( brew ls --full-name --formula -1 | grep -q -E "^php" ) && \
    brew uninstall $( brew ls --full-name --formula -1 | grep -E "^php" )

# Install several composer-formulae WITH bash-completion support enabled, or …
brew install sjorek/php/composer{1,22,27}-php{72,73,74,80,81,82,83} --with-bash-completion

# … install several composer-formulae at once WITHOUT bash-completion support
brew install sjorek/php/composer{1,22,27}-php{72,73,74,80,81,82,83}
```

## List of (currently) provided formulae

    composer@1                     1.10.27

    composer-php56@1               1.10.27
    composer-php70@1               1.10.27
    composer-php71@1               1.10.27
    composer-php72@1               1.10.27
    composer-php73@1               1.10.27
    composer-php74@1               1.10.27
    composer-php80@1               1.10.27
    composer-php81@1               1.10.27
    composer-php82@1               1.10.27
    composer-php83@1               1.10.27

    composer1-php56                1.10.27
    composer1-php70                1.10.27
    composer1-php71                1.10.27
    composer1-php72                1.10.27
    composer1-php73                1.10.27
    composer1-php74                1.10.27
    composer1-php80                1.10.27
    composer1-php81                1.10.27
    composer1-php82                1.10.27
    composer1-php83                1.10.27

    composer@22                    2.2.24

    composer-php56@22              2.2.24
    composer-php70@22              2.2.24
    composer-php71@22              2.2.24
    composer-php72@22              2.2.24
    composer-php73@22              2.2.24
    composer-php74@22              2.2.24
    composer-php80@22              2.2.24
    composer-php81@22              2.2.24
    composer-php82@22              2.2.24
    composer-php83@22              2.2.24

    composer22-php56               2.2.24
    composer22-php70               2.2.24
    composer22-php71               2.2.24
    composer22-php72               2.2.24
    composer22-php73               2.2.24
    composer22-php74               2.2.24
    composer22-php80               2.2.24
    composer22-php81               2.2.24
    composer22-php82               2.2.24
    composer22-php83               2.2.24

    composer@23                    2.3.10

    composer-php72@23              2.3.10
    composer-php73@23              2.3.10
    composer-php74@23              2.3.10
    composer-php80@23              2.3.10
    composer-php81@23              2.3.10
    composer-php82@23              2.3.10
    composer-php83@23              2.3.10

    composer23-php72               2.3.10
    composer23-php73               2.3.10
    composer23-php74               2.3.10
    composer23-php80               2.3.10
    composer23-php81               2.3.10
    composer23-php82               2.3.10
    composer23-php83               2.3.10

    composer@24                    2.4.4

    composer-php72@24              2.4.4
    composer-php73@24              2.4.4
    composer-php74@24              2.4.4
    composer-php80@24              2.4.4
    composer-php81@24              2.4.4
    composer-php82@24              2.4.4
    composer-php83@24              2.4.4

    composer24-php72               2.4.4
    composer24-php73               2.4.4
    composer24-php74               2.4.4
    composer24-php80               2.4.4
    composer24-php81               2.4.4
    composer24-php82               2.4.4
    composer24-php83               2.4.4

    composer@25                    2.5.8

    composer-php72@25              2.5.8
    composer-php73@25              2.5.8
    composer-php74@25              2.5.8
    composer-php80@25              2.5.8
    composer-php81@25              2.5.8
    composer-php82@25              2.5.8
    composer-php83@25              2.5.8

    composer25-php72               2.5.8
    composer25-php73               2.5.8
    composer25-php74               2.5.8
    composer25-php80               2.5.8
    composer25-php81               2.5.8
    composer25-php82               2.5.8
    composer25-php83               2.5.8

    composer@26                    2.6.6

    composer-php72@26              2.6.6
    composer-php73@26              2.6.6
    composer-php74@26              2.6.6
    composer-php80@26              2.6.6
    composer-php81@26              2.6.6
    composer-php82@26              2.6.6
    composer-php83@26              2.6.6

    composer26-php72               2.6.6
    composer26-php73               2.6.6
    composer26-php74               2.6.6
    composer26-php80               2.6.6
    composer26-php81               2.6.6
    composer26-php82               2.6.6
    composer26-php83               2.6.6

    composer@27                    2.7.7

    composer-php72@27              2.7.7
    composer-php73@27              2.7.7
    composer-php74@27              2.7.7
    composer-php80@27              2.7.7
    composer-php81@27              2.7.7
    composer-php82@27              2.7.7
    composer-php83@27              2.7.7

    composer27-php72               2.7.7
    composer27-php73               2.7.7
    composer27-php74               2.7.7
    composer27-php80               2.7.7
    composer27-php81               2.7.7
    composer27-php82               2.7.7
    composer27-php83               2.7.7

    composer-bash-completion       1.0.4

## List of (currently) provided formulae aliases

    composer-php56                 composer22-php56
    composer-php70                 composer22-php70
    composer-php71                 composer22-php71
    composer-php72                 composer27-php72
    composer-php73                 composer27-php73
    composer-php74                 composer27-php74
    composer-php80                 composer27-php80
    composer-php81                 composer27-php81
    composer-php82                 composer27-php82
    composer-php83                 composer27-php83

    composer2-php56                composer22-php56
    composer2-php70                composer22-php70
    composer2-php71                composer22-php71
    composer2-php72                composer27-php72
    composer2-php73                composer27-php73
    composer2-php74                composer27-php74
    composer2-php80                composer27-php80
    composer2-php81                composer27-php81
    composer2-php82                composer27-php82
    composer2-php83                composer27-php83

    composer@2                     composer@27

## Links

### Status

[![Build Status](https://img.shields.io/travis/com/sjorek/homebrew-php.svg)](https://travis-ci.com/sjorek/homebrew-php)


### GitHub

[![GitHub Issues](https://img.shields.io/github/issues/sjorek/homebrew-php.svg)](https://github.com/sjorek/homebrew-php/issues)
[![GitHub Latest Tag](https://img.shields.io/github/tag/sjorek/homebrew-php.svg)](https://github.com/sjorek/homebrew-php/tags)
[![GitHub Total Downloads](https://img.shields.io/github/downloads/sjorek/homebrew-php/total.svg)](https://github.com/sjorek/homebrew-php/releases)


### Social

[![GitHub Forks](https://img.shields.io/github/forks/sjorek/homebrew-php.svg?style=social)](https://github.com/sjorek/homebrew-php/network)
[![GitHub Stars](https://img.shields.io/github/stars/sjorek/homebrew-php.svg?style=social)](https://github.com/sjorek/homebrew-php/stargazers)
[![GitHub Watchers](https://img.shields.io/github/watchers/sjorek/homebrew-php.svg?style=social)](https://github.com/sjorek/homebrew-php/watchers)
[![Twitter](https://img.shields.io/twitter/url/https/github.com/sjorek/homebrew-php.svg?style=social)](https://twitter.com/intent/tweet?url=https%3A%2F%2Fsjorek.github.io%2Fhomebrew-php%2F)

## Want more?

Are you preferring [macports](https://www.macports.org)? Then take a look
at the alternative [macports-php](https://sjorek.github.io/macports-php/) project.

Cheers!
