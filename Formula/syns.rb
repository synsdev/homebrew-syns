class Syns < Formula
  desc "Command-line client for the Syns coordinated multi-agent development platform."
  homepage "https://github.com/synsdev/syns-cli"
  version "0.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.7/syns-aarch64-apple-darwin.tar.gz"
      sha256 "f2566e82966389c6714c298c59e034b071cac3eb5b8bf11425d92182a443009c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.7/syns-x86_64-apple-darwin.tar.gz"
      sha256 "06dd1ec36efccbb952bc3064acd1e1e4cf5f6b160a23aa209d0ae62656f17237"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.7/syns-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c0a7f6531db13959d3723d8eeacbc6f8f6d52808ecbba498b4a8472051a34700"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.2.7/syns-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "53e4fc3bf1f184731bf477871964d96b2ef0b2efd0b609a85869d3f170a647fd"
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
