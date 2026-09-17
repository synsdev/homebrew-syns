class Syns < Formula
  desc "Command-line client for the Syns coordinated multi-agent development platform."
  homepage "https://github.com/synsdev/syns-cli"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.2/syns-aarch64-apple-darwin.tar.gz"
      sha256 "ff02551d28780c04441a5cd10e0bec200c3d698d53eb793ac93740f453f3d61d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.2/syns-x86_64-apple-darwin.tar.gz"
      sha256 "300a53e8b1f75521bf24cc6f5ec4ae7a6575d2c297e934b86bc0d224fdf7629f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.2/syns-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "534d90d5d47baec0b110526f94dbdd080d277148f1ad8d53490a2ad88682a84e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.2/syns-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3f6463a0b2ce0c5e9141b8e23ed95c8f4dc5681ae85a347901cb934a7b8be133"
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
