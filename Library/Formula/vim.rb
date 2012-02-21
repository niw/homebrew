require 'formula'

# NOTE installing vim +ruby under rvm, we need to clear rvm environment variables before installing.
# env -i HOME=/Users/#{user} PATH=/usr/local/bin:/usr/bin:/bin TERM=xterm-color HOMEBREW_TEMP=#{path to ramdisk, if needed.} /usr/local/bin/brew install vim

class Vim <Formula
  # Get stable versions from hg repo instead of downloading an increasing
  # number of separate patches.
  url 'https://vim.googlecode.com/hg/', :revision => '068bb8a58a4eec6acde927c28729b0c6dcc8545a'
  version '7.3.446'
  homepage 'http://www.vim.org/'

  head 'https://vim.googlecode.com/hg/'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-gui",
                          "--without-x",
                          "--disable-gpm",
                          "--disable-nls",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-pythoninterp",
                          "--enable-rubyinterp",
                          "--with-features=huge"
    system "make"
    system "make install"
  end
end
