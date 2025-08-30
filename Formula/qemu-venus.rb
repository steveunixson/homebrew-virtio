class QemuVenus < Formula
  desc "QEMU with virglrenderer/OpenGL and Venus (Vulkan over VirtIO)"
  homepage "https://www.qemu.org/"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/qemu-project/qemu.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "meson"      => :build
  depends_on "ninja"      => :build
  depends_on "flex"       => :build
  depends_on "bison"      => :build

  depends_on "glib"
  depends_on "pixman"
  depends_on "libepoxy"
  depends_on "gtk+3"
  depends_on "sdl2"
  depends_on "libslirp"
  depends_on "virglrenderer-venus"
  depends_on "alsa-lib"
  depends_on "libpng"
  depends_on "zstd"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-gtk
      --enable-opengl
      --enable-virglrenderer
      --enable-slirp
      --disable-werror
    ]

    system "./configure", *args
    system "make", "-j", ENV.make_jobs.to_s
    system "make", "install"

    ohai "Built QEMU with virglrenderer and Venus support."
  end

  test do
    system "\#{bin}/qemu-system-x86_64", "--version"
  end
end
