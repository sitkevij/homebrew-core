require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.2.0/stack-1.2.0-sdist-0.tar.gz"
  version "1.2.0"
  sha256 "872d29a37fe9d834c023911a4f59b3bee11e1f87b3cf741a0db89dd7f6e4ed64"
  revision 1

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7718cf647ff1a01974a3fd3822b427a7a3b394888b26ff34a1b34132e426618c" => :el_capitan
    sha256 "c50e4f828934a2acca302ff5f675ea82e1de4ed32f3df450ffdbc3ce0f23f4b6" => :yosemite
    sha256 "88a6e11cbc4cf4ea98ef81113cd0bee64edd630abec8a37e4cc89d8480764ba9" => :mavericks
  end

  option "without-bootstrap", "Don't bootstrap a stage 2 stack"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    if build.with? "bootstrap"
      cabal_sandbox do
        cabal_install
        # Let `stack` handle its own parallelization
        # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
        jobs = ENV.make_jobs
        ENV.deparallelize do
          system "stack", "-j#{jobs}", "setup"
          system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
        end
      end
    else
      install_cabal_package
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
