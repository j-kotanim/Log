# Markdownを日本語PDFへ変換する手順

`scripts/md2pdf.sh` は任意のMarkdownファイルを同名PDFへ変換します。

## 依存関係

### 1) OSパッケージ（Ubuntu例）

```bash
sudo apt-get update
sudo apt-get install -y fonts-noto-cjk poppler-utils
```

- `fonts-noto-cjk`: 日本語フォント（Noto Sans/Serif CJK）
- `poppler-utils`: `pdftotext`, `pdffonts` で検証可能

### 2) Node.js / npm

`npx` が使えるNode.js環境が必要です。

## 使い方

```bash
# 入力と同じ場所に同名PDFを作成
scripts/md2pdf.sh 議事録/20260902分科会_議事録.md

# 出力先を明示
scripts/md2pdf.sh input.md output.pdf
```

## 特徴

- A4サイズ、余白付き
- ページ番号（フッター）
- 日本語フォント指定（Noto CJK）
- 見出し、箇条書き、太字、引用、水平線、テーブルに対応
- テーブルは `table-layout: fixed` + 折り返しでページ幅超過を抑制

## 検証例

```bash
# 日本語が抽出できるか確認
pdftotext 議事録/20260902分科会_議事録.pdf - | head

# 埋め込みフォント確認
pdffonts 議事録/20260902分科会_議事録.pdf
```
