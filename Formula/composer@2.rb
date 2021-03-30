class ComposerAT2 < Formula
  desc "Dependency Manager for PHP - Version 2.x"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.0.11/composer.phar"
  sha256 "d6eee0d4637f4bd82bdae098fceda300dcb3ec35bf502604fbe7510933b8f952"
  license "MIT"
  revision 0

  livecheck do
    url "https://github.com/composer/composer.git"
    regex(/^2\.[\d.]+$/i)
  end

  bottle :unneeded

  keg_only :versioned_formula

  #deprecate! date: "2022-11-28", because: :versioned_formula

  def install
    lib.install "composer.phar"
    bin.install_symlink "#{lib}/composer.phar" => "composer"
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
end
