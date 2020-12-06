class ComposerPhpAT80 < Formula
  desc "Alias the Dependency Manager for PHP to homebrew's PHP"
  homepage "https://sjorek.github.io/macports-php/"
  url "https://github.com/sjorek/macports-php/archive/master.zip"
  sha256 "ce8a11bdbfe36c944454c78535f9f8b4382f99f84cfac64e412d6c540ee6ccf2"
  license "MIT"

  bottle :unneeded

  keg_only :versioned_formula

  # deprecate! date: "2022-11-28", because: :versioned_formula

  depends_on "php"
  depends_on "composer@1"
  depends_on "composer-bash-completion"

  #resource "composer" do
  #  url "https://raw.githubusercontent.com/sjorek/macports-php/master/php/composer/files/composer.php"
  #  sha256 "b5f7bbd78f9790026bbff16fc6e3fe4070d067f58f943e156bd1a8c3c99f6a6f"
  #end
  #
  #resource "completion" do
  #  url "https://raw.githubusercontent.com/sjorek/macports-php/master/php/composer/files/completion.sh"
  #  sha256 "b5f7bbd78f9790026bbff16fc6e3fe4070d067f58f943e156bd1a8c3c99f6a6f"
  #end

  def install
    inreplace "php/composer/files/completion.sh" do |s|
      s.gsub! /^@PHP@$/, "#{HOMEBREW_PREFIX}/bin/php"
      s.gsub! /^@LIBPATH@$/, "#{bash_completion}"
      s.gsub! /^@NAME@$/, "#{name}"
    end

    inreplace "php/composer/files/composer.php" do |s|
      s.gsub! /^@PHP@$/, "#{HOMEBREW_PREFIX}/bin/php"
      s.gsub! /^@LIBPATH@$/, "#{HOMEBREW_PREFIX}/opt/composer@1/lib"
      s.gsub! /^@NAME@$/, "composer"
      s.gsub! /^@VARIANT@$/, "/#{name.gsub! /(^composer-|@|\.)/g, ""}"
    end

    bash_completion.install "php/composer/files/completion.sh" => "composer-completion-php.bash"
    bin.install "php/composer/files/composer.php" => "#{name}"
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
          "php": "~8.0.0"
        },
        "autoload": {
          "psr-0": {
            "HelloWorld": "src/"
          }
        },
        "scripts" {
          "test": "@php tests/test.php"
        }
      }
    EOS

    (testpath/"src/HelloWorld/greetings.php").write <<~EOS
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;
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

    system "#{bin}/composer-php", "install"
    assert_match /^8\.0$/, shell_output("#{bin}/composer-php run-script test")
  end
end
