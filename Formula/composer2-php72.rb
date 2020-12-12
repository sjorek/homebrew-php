class Composer2Php72 < Formula
  desc "Dependency Manager for PHP - Version 2.x"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.0.8/composer.phar"
  sha256 "2021f0d52b446e0efe3c548cc058ab5671fa38cdbcf814e7911c7e9d71d61538"
  license "MIT"
  revision 5

  livecheck do
    url "https://github.com/composer/composer.git"
    regex(/^2\.[\d.]+$/i)
  end

  bottle :unneeded

  #keg_only :versioned_formula

  #deprecate! date: "2022-11-28", because: :versioned_formula

  depends_on "php@7.2"

  def php_version_from_formula_name
    "#{name}".gsub(/^composer2-php/, "").split("").join(".")
  end

  def php_binary_from_formula_name
    "#{HOMEBREW_PREFIX}/opt/php@#{php_version_from_formula_name}/bin/php"
  end

  def install
    (lib/"#{name}.php").write <<~EOS
      #!#{php_binary_from_formula_name}
      <?php
      // #{name}
      
      if (false === getenv('COMPOSER_HOME')) {
          putenv('COMPOSER_HOME=' . $_SERVER['HOME'] . '/.composer/#{name}');
      }
      if (false === getenv('COMPOSER_CACHE_DIR')) {
          putenv('COMPOSER_CACHE_DIR=' . $_SERVER['HOME'] . '/.composer/cache');
      }
      
      require_once 'phar://#{lib}/#{name}.phar/bin/composer';
    EOS

    lib.install "composer.phar" => "#{name}.phar"
    bin.install_symlink "#{lib}/#{name}.php" => "#{name}"
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
          "php": "~#{php_version_from_formula_name}.0"
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

    system "#{bin}/#{name}", "install"
    assert_match /^HelloHomebrew from version #{Regexp.escape("#{php_version_from_formula_name}")}$/,
      shell_output("#{bin}/#{name} -v run-script test")
  end
end
