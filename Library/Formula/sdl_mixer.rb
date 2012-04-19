require 'formula'

class SdlMixer < Formula
  url 'http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.11.tar.gz'
  homepage 'http://www.libsdl.org/projects/SDL_mixer/'
  md5 '65ada3d997fe85109191a5fb083f248c'

  depends_on 'sdl'
  depends_on 'flac' => :optional
  depends_on 'libmikmod' => :optional
  depends_on 'libvorbis' => :optional

  def install
    inreplace 'SDL_mixer.pc.in', '@prefix@', HOMEBREW_PREFIX

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
