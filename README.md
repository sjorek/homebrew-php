# [homebrew-php](https://sjorek.github.io/homebrew-php/)

The repository is for missing PHP-related homebrew, like `composer` and
provides bash-completion for the latter.

## Installation

1. Install [homebrew](https://brew.sh)
3. Tap the shivammathur/php repository
3. Tap the sjorek/php repository
4. Install the formulae you want

### Example

```console
# Install [homebrew](https://brew.sh)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Tap the shivammathur/php repository
brew tap shivammathur/php

# Tap the sjorek/php repository
brew tap sjorek/php

# Install several composer-formulae WITH bash-completion support enabled, or …
echo -n sjorek/php/composer{1,22,23}-php{72,73,74,80,81} | \
    xargs -n1 -d' ' -I'{}' brew install {} --with-bash-completion

# … install several composer-formulae at once WITHOUT bash-completion support
echo -n sjorek/php/composer{1,22,23}-php{72,73,74,80,81} | \
    xargs -n1 -d' ' brew install
```

## List of (currently) provided formulae

    composer1-php56                1.10.26_9
    composer1-php70                1.10.26_9
    composer1-php71                1.10.26_9
    composer1-php72                1.10.26_9
    composer1-php73                1.10.26_9
    composer1-php74                1.10.26_9
    composer1-php80                1.10.26_9
    composer1-php81                1.10.26_9
    composer@1                     1.10.26_2

    composer22-php56               2.2.14_4
    composer22-php70               2.2.14_4
    composer22-php71               2.2.14_4
    composer22-php72               2.2.14_4
    composer22-php73               2.2.14_4
    composer22-php74               2.2.14_4
    composer22-php80               2.2.14_4
    composer22-php81               2.2.14_4
    composer@22                    2.2.14_3

    composer23-php72               2.3.7_4
    composer23-php73               2.3.7_4
    composer23-php74               2.3.7_4
    composer23-php80               2.3.7_4
    composer23-php81               2.3.7_4
    composer@23                    2.3.7_2

    composer-bash-completion       1.0.3_0

## List of (currently) provided formulae aliases

    composer-php56                 composer22-php56
    composer-php70                 composer22-php70
    composer-php71                 composer22-php71
    composer-php72                 composer23-php72
    composer-php73                 composer23-php73
    composer-php74                 composer23-php74
    composer-php80                 composer23-php80
    composer-php81                 composer23-php81

    composer2-php56                composer22-php56
    composer2-php70                composer22-php70
    composer2-php71                composer22-php71
    composer2-php72                composer23-php72
    composer2-php73                composer23-php73
    composer2-php74                composer23-php74
    composer2-php80                composer23-php80
    composer2-php81                composer23-php81

    composer@2                     composer@23

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
