# frozen_string_literal: true

cask "vita3k" do
  arch arm: "-arm64"

  version :latest
  sha256 :no_check

  url "https://github.com/Vita3K/Vita3K/releases/download/continuous/macos#{arch}-latest.dmg",
      verified: "github.com/Vita3K/Vita3K/"
  name "Vita3K"
  desc "PlayStation Vita emulator"
  homepage "https://vita3k.org/"

  depends_on macos: :ventura

  app "Vita3K.app"
end
