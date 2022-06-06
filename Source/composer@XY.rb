class ComposerATCOMPOSER_VERSION_FORMULA < Formula
  desc "Dependency Manager for PHP - Version COMPOSER_VERSION_MAJOR.COMPOSER_VERSION_MINOR.x"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/installer"
  sha256 "COMPOSER_SETUP_SHA256"
  license "MIT"
  version "COMPOSER_VERSION_MAJOR.COMPOSER_VERSION_MINOR.COMPOSER_VERSION_PATCH"
  revision FORMULA_REVISION

  livecheck do
    url "https://getcomposer.org/versions"
    regex(/"COMPOSER_VERSION_SHORT" \[\{[^\]\}]*"version": "([^"]+)"/i)
  end

  #bottle :unneeded

  keg_only :versioned_formula

  #deprecate! date: "2022-11-28", because: :versioned_formula

  def install

    php_binary      = '/usr/bin/env php'
    composer_php    = "#{buildpath}/composer.php"
    composer_phar   = "#{buildpath}/composer.phar"
    composer_setup  = "#{buildpath}/composer-setup.php"

    mv "installer", composer_setup

    composer_setup_sha384 = `#{php_binary} -r 'echo hash_file("sha384", "#{composer_setup}");'`
    fail "invalid checksum for composer-installer" unless "COMPOSER_SETUP_SHA384" == composer_setup_sha384

    composer_setup_check = `#{php_binary} #{composer_setup} --check --no-ansi`.strip
    fail composer_setup_check unless "All settings correct for using Composer" == composer_setup_check

    system "#{php_binary} #{composer_setup} --install-dir=#{buildpath} --version=#{version} --no-ansi --quiet"

    composer_phar_sha256 = `#{php_binary} -r 'echo hash_file("sha256", "#{composer_phar}");'`
    fail "invalid checksum for composer.phar" unless "COMPOSER_PHAR_SHA256" == composer_phar_sha256

    composer_version = `#{php_binary} #{composer_phar} --version --no-ansi`
    fail "invalid version for composer.phar" unless /^Composer version #{Regexp.escape(version)}( |$)/.match?(composer_version)

    system "#{php_binary} -r '\$p = new Phar(\"#{composer_phar}\", 0, \"composer.phar\"); echo \$p->getStub();' >#{composer_php}"

    inreplace composer_php do |s|
      if COMPOSER_VERSION_MAJOR == 1 then
        s.gsub! /^Phar::mapPhar\('composer\.phar'\);/, <<~EOS
          if (false === getenv('COMPOSER_CACHE_DIR')) {
              # @see https://github.com/composer/composer/pull/9898
              putenv('COMPOSER_CACHE_DIR=' . $_SERVER['HOME'] . '/Library/Caches/composer');
          }
        EOS
      else
        s.gsub! /^Phar::mapPhar\('composer\.phar'\);/, ''
      end
      s.gsub! /phar:\/\/composer\.phar/, "phar://#{lib}/composer.phar"
      s.gsub! /^__HALT_COMPILER.*/, ""
    end

    lib.install composer_phar
    lib.install composer_php
    lib.install composer_setup
    bin.install "#{lib}/composer.php" => "composer"
  end

  test do
    (testpath/"composer.json").write <<~EOS
      {
        "name": "homebrew/test",
        "authors": [
          {
            "name": "Homebrew"
          }
        ],
        "require": {
          "php": ">=5.3.4"
          },
        "autoload": {
          "psr-0": {
            "HelloWorld": "src/"
          }
        }
      }
    EOS

    (testpath/"src/HelloWorld/greetings.php").write <<~EOS
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew';
        }
      }
    EOS

    (testpath/"tests/test.php").write <<~EOS
      <?php

      // Autoload files using the Composer autoloader.
      require_once __DIR__ . '/../vendor/autoload.php';

      use HelloWorld\\Greetings;

      echo Greetings::sayHelloWorld();
    EOS

    system "#{bin}/composer", "install"
    assert_match /^HelloHomebrew$/, shell_output("php tests/test.php")
  end

  def caveats

    s = <<~EOS
      Hint: “#{name}” is meant to be used in conjunction with
      one or all of the sjorek/php/composerCOMPOSER_VERSION_FORMULA-php* formulae.

      To install several composer formulae at once run:
        brew install sjorek/php/composer{1,22,23}-php{72,73,74,80}

    EOS

    if COMPOSER_VERSION_MAJOR == 1 then
      s += <<~EOS
        When running “composer” the COMPOSER_* environment-variables are
        adjusted per default:

          # @see https://github.com/composer/composer/pull/9898
          COMPOSER_CACHE_DIR=~/Library/Caches/composer

        Of course, these variables can still be overriden by you.

      EOS
    end

    if Dir.exists?(ENV['HOME'] + "/.composer/cache") then
      s += <<~EOS
        ATTENTION: The COMPOSER_CACHE_DIR path-value has been renamed
        from “~/.composer/cache” to “~/Library/Caches/composer”.

        If you want to remove the old cache directory, run:
          rm -rf ~/.composer/cache

      EOS
    end
    s
  end

end
