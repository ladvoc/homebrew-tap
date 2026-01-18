class RustCliTemplate < Formula
  desc "CLI starter template for Rust."
  homepage "https://github.com/ladvoc/rust-cli-template"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/ladvoc/rust-cli-template/releases/download/v0.1.0/rust-cli-template-aarch64-apple-darwin.tar.xz"
      sha256 "5359d57968e5a1ace92acf30fb9ffb6c01a0b8aa3641b32a2e7d12b6be8a5176"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ladvoc/rust-cli-template/releases/download/v0.1.0/rust-cli-template-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "912c4fb520932c7daa6ef7267884754cd0b9e5b4c0c949b833c8196db5194450"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ladvoc/rust-cli-template/releases/download/v0.1.0/rust-cli-template-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3abe5d3eaa001ecf99467f0fafe6b5e5321b01ab8d3555a89a765a460f19103d"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "rust-cli-template" if OS.mac? && Hardware::CPU.arm?
    bin.install "rust-cli-template" if OS.linux? && Hardware::CPU.arm?
    bin.install "rust-cli-template" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
