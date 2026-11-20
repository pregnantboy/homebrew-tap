class Kat < Formula
  desc "macOS terminal UI for quitting apps and stopping processes on listening ports"
  homepage "https://github.com/pregnantboy/kat#readme"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pregnantboy/kat/releases/download/v0.1.0/kat-aarch64-apple-darwin.tar.xz"
      sha256 "b88692bac14fa1384f9f16d4c9eef98e739aab68eef633fc0104540458096dac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pregnantboy/kat/releases/download/v0.1.0/kat-x86_64-apple-darwin.tar.xz"
      sha256 "39dd046c0e32797bd1e14641ebef87227b31eb8303270f9e8dc82dc7a91d316b"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
      bin.install "kat"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "kat"
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
