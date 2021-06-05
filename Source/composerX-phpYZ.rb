class ComposerCOMPOSER_VERSION_MAJORPhpPHP_VERSION_MAJORPHP_VERSION_MINOR < Formula
  desc "Dependency Manager for PHP - Version COMPOSER_VERSION_MAJOR.x"
  homepage "https://getcomposer.org/"
  url "file:///dev/null"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "MIT"
  version "COMPOSER_VERSION_MAJOR.COMPOSER_VERSION_MINOR.COMPOSER_VERSION_PATCH"
  revision FORMULA_REVISION

  livecheck do
    url "https://github.com/composer/composer.git"
    regex(/^COMPOSER_VERSION_MAJOR\.[\d.]+$/i)
  end

  bottle :unneeded

  #keg_only :versioned_formula

  #deprecate! date: "2022-11-28", because: :versioned_formula

  depends_on "php@PHP_VERSION_MAJOR.PHP_VERSION_MINOR"
  depends_on "composer@COMPOSER_VERSION_MAJOR"

  def php_binary
    "#{HOMEBREW_PREFIX}/opt/php@PHP_VERSION_MAJOR.PHP_VERSION_MINOR/bin/php"
  end

  def composer_phar
    "#{HOMEBREW_PREFIX}/opt/composer@COMPOSER_VERSION_MAJOR/lib/composer.phar"
  end

  def install
    system "#{php_binary} -r '\$p = new Phar(\"#{composer_phar}\", 0, \"composer.phar\"); echo \$p->getStub();' >#{name}.php"

    inreplace "#{name}.php" do |s|
      s.gsub! /^#!\/usr\/bin\/env php/, "#!#{php_binary}"
      s.gsub! /^Phar::mapPhar\('composer\.phar'\);/, <<~EOS
        if (false === getenv('COMPOSER_HOME')) {
            putenv('COMPOSER_HOME=' . $_SERVER['HOME'] . '/.composer/#{name}');
        }
        if (false === getenv('COMPOSER_CACHE_DIR')) {
            putenv('COMPOSER_CACHE_DIR=' . $_SERVER['HOME'] . '/.composer/cache');
        }
      EOS
      s.gsub! /phar:\/\/composer\.phar/, "phar://#{composer_phar}"
      s.gsub! /^__HALT_COMPILER.*/, ""
    end

    lib.install "#{name}.php" => "#{name}.php"
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
          "php": "~PHP_VERSION_MAJOR.PHP_VERSION_MINOR.0"
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
    assert_match /^HelloHomebrew from version #{Regexp.escape("PHP_VERSION_MAJOR.PHP_VERSION_MINOR")}$/,
      shell_output("#{bin}/#{name} -v run-script test")
  end
end
