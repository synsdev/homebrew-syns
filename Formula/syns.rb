class Syns < Formula
  desc "Command-line client for the Syns coordinated multi-agent development platform."
  homepage "https://github.com/synsdev/syns-cli"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.5/syns-aarch64-apple-darwin.tar.gz"
      sha256 "58e7598578b6c923000e69703f68fc371ad64800a94f6a4a240cf736d1d24f14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.5/syns-x86_64-apple-darwin.tar.gz"
      sha256 "9425821d6a427e7d9535a874074de19721d9d349a657c551d7ab72d839744dc2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.5/syns-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1a04cbf5f83bf8a5f4bd17b46f409890732edd1bd8f3ded166d90985b862e2aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.5/syns-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "da35437dad96fbc2cda118c7ab4a2466412bdbece285d144f91cd9d85a8743ce"
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
