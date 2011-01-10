require 'formula'

class Libxslt < Formula
  url 'ftp://xmlsoft.org/libxml2/libxslt-1.1.26.tar.gz'
  homepage 'http://xmlsoft.org/XSLT/'
  md5 'e61d0364a30146aaa3001296f853b2b9'
  depends_on 'libxml2'

  keg_only :provided_by_osx

  def install
    libxml2_prefix = `brew --prefix libxml2`
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-libxml-prefix=#{libxml2_prefix}"

    system "/usr/bin/make"
    system "/usr/bin/make install"
  end
end