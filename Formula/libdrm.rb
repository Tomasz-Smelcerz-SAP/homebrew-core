class Libdrm < Formula
  desc "Library for accessing the direct rendering manager"
  homepage "https://dri.freedesktop.org"
  url "https://dri.freedesktop.org/libdrm/libdrm-2.4.115.tar.xz"
  sha256 "554cfbfe0542bddb391b4e3e05bfbbfc3e282b955bd56218d21c0616481f65eb"
  license "MIT"

  livecheck do
    url "https://dri.freedesktop.org/libdrm/"
    regex(/href=.*?libdrm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "f831178f945c86dd02df7a721a11aa1863513969c2156ea365e1dcf9ccb4760d"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libpciaccess"
  depends_on :linux

  def install
    system "meson", "setup", "build", "-Dcairo-tests=disabled", "-Dvalgrind=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libdrm/drm.h>
      int main(int argc, char* argv[]) {
        struct drm_gem_open open;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldrm"
  end
end
