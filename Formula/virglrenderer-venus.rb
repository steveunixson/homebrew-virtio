class VirglrendererVenus < Formula
  desc "VirGL virtual 3D GPU driver (with Venus Vulkan support)"
  homepage "https://gitlab.freedesktop.org/virgl/virglrenderer"
  license "MIT"
  head "https://gitlab.freedesktop.org/virgl/virglrenderer.git", branch: "main"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build

  depends_on "libepoxy"
  depends_on "libdrm"
  depends_on "mesa"
  depends_on "wayland"
  depends_on "xorgproto"
  depends_on "libyaml"
  depends_on "pyyaml"

  # Vendored PyYAML для meson (без homebrew/core формулы)
  resource "pyyaml" do
    url "https://github.com/yaml/pyyaml/archive/refs/tags/6.0.2.tar.gz"
    sha256 "9377c381ac3fccad8df73d96b5139ef8b1a2c57a0d913e95ab0a2275d66b5caa"
  end

  def install
    system "meson", "setup", "build",
           *std_meson_args,
           "-Dvenus=true"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    system "pkg-config", "--exists", "virglrenderer"
  end
end
