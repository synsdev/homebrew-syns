class Syns < Formula
  desc "Command-line client for the Syns coordinated multi-agent development platform."
  homepage "https://github.com/synsdev/syns-cli"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.0/syns-aarch64-apple-darwin.tar.gz"
      sha256 "7bef353e5e9c836cb5e775ca8ac106a4ac318b21880d2b56f48261f7fbac80f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.0/syns-x86_64-apple-darwin.tar.gz"
      sha256 "e519a2017db4f8aaabe36858497aeeb1572d0090075538a91df40d05b20cbb9f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.0/syns-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b48ce15b99d2e44b9e3457ec07951eab5e8f5ed726c3bf26acb42391553e36cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.0/syns-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8ac4b80c3b4e708480e43f205eb6bc525c797779cec761af1e21f330fc74cb2e"
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
