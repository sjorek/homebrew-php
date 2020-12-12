class ComposerBashCompletion < Formula
  desc "Composer shell completion for Bash"
  homepage "https://sjorek.github.io/composer-bash-completion/"
  url "https://github.com/sjorek/composer-bash-completion/archive/v0.2.0.tar.gz"
  sha256 "ce8a11bdbfe36c944454c78535f9f8b4382f99f84cfac64e412d6c540ee6ccf2"
  license "MIT"
  revision 2

  bottle :unneeded

  depends_on "bash-completion@2"

  def install
    inreplace "composer-completion.bash",
              "#COMPOSER_COMPLETION_PHP_SCRIPT=",
              "COMPOSER_COMPLETION_PHP_SCRIPT=#{lib}/composer-completion.php"
    bash_completion.install "composer-completion.bash"
    lib.install "composer-completion.php"
  end

  test do
    assert_match "complete -o bashdefault -o nospace -F _composer_completion composer",
      shell_output("#{HOMEBREW_PREFIX}/bin/bash --norc --noprofile -c 'export PS1=\"TEST\" ; source #{etc}/profile.d/bash_completion.sh && source #{bash_completion}/composer-completion.bash && complete -p composer'")
  end
end
