---
created: 2025-08-01T02:40
updated: 2025-08-01T14:53
limit: 
Country: 
Review Status: 
savedViews: 
Locations: 23.959455444089688, 120.56954981059482
---
debug item
- [-] 有selection的部份沒跑出選項
- [-] 地圖找地點部份沒作用
- [] 對地點的評價沒有顯示到圖標上(無解QQ)
- [] quartz將筆記轉成網頁板
```dataviewjs
const currentFile = dv.current();
const frontmatter = currentFile.file.frontmatter;
const fileName = currentFile.file.name;

if (frontmatter && frontmatter.Locations) {
    // 清理座標字符串，移除空格和引號
    let coordinates = frontmatter.Locations.toString().trim().replace(/^["']|["']$/g, '');
    
    if (coordinates && coordinates !== "" && coordinates.includes(',')) {
        const parts = coordinates.split(',');
        
        if (parts.length >= 2) {
            const lat = parseFloat(parts[0].trim());
            const lng = parseFloat(parts[1].trim());
            
            if (!isNaN(lat) && !isNaN(lng)) {
                // 顯示座標資訊
                dv.paragraph(`📍 **座標**: ${lat}, ${lng}`);
                
                // 顯示外部地圖連結
                dv.paragraph(`[🗺️ Google Maps](https://maps.google.com/?q=${lat},${lng}) | [🌍 OpenStreetMap](https://www.openstreetmap.org/?mlat=${lat}&mlon=${lng}&zoom=12)`);
                
                // 創建 mapview 配置
                const mapConfig = {
                    "name": "Travel Location",
                    "mapZoom": 10,
                    "centerLat": lat,
                    "centerLng": lng,
                    "query": "",
                    "chosenMapSource": 0,
                    "showLinks": false,
                    "linkColor": "red"
                };
                
                // 嘗試手動插入 mapview
                try {
                    // 創建包含 mapview 代碼的容器
                    const mapDiv = dv.container.createDiv();
                    mapDiv.innerHTML = `
<pre><code class="language-mapview">${JSON.stringify(mapConfig, null, 2)}</code></pre>`;
                    
                    // 觸發 Obsidian 重新解析這個代碼塊
                    if (window.app && window.app.workspace) {
                        setTimeout(() => {
                            window.app.workspace.trigger('parse-style-settings');
                        }, 100);
                    }
                } catch (error) {
                    // 如果自動創建失敗，顯示手動說明
                    dv.paragraph("**請手動添加以下地圖代碼到文件中：**");
                    dv.paragraph("````");
                    dv.paragraph("```mapview");
                    dv.paragraph(JSON.stringify(mapConfig, null, 2));
                    dv.paragraph("```");
                    dv.paragraph("````");
                }
            } else {
                dv.paragraph("❌ 座標格式錯誤，無法解析為數字");
            }
        } else {
            dv.paragraph("❌ 座標格式錯誤，請使用 '緯度,經度' 格式");
        }
    } else {
        dv.paragraph("⚠️ 請在 frontmatter 中設定 Locations 欄位");
        dv.paragraph("格式：`Locations: \"緯度,經度\"`");
    }
} else {
    dv.paragraph("❌ 無法讀取 frontmatter 或 Locations 欄位");
}
```