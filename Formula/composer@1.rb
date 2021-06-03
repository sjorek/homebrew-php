class ComposerAT1 < Formula
  desc "Dependency Manager for PHP - Version 1.x"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/1.10.22/composer.phar"
  sha256 "6127ae192d3b56cd6758c7c72fe2ac6868ecc835dae1451a004aca10ab1e0700"
  license "MIT"
  revision 0

  livecheck do
    url "https://github.com/composer/composer.git"
    regex(/^1\.[\d.]+$/i)
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
