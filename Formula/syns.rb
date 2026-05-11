class Syns < Formula
  desc "Command-line client for the Syns coordinated multi-agent development platform."
  homepage "https://github.com/synsdev/syns-cli"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.1/syns-aarch64-apple-darwin.tar.gz"
      sha256 "9c4979591ca0c160c3f695d7509f7a4350c2a1383241a0420f6440a93cecf084"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.1/syns-x86_64-apple-darwin.tar.gz"
      sha256 "92e7ae543a5dc47bdcffeac645daf7ec442b4d3382011a9f08e140d28aca18df"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.1/syns-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a0123bb19b49df06bbc046fe92ebbf41e351a9e3dfa689860a40255fd5346d29"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.1/syns-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8b7f7a66507e9a115492d30ff1ba8a0060521ce58fc14d35d9b1579345d5c5c7"
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
