# world_log 工作回報站 — 使用 & 部署說明

零建置（no build step）靜態站。丟 `.md`、push、自動上線。

- **線上網址**：`https://segv0x41.com`
- **本機資料夾**：`D:\htht`
- **GitHub**：`https://github.com/anixwindy/web_htht`
- **部署**：Cloudflare Workers，push 到 `main` 就自動上線
- **Cloudflare 專案**：Worker 名 `web-htht`（帳號 `snowaex3`）

## 目錄結構

```
htht/
├── index.html          首頁（自動列清單，不用改）
├── post.html           文章檢視器（不用改）
├── posts.json          清單（跑 gen_posts.bat 自動生，不用手改）
├── assets/style.css    樣式（終端綠主題）
├── assets/app.js       markdown 渲染邏輯
├── gen_posts.py        掃 posts/ 自動生 posts.json（路徑可攜）
├── gen_posts.bat       雙擊執行上面那支
├── new_post.ps1 / .bat 建新文章的小工具
├── push.bat        ★   一鍵發布（重生 posts.json → 列檔案 → commit → push）
└── posts/              ★ 文章都放這（.md）
    └── _模板.md        ★ 三格模板，複製這份
```

## 每次寫一篇（兩次雙擊）

1. **雙擊 `new_post.bat`** — 自動用今天日期建檔、自動填好 H1 的日期與編號、自動開編輯器
2. 填三格，存檔（UTF-8）
3. **雙擊 `push.bat`** — 它會自動重生 `posts.json`、**列出將要公開的檔案**、問你一句 commit 訊息（直接 Enter 就用日期自動填），然後 push

`push.bat` 列出檔案那一步是唯一擋在「私人筆記誤放進 `posts/`」和「它出現在公開網站上」之間的東西——**打訊息之前掃一眼那份清單**。任何一步失敗它都會停住並顯示原因，不會偷偷推上去。

推完等約 30 秒，Cloudflare 建置完成，開網站 `Ctrl` + `F5` 看結果。

手動版（不想用腳本時）：複製 `posts/_模板.md` → 改名成 `posts/YYYY-MM-DD_工作回報.md` → 改第一行標題 → 雙擊 `gen_posts.bat` → `git add . && git commit -m "log: YYYY-MM-DD" && git push`。

## 模板就三格

```markdown
# YYYY-MM-DD — 工作回報 #N：【一句話標題】

## 今天讀/做了什麼
-

## 卡關點
-

## 下週開始預計做什麼
-
```

刻意做到最小。**格子越多、摩擦越大、越不會寫。**

## 檔名規則（硬性，靠檔名自動分類）

| 類型 | 檔名 | 進哪一區 |
|---|---|---|
| 工作回報 | `YYYY-MM-DD_工作回報.md` | 工作回報（依日期排序） |
| 已完成專案 | `<name>_project.md` | 已完成專案 |
| 模板 / 雜物 | `_` 開頭 | **被忽略，不會上站** |

已完成專案可在檔案任一處放一行標日期與標籤：

```
<!-- date: 2026-08-09; tags: 線性代數, 驗證 -->
```

沒放的話，日期用檔案修改時間、標籤留空。

## 本機預覽

直接雙擊 `index.html` **不會動**（`fetch` 在 `file://` 被瀏覽器擋）。要開本機伺服器：

```powershell
cd D:\htht
python -m http.server 8000
# 瀏覽器開 http://localhost:8000
```

## markdown 只要記兩條

- 清單用「**減號 + 一個空格**」，例：`- 今天推了餘弦定理`
- **清單前面要空一行**，否則會被吸進上一段

（本站 `marked` 的 `breaks` 設為 false，所以單純換行不會斷行。）

想貼程式碼，用三個反引號包起來，開頭那行可標語言：

````
```python
print("hi")
```
````

## 說明

- markdown 渲染用 CDN 的 `marked` + `highlight.js`（觀看者連得上網即可，本機不用裝東西）。
- 想完全離線自帶，可把那兩支 js 下載到 `assets/`，再改 `post.html` 的 `<script src>`。
