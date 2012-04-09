require 'formula'

class Zsh < Formula
  homepage 'http://www.zsh.org/'
  url 'http://sourceforge.net/projects/zsh/files/zsh-dev/4.3.17/zsh-4.3.17.tar.gz'
  md5 '9074077945550d6684ebe18b3b167d52'

  depends_on 'gdbm'
  depends_on 'pcre'

  skip_clean :all

  def patches
    DATA if ARGV.include? "--enable-utf-8-mac-patch"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-etcdir",
                          "--enable-fndir=#{share}/zsh/functions",
                          "--enable-site-fndir=#{share}/zsh/site-functions",
                          "--enable-scriptdir=#{share}/zsh/scripts",
                          "--enable-site-scriptdir=#{share}/zsh/site-scripts",
                          "--enable-cap",
                          "--enable-function-subdirs",
                          "--enable-maildir-support",
                          "--enable-multibyte",
                          "--enable-pcre",
                          "--enable-zsh-secure-free",
                          "--with-tcsetpgrp"

    # Do not version installation directories.
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    system "make install"
  end

  def test
    system "#{bin}/zsh --version"
  end

  def caveats; <<-EOS.undent
    To use this build of Zsh as your login shell, add it to /etc/shells.
    EOS
  end
end

__END__
# Original patch is https://gist.github.com/1403346
--- a/Src/utils.c
+++ b/Src/utils.c
@@ -4208,6 +4208,13 @@ mod_export char *
 zreaddir(DIR *dir, int ignoredots)
 {
     struct dirent *de;
+#ifdef HAVE_ICONV
+    static iconv_t conv_ds = (iconv_t)NULL;
+    static char *conv_name = (char *)NULL;
+    char *temp_name;
+    char *temp_name_ptr, *orig_name_ptr;
+    size_t temp_name_len, orig_name_len;
+#endif
 
     do {
 	de = readdir(dir);
@@ -4216,6 +4223,23 @@ zreaddir(DIR *dir, int ignoredots)
     } while(ignoredots && de->d_name[0] == '.' &&
 	(!de->d_name[1] || (de->d_name[1] == '.' && !de->d_name[2])));
 
+#ifdef HAVE_ICONV
+    if (!conv_ds)
+        conv_ds = iconv_open("UTF-8", "UTF-8-MAC");
+    if (conv_ds) {
+        orig_name_ptr = de->d_name;
+        orig_name_len = strlen(de->d_name);
+        conv_name = zrealloc(conv_name, orig_name_len+1);
+        temp_name_ptr = conv_name;
+        temp_name_len = orig_name_len;
+        if (iconv(conv_ds,&orig_name_ptr,&orig_name_len,&temp_name_ptr,&temp_name_len) >= 0) {
+          *temp_name_ptr = '\0';
+          temp_name = conv_name;
+          return metafy(temp_name, -1, META_STATIC);
+        }
+    }
+#endif
+
     return metafy(de->d_name, -1, META_STATIC);
 }
 
