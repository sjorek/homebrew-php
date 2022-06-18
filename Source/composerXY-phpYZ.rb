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

  depends_on "PHP_FORMULA@PHP_VERSION_MAJOR.PHP_VERSION_MINOR"
  depends_on "sjorek/php/composer@COMPOSER_VERSION_FORMULA"
  depends_on "sjorek/php/composer-bash-completion" if build.with? "bash-completion"

  def install

    php_binary      = "#{HOMEBREW_PREFIX}/opt/php@PHP_VERSION_MAJOR.PHP_VERSION_MINOR/bin/php"
    composer_php    = "#{buildpath}/#{name}.php"
    composer_phar   = "#{HOMEBREW_PREFIX}/opt/composer@COMPOSER_VERSION_FORMULA/lib/composer.phar"
    composer_setup  = "#{HOMEBREW_PREFIX}/opt/composer@COMPOSER_VERSION_FORMULA/lib/composer-setup.php"
    composer_script = "#{HOMEBREW_PREFIX}/bin/#{name}"

    composer_setup_sha384 = `#{php_binary} -r 'echo hash_file("sha384", "#{composer_setup}");'`
    fail "invalid checksum for composer-installer" unless "COMPOSER_SETUP_SHA384" == composer_setup_sha384

    composer_setup_check = `#{php_binary} #{composer_setup} --check --no-ansi`.strip
    fail composer_setup_check unless "All settings correct for using Composer" == composer_setup_check

    composer_phar_sha256 = `#{php_binary} -r 'echo hash_file("sha256", "#{composer_phar}");'`
    fail "invalid checksum for composer.phar" unless "COMPOSER_PHAR_SHA256" == composer_phar_sha256

    composer_version = `#{php_binary} #{composer_phar} --version --no-ansi`
    fail "invalid version for composer.phar" unless /^Composer version #{Regexp.escape(version)}( |$)/.match?(composer_version)

    system "#{php_binary} -r '\$p = new Phar(\"#{composer_phar}\", 0, \"composer.phar\"); echo \$p->getStub();' >#{composer_php}"

    inreplace composer_php do |s|
      s.gsub! /^#!\/usr\/bin\/env php/, "#!#{php_binary}"
      s.gsub! /^Phar::mapPhar\('composer\.phar'\);/, <<~EOS
        if (false === getenv('COMPOSER_PHAR')) {
            putenv('COMPOSER_PHAR=#{composer_phar}');
        }

        if (false === getenv('COMPOSER_HOME')) {
            putenv('COMPOSER_HOME=' . $_SERVER['HOME'] . '/.composer/#{name}');
        }

        if (false === getenv('COMPOSER_CACHE_DIR')) {
            # @see https://github.com/composer/composer/pull/9898
            putenv('COMPOSER_CACHE_DIR=' . $_SERVER['HOME'] . '/Library/Caches/composer');
        }

      EOS
      s.gsub! /phar:\/\/composer\.phar/, "phar://#{composer_phar}"
      s.gsub! /^__HALT_COMPILER.*/, ""
    end

    lib.install composer_php
    bin.install_symlink "#{lib}/#{name}.php" => "#{name}"

    if build.with? "bash-completion" then
      composer_bash   = "#{buildpath}/#{name}.bash"
      completion_bash = "#{HOMEBREW_PREFIX}/opt/composer-bash-completion/lib/composer-completion.bash"

      script = <<~EOS
        # composer completion                                       -*- shell-script -*-

        COMPOSER_COMPLETION_PHP=${COMPOSER_COMPLETION_PHP:-#{php_binary}}
        COMPOSER_COMPLETION_REGISTER=""
        COMPOSER_COMPLETION_DETECTION=false

        source #{completion_bash} && \
            composer-completion-register "#{name}"

        # ex: filetype=sh
      EOS

      File.write(composer_bash, script)

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
    s = <<~EOS
      When running “#{name}” the COMPOSER_* environment-variables are
      adjusted per default:

        COMPOSER_HOME=~/.composer/#{name}

        # @see https://github.com/composer/composer/pull/9898
        COMPOSER_CACHE_DIR=~/Library/Caches/composer

      Of course, these variables can still be overriden by you.

    EOS

    if Dir.exists?(ENV['HOME'] + "/.composer/cache") then
      s += <<~EOS
        ATTENTION: The COMPOSER_CACHE_DIR path-value has been renamed
        from “~/.composer/cache” to “~/Library/Caches/composer”.

        If you want to remove the old cache directory, run:
          rm -rf ~/.composer/cache

      EOS
    end

    if /^composer1-/.match?(name) then
      oldname = name.gsub(/^composer1-/, 'composer-')
      if Dir.exists?(ENV['HOME'] + "/.composer/#{oldname}") then
        s += <<~EOS
          ATTENTION: The COMPOSER_HOME path-value has been renamed
          from “~/.composer/#{oldname}” to “~/.composer/#{name}”!

          Please update your composer-home path and run a diagnose afterwards:
            mv -v ~/.composer/#{oldname} ~/.composer/#{name}
            #{name} diagnose

        EOS
      end
    end

    if /^composer23-/.match?(name) then
      oldname = name.gsub(/^composer23-/, 'composer2-')
      if Dir.exists?(ENV['HOME'] + "/.composer/#{oldname}") then
        s += <<~EOS
          ATTENTION: The COMPOSER_HOME path-value has been renamed
          from “~/.composer/#{oldname}” to “~/.composer/#{name}”!

          Please update your composer-home path and run a diagnose afterwards:
            mv -v ~/.composer/#{oldname} ~/.composer/#{name}
            #{name} diagnose

        EOS
      end
    end

    if false == build.with?("bash-completion") then
      s += <<~EOS
        Hint: #{name} has optional shell-completion support for bash version ≥ 4.x.

        To enable bash-completion, run the installation with the following option:
          brew install #{name} --with-bash-completion

      EOS
    end
  end

end
