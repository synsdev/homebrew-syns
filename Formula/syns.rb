class Syns < Formula
  desc "Command-line client for the Syns coordinated multi-agent development platform."
  homepage "https://github.com/synsdev/syns-cli"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.4/syns-aarch64-apple-darwin.tar.gz"
      sha256 "8afe29b1eadcc1a9c5cd9649cfc161e15ddbafa6d98bbb73151c846bfb743b9e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.4/syns-x86_64-apple-darwin.tar.gz"
      sha256 "373217ab6012d45e77539fb8aca7ff69881da84b747b2d810023dcdd444ba357"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.4/syns-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5f092eb614b38677fb328fa32d6ae3199c67169dfa3899b249168f33050a7101"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.4/syns-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "97aba478d886a24d557cd2149949806f0729c0e08e8c53d4377730bd4f347111"
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
