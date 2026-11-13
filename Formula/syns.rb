class Syns < Formula
  desc "Command-line client for the Syns coordinated multi-agent development platform."
  homepage "https://github.com/synsdev/syns-cli"
  version "0.3.31"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.31/syns-aarch64-apple-darwin.tar.gz"
      sha256 "45a0ec5d32ff370e4e70271fd1f20303917d13b60346325f5d5edff7799191b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.31/syns-x86_64-apple-darwin.tar.gz"
      sha256 "25e1c53ac30807333194249e174e5ceda958140326931e4b05974d4e5fe8e9ae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.31/syns-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e6ce85e3948b5a1031114118c7d6a947317bc7e2d1485b5094f6afeba88ef2c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.31/syns-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0d4f54e2674cb5f3c348fa344d8de2da7a209a98e83de8901cbeb7d38562ac40"
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
