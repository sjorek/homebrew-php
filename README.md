# [homebrew-php](https://sjorek.github.io/homebrew-php/)

The repository is for missing PHP-related homebrew, like `composer` and
provides bash-completion for the latter.

## Usage

1. Install [homebrew](https://brew.sh)
2. Tap the homebrew-php repository
3. Install the homebrew-php formulae you want

### Example

```console
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew tap shivammathur/php
brew tap sjorek/php

# to install all composer-formulae at once:
brew install sjorek/php/composer{1,2}-php{72,73,74,80,81}

# to install all composer-formulae with bash-completion support enabled:
echo sjorek/php/composer{1,2}-php{72,73,74,80,81} | \
    xargs -n1 -J% brew install % --with-bash-completion
```

## List of (currently) provided formulae

    composer1-php56                1.10.25_1
    composer1-php70                1.10.25_1
    composer1-php71                1.10.25_1
    composer1-php72                1.10.25_1
    composer1-php73                1.10.25_1
    composer1-php74                1.10.25_1
    composer1-php80                1.10.25_1
    composer1-php81                1.10.25_1
    composer@1                     1.10.25_0

    composer2-php56                2.2.9_1
    composer2-php70                2.2.9_1
    composer2-php71                2.2.9_1
    composer2-php72                2.2.9_1
    composer2-php73                2.2.9_1
    composer2-php74                2.2.9_1
    composer2-php80                2.2.9_1
    composer2-php81                2.2.9_1
    composer@2                     2.2.9_0

    composer-bash-completion       0.3.1_0

## List of (currently) provided formulae aliases

    composer-php56                 composer2-php56
    composer-php70                 composer2-php70
    composer-php71                 composer2-php71
    composer-php72                 composer2-php72
    composer-php73                 composer2-php73
    composer-php74                 composer2-php74
    composer-php80                 composer2-php80
    composer-php81                 composer2-php81

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

There is a [virtual-environment composer-plugin](https://sjorek.github.io/composer-virtual-environment-plugin/)
complementing these composer formulae. Are you preferring [macports](https://www.macports.org)? Then take a look
at the alternative [macports-php](https://sjorek.github.io/macports-php/) project.

Cheers!
