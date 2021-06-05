class Composer2Php73 < Formula
  desc "Dependency Manager for PHP - Version 2.x"
  homepage "https://getcomposer.org/"
  url "file:///dev/null"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "MIT"
  version "2.1.1"
  revision 3

  livecheck do
    url "https://github.com/composer/composer.git"
    regex(/^2\.[\d.]+$/i)
  end

  bottle :unneeded

  #keg_only :versioned_formula

  #deprecate! date: "2022-11-28", because: :versioned_formula

  depends_on "php@7.3"
  depends_on "composer@2"

  def php_binary
    "#{HOMEBREW_PREFIX}/opt/php@7.3/bin/php"
  end

  def composer_phar
    "#{HOMEBREW_PREFIX}/opt/composer@2/lib/composer.phar"
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
          "php": "~7.3.0"
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
    assert_match /^HelloHomebrew from version #{Regexp.escape("7.3")}$/,
      shell_output("#{bin}/#{name} -v run-script test")
  end
end
