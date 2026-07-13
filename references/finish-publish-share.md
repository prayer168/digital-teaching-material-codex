# 「收工」：發布與社群分享流程

使用者在數位教材任務中說「收工」時，完整執行本流程；不要把它解讀成一般道別。

## 1. 鎖定發布範圍

1. 以目前教材專案根目錄為來源。
2. 以本地專案資料夾的 leaf name 作為 GitHub repository 名稱；名稱已符合 GitHub 規則時不得另取名稱。只有名稱不合法時才做最小正規化並回報。
3. 以 `gh api user --jq .login` 取得已登入 owner，不猜測帳號。
4. 載入並遵循 `github-pages-html-deploy` 與 `facebook-post` skills。

## 2. 發布前閘門

1. 重跑正式 build、教材 verifier、物理／資料測試、placeholder、`git diff --check` 與三種 viewport 瀏覽器驗證。
2. 確認沒有未處理主控台錯誤、失敗的本機資源、水平溢出、文字重疊、失效控制或已知內容錯誤。
3. 確認 `docs/references.md`、`docs/test-report.md`、README、版本與適用的 CHANGELOG 已同步。
4. 任一部署閘門失敗就停止，不建立誤導性的完成貼文。

## 3. 建立社群縮圖與 metadata

1. 建立 `1200 × 630` PNG，優先放在 `assets/social-preview.png`。
2. 從教材自有的 SVG、CSS、圖形與文字建立縮圖；不得使用授權不明的影片影格或第三方圖片。文字放在中央安全區，手機縮圖仍可辨讀。
3. 先算出正式網址：
   - 首頁：`https://<owner>.github.io/<repo>/`
   - 圖片：`https://<owner>.github.io/<repo>/assets/social-preview.png`
4. 在 `<head>` 加入絕對 HTTPS 值：`og:type`、`og:url`、`og:title`、`og:description`、`og:image`、`og:image:width`、`og:image:height`、`og:image:alt`，以及相符的 Twitter large-image metadata。
5. 本機驗證 PNG MIME 與精確尺寸，目視確認標題、主體、對比與安全區。

## 4. 建立或更新 GitHub repository

1. 執行 `gh auth status`；未登入就停止。
2. 檢查 `<owner>/<folder-name>` 是否存在。
3. 若不存在，在專案根目錄初始化 `main`、建立 public repo、設定 `origin`、提交並推送。
4. 若已存在，先讀取遠端預設分支與內容；安全整合後再推送，不以 force push 覆寫未知內容。
5. 不提交 `node_modules`、`dist`、暫存下載、開發 log、瀏覽器 profile 或未使用生成檔。
6. 只在提交範圍清楚後 commit；記錄 commit hash 與訊息。

## 5. 啟用並驗證 GitHub Pages

1. 依 `github-pages-html-deploy` skill 從 `main` 根目錄啟用 Pages；等待 status 為 `built`。
2. 驗證公開首頁、CSS、JavaScript、資料、favicon、縮圖均為 HTTP 200。
3. 用公開網址重做至少一項關鍵互動與 390×844 手機檢查。
4. 讀取已渲染 DOM，確認 Open Graph 與 Twitter metadata 是正式絕對網址。

## 6. 產生 Facebook 貼文

1. 依 `facebook-post` skill 產生同一個易複製區塊，順序固定為 `【繁體中文】`、`【English】`。
2. 兩種語言都放入公開教材網址與自然的行動呼籲；內容需具體描述教材的觀察、互動與學習價值。
3. 將最終文字保存為專案根目錄的 `facebook-post.txt`，再提交並推送；若貼文檔本身新增 commit，重新等待 Pages 完成。
4. 確認縮圖公開 URL 回傳圖片 MIME、尺寸為 1200×630；提醒既有分享可能需要 Meta Sharing Debugger 的 **Scrape Again**。

## 7. 完成回報

只有公開驗證全部通過後才回報：

- GitHub repository URL
- GitHub Pages URL
- 社群縮圖 URL
- commit hash 與訊息
- Pages 與公開互動驗證結果
- 一個 fenced `text` 區塊內的完整中英 Facebook 貼文

遇到 GitHub 權限、同名 repo 衝突、Pages 建置失敗或公開資源錯誤時，保留證據並回報阻擋點，不宣告「收工完成」。
