class Syns < Formula
  desc "Command-line client for the Syns coordinated multi-agent development platform."
  homepage "https://github.com/synsdev/syns-cli"
  version "0.3.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.14/syns-aarch64-apple-darwin.tar.gz"
      sha256 "1acc0c7610caa737506aace83a497746c54258b64f370b62b1c398006de434cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.14/syns-x86_64-apple-darwin.tar.gz"
      sha256 "f5b167ae5a73b57ab6df2034f5bfad7db9cc9193173de0c68c25d504dcc3d4a7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.14/syns-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3ab0ee96d322553db4991b009abca95ae6c67cfdb688430f5f22d92c5ee352c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/synsdev/syns-cli/releases/download/v0.3.14/syns-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8a33d0ee0b116fb1a18c120d6d6aed673ff39c4600b261214f5c3bf2ddabe3ca"
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
