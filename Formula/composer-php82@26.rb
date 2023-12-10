class ComposerPhp82AT26 < Formula
  desc "Dependency Manager for PHP - Version 2.6.x"
  homepage "https://getcomposer.org/"
  url "file:///dev/null"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "MIT"
  version "2.6.6"
  revision 0

  livecheck do
    url "https://getcomposer.org/versions"
    regex(/"2" \[\{[^\]\}]*"version": "([^"]+)"/i)
  end

  #bottle :unneeded

  keg_only :versioned_formula

  #deprecate! date: "2022-11-28", because: :versioned_formula

  option "with-bash-completion", "Install optional bash-completion integration"

  depends_on "shivammathur/php/php@8.2"
  depends_on "sjorek/php/composer@26"

  def install

    php_binary      = "#{HOMEBREW_PREFIX}/opt/php@8.2/bin/php"
    composer_php    = "#{buildpath}/#{name}.php"
    composer_phar   = "#{HOMEBREW_PREFIX}/opt/composer@26/lib/composer.phar"
    composer_setup  = "#{HOMEBREW_PREFIX}/opt/composer@26/lib/composer-setup.php"

    composer_setup_sha384 = `#{php_binary} -r 'echo hash_file("sha384", "#{composer_setup}");'`
    fail "invalid checksum for composer-installer" unless "e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02" == composer_setup_sha384

    composer_setup_check = `#{php_binary} #{composer_setup} --check --no-ansi`.strip
    fail composer_setup_check unless "All settings correct for using Composer" == composer_setup_check

    composer_phar_sha256 = `#{php_binary} -r 'echo hash_file("sha256", "#{composer_phar}");'`
    fail "invalid checksum for composer.phar" unless "72600201c73c7c4b218f1c0511b36d8537963e36aafa244757f52309f885b314" == composer_phar_sha256

    composer_version = `#{php_binary} #{composer_phar} --version --no-ansi`
    fail "invalid version for composer.phar" unless /^Composer version #{Regexp.escape(version)}( |$)/.match?(composer_version)

    system "#{php_binary} -r '\$p = new Phar(\"#{composer_phar}\", 0, \"composer.phar\"); echo \$p->getStub();' >#{composer_php}"

    inreplace composer_php do |s|

      composer_stub = <<~EOS

        if (false === getenv('COMPOSER_HOME') && !isset($_SERVER['COMPOSER_HOME'], $_ENV['COMPOSER_HOME'])) {
            putenv('COMPOSER_HOME=' . ($_SERVER['COMPOSER_HOME'] = $_ENV['COMPOSER_HOME'] = $_SERVER['HOME'] . '/.composer/composer26-php82'));
        }

        if (false === getenv('COMPOSER_PHAR') && !isset($_SERVER['COMPOSER_PHAR'], $_ENV['COMPOSER_PHAR'])) {
            putenv('COMPOSER_PHAR=' . ($_SERVER['COMPOSER_PHAR'] = $_ENV['COMPOSER_PHAR'] = '#{composer_phar}'));
        }

      EOS

      if !OS.linux? then
        composer_stub += <<~EOS
          if (false === getenv('COMPOSER_CACHE_DIR') && !isset($_SERVER['COMPOSER_CACHE_DIR'], $_ENV['COMPOSER_CACHE_DIR'])) {
              # @see https://github.com/composer/composer/pull/9898
              putenv('COMPOSER_CACHE_DIR=' . ($_SERVER['COMPOSER_CACHE_DIR'] = $_ENV['COMPOSER_CACHE_DIR'] = $_SERVER['HOME'] . '/Library/Caches/composer'));
          }

        EOS
      end

      s.gsub! /^#!\/usr\/bin\/env php/, "#!#{php_binary}"
      s.gsub! /^Phar::mapPhar\('composer\.phar'\);/, composer_stub
      s.gsub! /phar:\/\/composer\.phar/, "phar://#{composer_phar}"
      s.gsub! /^__HALT_COMPILER.*/, ""
    end

    lib.install composer_php
    bin.install "#{lib}/#{name}.php" => "composer"
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
          "php": "~8.2.0"
        },
        "autoload": {
          "psr-0": {
            "HelloWorld": "src/"
          }
        },
        "scripts": {
          "test": "@php tests/test.php"
        }
      }
    EOS

    (testpath/"src/HelloWorld/greetings.php").write <<~EOS
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew from version ' . PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;
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
    assert_match /^HelloHomebrew from version #{Regexp.escape("8.2")}$/,
      shell_output("#{bin}/composer -v run-script test")
  end

  def caveats
    s = <<~EOS
      When running “composer” the COMPOSER_* environment-variables are
      adjusted per default:

      COMPOSER_HOME=${HOME}/.composer/composer26-php82
    EOS

    if !OS.linux? then
      s += <<~EOS
          # @see https://github.com/composer/composer/pull/9898
          COMPOSER_CACHE_DIR=${HOME}/Library/Caches/composer
      EOS
    end

    s += <<~EOS

      Of course, these variables can still be overriden by you.

    EOS

    if !OS.linux? && Dir.exists?(ENV['HOME'] + "/.composer/cache") then
      s += <<~EOS
        ATTENTION: The COMPOSER_CACHE_DIR path-value has been renamed
        from ${HOME}/.composer/cache to /Library/Caches/composer.

        If you want to remove the old cache directory, run:
          rm -rf ${HOME}/.composer/cache

      EOS
    end

    s
  end

end
