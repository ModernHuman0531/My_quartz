---
created: 2025-08-02T23:23
updated: 2025-08-03T01:41
---


<%*
const files = await app.vault.getMarkdownFiles();
const targetFiles = files.filter(f => f.path.startsWith("SmartTaskVault/tasks/"));

// 使用者先選要升級哪個等級
const levelOptions = ["升級 #重要度2 → #重要度1", "升級 #重要度3 → #重要度2"];
const levelPick = await tp.system.suggester(levelOptions, levelOptions);

let fromTag, toTag;
if (levelPick === levelOptions[0]) {
  fromTag = "#重要度2";
  toTag = "#重要度1";
} else {
  fromTag = "#重要度3";
  toTag = "#重要度2";
}

// 搜尋所有含有 fromTag 的任務
let candidates = [];
for (let file of targetFiles) {
  const content = await app.vault.read(file);
  const lines = content.split("\n");
  for (let i = 0; i < lines.length; i++) {
    if (lines[i].includes(fromTag)) {
      candidates.push({file, line: lines[i], index: i});
    }
  }
}

if (candidates.length === 0) {
  tR += `🚫 沒有可升級的 ${fromTag} 任務`;
  return;
}

// 選擇任務進行升級
const options = candidates.map((c, i) => `${i + 1}. ${c.line}`);
const pick = await tp.system.suggester(options, candidates);

// 修改該行的 tag
const updatedLines = (await app.vault.read(pick.file)).split("\n");
updatedLines[pick.index] = updatedLines[pick.index].replace(fromTag, toTag);

// 寫回檔案
await app.vault.modify(pick.file, updatedLines.join("\n"));
tR += `✅ 已升級任務：\n${updatedLines[pick.index]}`;
%>
