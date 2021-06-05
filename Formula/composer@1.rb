class ComposerAT1 < Formula
  desc "Dependency Manager for PHP - Version 1.x"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/installer"
  sha384 "756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3 *composer-setup.php
"
  license "MIT"
  version "1.10.22"
  revision 1

  livecheck do
    url "https://github.com/composer/composer.git"
    regex(/^1\.[\d.]+$/i)
  end

  bottle :unneeded

  keg_only :versioned_formula

  #deprecate! date: "2022-11-28", because: :versioned_formula

  def install

    php = '/usr/bin/env php'

    mv "installer" "composer-setup.php"

    setup_check = shell_output("#{php} composer-setup.php --check --no-ansi")
    assert_equal "All settings correct for using Composer", setup_check

    system "#{php} composer-setup.php --install-dir=. --version=#{version} --no-ansi --quiet"

    composer_sha256 = shell_output("#{php} -r 'echo hash_file(\"sha256\", \"composer.phar\");'")
    assert_equal "6127ae192d3b56cd6758c7c72fe2ac6868ecc835dae1451a004aca10ab1e0700", composer_sha256

    if 1 == 1 then
      system "#{php} -r '\$p = new Phar(\"./composer.phar\", 0, \"composer.phar\"); echo \$p->getStub();' >composer.php"

      inreplace "composer.php" do |s|
        s.gsub! /^Phar::mapPhar\('composer\.phar'\);/, <<~EOS
          if (false === getenv('COMPOSER_CACHE_DIR')) {
              # @see https://github.com/composer/composer/pull/9898
              putenv('COMPOSER_CACHE_DIR=' . $_SERVER['HOME'] . '/Library/Caches/composer');
          }
        EOS
        s.gsub! /phar:\/\/composer\.phar/, "phar://#{lib}/composer.phar"
        s.gsub! /^__HALT_COMPILER.*/, ""
      end

      lib.install "composer.phar"
      lib.install "composer.php"
      lib.install "composer-setup.php"
      bin.install_symlink "#{lib}/composer.php" => "composer"
    else
      lib.install "composer.phar"
      lib.install "composer-setup.php"
      bin.install_symlink "#{lib}/composer.phar" => "composer"
    end
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
    if 1 == 1 then
      s = <<-EOS.undent

        When running “composer” the COMPOSER_* environment-variables are
        adjusted per default:

          # @see https://github.com/composer/composer/pull/9898
          COMPOSER_CACHE_DIR=~/Library/Caches/composer

        Of course, these variables can still be overriden by you.

      EOS
    end

    if Dir.exists?(ENV['HOME'] + "/.composer/cache") then
      s += <<-EOS.undent

      ATTENTION: The COMPOSER_CACHE_DIR path-value has been renamed
      from “~/.composer/cache” to “~/Library/Caches/composer”.

      If you want to remove the old cache directory, run:

          rm -rf ~/.composer/cache

      EOS
    end
  end

end
