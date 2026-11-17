# frozen_string_literal: true

cask "m-vave-midi-suite" do
  version "2026.09.30.005134"
  sha256 "355dfa6129c3162dbb5a02f431a1884a79bc0b374a61204462f96829dd5f1a25"

  url "https://yms-file-store.oss-cn-hongkong.aliyuncs.com/software/pc/MidiSuite_new.dmg?v=#{version}"
  name "Midi Suite"
  desc "Editor for M-VAVE SMK keyboards and SMC pad and mixer controllers"
  homepage "https://www.m-vave.com/download.html"

  livecheck do
    url :url
    strategy :header_match do |headers|
      Time.httpdate(headers["last-modified"]).utc.strftime("%Y.%m.%d.%H%M%S")
    end
  end

  depends_on :macos

  app "Midi Suite.app"

  zap trash: [
    "~/Library/Application Scripts/com.musicalinstruments.musicalInstruments",
    "~/Library/Containers/com.musicalinstruments.musicalInstruments",
  ]
end
