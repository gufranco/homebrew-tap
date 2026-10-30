<div align="center">

<h1>homebrew-tap</h1>

<strong>kodougu のコマンドラインツール、私が保守しているその他のツール、そして Homebrew が配布をやめたアプリをまとめた Homebrew の tap です。</strong>

[English](README.md) | 日本語 | [简体中文](README.zh-Hans.md) | [繁體中文 (香港)](README.zh-HK.md)

[![ci](https://img.shields.io/github/actions/workflow/status/gufranco/homebrew-tap/ci.yml?branch=main&style=flat-square&label=ci)](https://github.com/gufranco/homebrew-tap/actions/workflows/ci.yml)
[![license](https://img.shields.io/github/license/gufranco/homebrew-tap?style=flat-square&label=license)](LICENSE)

<p align="center">
  <a href="#quick-start"><strong>クイックスタート</strong></a> |
  <a href="#how-it-stays-current">最新に保つ仕組み</a> |
  <a href="#development">開発</a>
</p>

</div>

12 個の formula、8 個の cask、そしてそれらを最新に保つ Ruby のコードです。tap は小さな clone で、formula と cask の定義だけを持ち、プロジェクトのソースは含みません。

---

```console
$ brew search gufranco/tap/
gufranco/tap/anypatch
gufranco/tap/aseprite
gufranco/tap/fdstoolkit
gufranco/tap/fusho
gufranco/tap/jimaku
gufranco/tap/kakikomi
gufranco/tap/kiyome
gufranco/tap/maeyomi
gufranco/tap/maxcso
gufranco/tap/shiwake
gufranco/tap/torrentzip
gufranco/tap/yakitsuke

gufranco/tap/furnace
gufranco/tap/lazpaint
gufranco/tap/ldtk
gufranco/tap/libresprite
gufranco/tap/lmms
gufranco/tap/pikopixel
gufranco/tap/pixelorama
gufranco/tap/sunvox
```

<a id="quick-start"></a>

## クイックスタート

### 前提条件

macOS 上の [Homebrew](https://brew.sh)。cask と `aseprite` は macOS 専用です。

### インストール

```bash
brew tap gufranco/tap
brew install gufranco/tap/kakikomi
brew install --cask gufranco/tap/pixelorama
```

### 確認

```bash
brew test gufranco/tap/kakikomi
kakikomi doctor
```

`brew test` は formula 自身のテストを実行します。kodougu の各ツールには、見つかった依存関係を一覧表示する `doctor` コマンドもあります。

## 使い方

### kodougu

共通のインターフェースを持つコマンドラインツールです。詳しくは各ツールの `FAMILY.md` にあります。

| Formula | 内容 |
|:--------|:-----|
| [fusho](https://github.com/gufranco/fusho) | 受信者が公開している SSH 鍵を使い、任意のチャットで暗号化したメッセージを送ります |
| [jimaku](https://github.com/gufranco/jimaku) | 動画の字幕をダウンロードし、UTF-8 で保存します |
| [kakikomi](https://github.com/gufranco/kakikomi) | ディスクイメージをリムーバブルメディアに書き込み、チャンクごとに検証し、マウントさせません |
| [kiyome](https://github.com/gufranco/kiyome) | 5 つの検証済みパターンでディスクを上書きし、故障したビット線を特定します |
| [shiwake](https://github.com/gufranco/shiwake) | フォルダ内のファイルを先頭の文字で A から Z のサブフォルダに振り分けます |
| [yakitsuke](https://github.com/gufranco/yakitsuke) | あらゆる動画を、読みやすい字幕付きの Video CD イメージに変換し、複数のディスクに分割します |

### 私のその他のツール

| Formula | 内容 |
|:--------|:-----|
| [anypatch](https://github.com/gufranco/anypatch) | 文書化されたあらゆる形式のバイナリパッチを読み書き、統合、変換します |
| [fdstoolkit](https://github.com/gufranco/fdstoolkit) | ファミリーコンピュータ ディスクシステムのメディアを読み取り、評価、再構築、書き込みします |
| [maeyomi](https://github.com/gufranco/maeyomi) | バーコードバトラーやバーコードゲーム用の遊べるカードを印刷します |

### サードパーティのツール

| Formula | 内容 |
|:--------|:-----|
| [maxcso](https://github.com/unknownbrackets/maxcso) | PSP と PS2 のディスクイメージをマルチスレッドで CSO、ZSO、DAX に圧縮します |
| [torrentzip](https://github.com/0-wiz-0/trrntzip) | アーカイブを正規化された再現可能な TorrentZip 形式に再圧縮します。コマンド名は `trrntzip` です |
| [aseprite](https://www.aseprite.org/) | 公開されているソースと対応するビルド済み Skia から Aseprite スプライトエディタをビルドします。個人利用ではこのビルドが許諾されています。ビルドには時間がかかります |

### アプリ

これらの cask は、アプリが公証を通らなくなった時点で homebrew-cask から削除されたものです。内容は変更しておらず、Gatekeeper の判断に従います。

| Cask | 内容 |
|:-----|:-----|
| [furnace](https://tildearrow.org/furnace/) | 多機種対応のチップチューン・トラッカー |
| [lazpaint](https://bgrabitmap.github.io/lazpaint/) | レイヤー、フィルター、スクリプトに対応した画像エディタ。Rosetta 2 で動作します |
| [ldtk](https://ldtk.io/) | 2D レベルエディタ |
| [libresprite](https://libresprite.github.io/) | Aseprite スプライトエディタのフリーなフォーク |
| [lmms](https://lmms.io/) | デジタル・オーディオ・ワークステーション。Rosetta 2 で動作します |
| [pikopixel](https://twilightedge.com/mac/pikopixel/) | インデックスカラー画像用のドット絵エディタ。Rosetta 2 で動作します |
| [pixelorama](https://orama-interactive.itch.io/pixelorama) | スプライトエディタ兼ドット絵ツール |
| [sunvox](https://www.warmplace.ru/soft/sunvox/) | モジュラー・シンセサイザー兼トラッカー |

初回起動時に macOS がアプリをブロックした場合は、`xattr -dr com.apple.quarantine /Applications/<App>.app` で隔離フラグを外すか、`--no-quarantine` を付けてインストールしてください。

<a id="how-it-stays-current"></a>

## 最新に保つ仕組み

- **私のツールのリリース。** ツールのリポジトリが新しいタグを付けて `formula-bump` の dispatch を送ります。tap はそのタグのアーカイブをダウンロードし、中のバージョンがタグと一致することを確かめ、formula の `url` と `sha256` を書き換え、ソースからビルドしてテストを実行し、そのあとで初めて `main` にコミットします。現在のタグより古いタグの dispatch では何も変わりません。
- **サードパーティのアプリ。** 1 日 3 回、各 cask と `aseprite` を上流と比較し、新しいバージョンがあればプルリクエストを開きます。`aseprite` の formula を変更するプルリクエストでは、ソースからビルドし直します。
- **tap 自体。** CI はプッシュのたびと 1 日 3 回実行されます。Ubuntu と macOS でのテスト、ワークフローの lint、そしてすべての formula と cask に対する Homebrew の style チェックと厳格なオンライン監査です。上流の URL が使えなくなっても数時間以内に分かります。Dependabot は GitHub Actions と gem を 1 日 3 回確認し、CI が通ると自分の更新をマージします。

<a id="development"></a>

## 開発

```bash
bundle install
bundle exec rake hooks
```

| コマンド | 内容 |
|:---------|:-----|
| `bundle exec rake test` | Minitest のテスト。すべてのファイルで行カバレッジと分岐カバレッジ 100% を必須とします |
| `bundle exec rake lint` | ワークフローに actionlint、すべての YAML ファイルに yamllint |
| `bundle exec rake style` | すべての formula、cask、Ruby ファイルに Homebrew の tap 用 style ルール |
| `bundle exec rake audit` | すべての formula と cask に対する Homebrew の厳格なオンライン監査 |
| `bundle exec rake check` | lint、test、style |
| `bundle exec rake hooks` | lint と test を実行する pre-commit フック |
| `bundle exec rake formula:bump NAME=x TAG=vX.Y.Z` | bump ワークフローと同じように `Formula/x.rb` をリリースに向けます |

`rake style` と `rake audit` は Homebrew がインストールした tap を検査するため、まずその clone をこのチェックアウトの `HEAD` まで fast-forward します。テストは実際の `git` と `curl` を、一時的なリポジトリとアーカイブに対して実行します。

## ライセンス

[MIT](LICENSE)
