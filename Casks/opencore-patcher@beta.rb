# frozen_string_literal: true

cask "opencore-patcher@beta" do
  version "3.0.0-rc.5"
  sha256 "0a604e738b83ca36a7392cad20e329057033122261db9dc4d8e9135fc5d8430c"

  url "https://github.com/dortania/OpenCore-Legacy-Patcher/releases/download/#{version}/OpenCore-Patcher.pkg"
  name "OpenCore Legacy Patcher"
  desc "Boot loader to inject/patch current features for unsupported Macs"
  homepage "https://dortania.github.io/OpenCore-Legacy-Patcher/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+(?:-rc\.\d+)?)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        release["tag_name"]&.[](regex, 1)
      end
    end
  end

  conflicts_with cask: "opencore-patcher"
  depends_on :macos

  pkg "OpenCore-Patcher.pkg"

  uninstall launchctl: [
              "com.dortania.opencore-legacy-patcher.auto-patch",
              "com.dortania.opencore-legacy-patcher.macos-update",
            ],
            pkgutil:   "com.dortania.opencore-legacy-patcher",
            delete:    "/Applications/OpenCore-Patcher.app"

  zap trash: [
    "/Library/Logs/DiagnosticReports/OpenCore-Patcher_*.*_resource.diag",
    "/Users/Shared/.com.dortania.opencore-legacy-patcher.plist",
    "/Users/Shared/.OCLP-AutoPatcher-Log-*.txt",
    "/Users/Shared/.OCLP-System-Log-*.txt",
    "/Users/Shared/OpenCore-Patcher_*.log",
    "~/Library/Application Support/CrashReporter/OpenCore-Patcher*",
    "~/Library/Caches/com.dortania.opencore-legacy-patcher",
    "~/Library/Logs/Dortania",
    "~/Library/Preferences/com.dortania.opencore-legacy-patcher-wxpython.plist",
    "~/Library/Saved Application State/com.dortania.opencore-legacy-patcher-wxpython.savedState",
    "~/Library/Saved Application State/com.dortania.opencore-legacy-patcher.savedState",
    "~/Library/WebKit/com.dortania.opencore-legacy-patcher",
  ]
end
