require 'formula'

# NOTE installing vim +ruby under rvm, we need to clear rvm environment variables before installing.
# env -i HOME=/Users/#{user} PATH=/usr/local/bin:/usr/bin:/bin TERM=xterm-color HOMEBREW_TEMP=#{path to ramdisk, if needed.} /usr/local/bin/brew install vim

class Vim <Formula
  # Get stable versions from hg repo instead of downloading an increasing
  # number of separate patches.
  url 'https://vim.googlecode.com/hg/', :revision => '24b41d74f6a9e00514dcf1c3c63683a0b6ff2991'
  version '7.3.146'
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
