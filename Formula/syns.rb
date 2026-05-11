class Syns < Formula
  desc "Command-line client for the Syns coordinated multi-agent development platform."
  homepage "https://github.com/synsdev/syns-cli"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.2/syns-aarch64-apple-darwin.tar.gz"
      sha256 "e66d0c680f34ea2a157210c5f7daa9bc3a49d43e531f67f76cc1baa22967408c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.2/syns-x86_64-apple-darwin.tar.gz"
      sha256 "e939152f3bc74e51f89ef94c481c0fdbd0c1088848da92dad413bb8cb9f2bd11"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.2/syns-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ad8a46da4ff3fdc6edd2e2b2bd8d6eb263987e58bb9178ad4f91463f7e8e2a6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.2/syns-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e96e9169888855b05b038166a6be7ff6587e72ee0dad42f1ac7f4b395cdd39e4"
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
    bin.install "syns" if OS.mac? && Hardware::CPU.arm?
    bin.install "syns" if OS.mac? && Hardware::CPU.intel?
    bin.install "syns" if OS.linux? && Hardware::CPU.arm?
    bin.install "syns" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
