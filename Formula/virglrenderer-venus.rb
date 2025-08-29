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

  def install
    py = Formula["python@3.12"].opt_bin/"python3"
    ENV["PYTHON"] = py

    # Устанавливаем pyyaml прямо в buildpath (чтобы не требовалась системная формула)
    system py, "-m", "pip", "install", "pyyaml", "--target=#{buildpath}/pydeps"

    ENV.prepend_path "PYTHONPATH", buildpath/"pydeps"

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
