class ComposerCOMPOSER_VERSION_FORMULAPhpPHP_VERSION_MAJORPHP_VERSION_MINOR < Formula
  desc "Dependency Manager for PHP - Version COMPOSER_VERSION_MAJOR.COMPOSER_VERSION_MINOR.x"
  homepage "https://getcomposer.org/"
  url "file:///dev/null"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "MIT"
  version "COMPOSER_VERSION_MAJOR.COMPOSER_VERSION_MINOR.COMPOSER_VERSION_PATCH"
  revision FORMULA_REVISION

  livecheck do
    url "https://getcomposer.org/versions"
    regex(/"COMPOSER_VERSION_SHORT" \[\{[^\]\}]*"version": "([^"]+)"/i)
  end

  #bottle :unneeded

  #keg_only :versioned_formula

  #deprecate! date: "2022-11-28", because: :versioned_formula

  option "with-bash-completion", "Install optional bash-completion integration"

  depends_on "sjorek/php/composer-phpPHP_VERSION_MAJORPHP_VERSION_MINOR@COMPOSER_VERSION_FORMULA"
  depends_on "sjorek/php/composer-bash-completion" if build.with? "bash-completion"

  def install

    php_binary      = "#{HOMEBREW_PREFIX}/opt/php@PHP_VERSION_MAJOR.PHP_VERSION_MINOR/bin/php"
    composer_binary = "#{HOMEBREW_PREFIX}/opt/composer-phpPHP_VERSION_MAJORPHP_VERSION_MINOR@COMPOSER_VERSION_FORMULA/bin/composer"
    composer_proxy  = "#{__dir__}/../bin/proxy-binary.php"
    composer_php    = "#{buildpath}/#{name}.php"

    FileUtils.copy(composer_proxy, composer_php)

    inreplace composer_php do |s|
      s.gsub! /^#!\/usr\/bin\/env php/, "#!#{php_binary}"
      s.gsub! /FORMULA_NAME/, name
      s.gsub! /BIN_PATH/, composer_binary
    end

    bin.install "#{composer_php}" => "#{name}"

    if build.with? "bash-completion" then

      composer_bash   = "#{buildpath}/#{name}.bash"
      completion_bash = "#{HOMEBREW_PREFIX}/opt/composer-bash-completion/lib/composer-completion.bash"

      completion_script = <<~EOS
        # composer completion                                       -*- shell-script -*-

        COMPOSER_COMPLETION_PHP=${COMPOSER_COMPLETION_PHP:-#{php_binary}}
        COMPOSER_COMPLETION_REGISTER=""
        COMPOSER_COMPLETION_DETECTION=false

        source #{completion_bash} && \
            composer-completion-register "#{name}"

        # ex: filetype=sh
      EOS

      File.write(composer_bash, completion_script)

      bash_completion.install composer_bash
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

  def caveats
    s = ''

    if false == build.with?("bash-completion") then
      s += <<~EOS
        Hint: #{name} has optional shell-completion support for bash version ≥ 4.x.

        To enable bash-completion, run the installation with the following option:
          brew install #{name} --with-bash-completion

      EOS
    end

    s
  end

end
