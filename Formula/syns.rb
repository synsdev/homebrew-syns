class Syns < Formula
  desc "Command-line client for the Syns coordinated multi-agent development platform."
  homepage "https://github.com/synsdev/syns-cli"
  version "0.3.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.7/syns-aarch64-apple-darwin.tar.gz"
      sha256 "3a2a8aa0343003e5d0f9103f5ff78b2e5221f2fcac06b3ad8fbc9286187ffa4d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.7/syns-x86_64-apple-darwin.tar.gz"
      sha256 "cfdfd5c0c9b10f61c59dc9e0db21c8f9ecefb8470dcb5267462ef2e57f45c516"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.7/syns-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1b3e31e67bb9f459013897f8616513d7db29ba3b94179f106978af07adf667b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.7/syns-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "03a226899ef1020412a1c98d9a0ce2a2dfe59d8891b411519107017717c66c80"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "syns"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "syns"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "syns"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "syns"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
