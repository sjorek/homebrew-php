class ComposerBashCompletion < Formula
  desc "Composer shell completion for Bash"
  homepage "https://sjorek.github.io/composer-bash-completion/"
  url "https://github.com/sjorek/composer-bash-completion/archive/v0.3.2.tar.gz"
  sha256 "b7c1be85d408362e2dfca5e13dddb0b9d45064787f16495e5ebff75ad0208fe4"
  license "MIT"
  revision 0

  #bottle :unneeded

  depends_on "bash-completion@2"
  depends_on "sjorek/php/composer@1" => :optional
  depends_on "sjorek/php/composer@2" => :optional

  def install
    inreplace "composer-completion.bash",
              "#COMPOSER_COMPLETION_PHP=",
              "COMPOSER_COMPLETION_PHP=${COMPOSER_COMPLETION_PHP:-php}"
    inreplace "composer-completion.bash",
              "#COMPOSER_COMPLETION_PHP_SCRIPT=",
              "COMPOSER_COMPLETION_PHP_SCRIPT=#{lib}/composer-completion.php"

    script = <<~EOS
      # composer completion                                       -*- shell-script -*-

      COMPOSER_COMPLETION_PHP=${COMPOSER_COMPLETION_PHP:-php}
      COMPOSER_COMPLETION_REGISTER=""
      COMPOSER_COMPLETION_DETECTION=false

      source #{lib}/composer-completion.bash && \
          composer-completion-register "composer composer.phar"

      # ex: filetype=sh
    EOS

    File.write("composer.bash", script)

    bash_completion.install "composer.bash"

    lib.install "composer-completion.bash"
    lib.install "composer-completion.php"
  end

  test do
    assert_match "complete -o bashdefault -o nospace -F _composer_completion composer",
      shell_output("#{HOMEBREW_PREFIX}/bin/bash --norc --noprofile -c 'export PS1=\"TEST\" ; source #{etc}/profile.d/bash_completion.sh && source #{bash_completion}/composer.bash && complete -p composer'")
  end
end
