---
created: 2025-09-02T22:05
updated: 2025-09-06T15:32
---

> > [!IMPORTANT] 🔵 每日任務
> > ```dataviewjs
> > const all = dv.pages('"SmartTaskVault/tasks/Daily Tasks"').file.tasks.where(t => !t.completed);
> > const main = all;
> > main.forEach(t => dv.paragraph(`- [ ] ${t.text}`));
> > ```
> 
> > [!IMPORTANT] 🔴 主要任務（最多2項）
> > ```dataviewjs
> > const all = dv.pages('"SmartTaskVault/tasks"').file.tasks.where(t => !t.completed);
> > const main = all.where(t => t.text.includes("#重要度1")).slice(0, 2);
> > main.forEach(t => dv.paragraph(`- [ ] ${t.text}`));
> > if (main.length < 2) {
> >   dv.paragraph(`➡️ 主要任務少於 2 個，可以從次要任務升級！`);
> > }
> > ```
> 
> > [!IMPORTANT]  🟠 次要任務（最多3項）
> > ```dataviewjs
> >const all = dv.pages('"SmartTaskVault/tasks"').file.tasks.where(t => !t.completed);
> > const secondary = all.where(t => t.text.includes("#重要度2")).slice(0, 3);
> > secondary.forEach(t => dv.paragraph(`- [ ] ${t.text}`));
> > if (secondary.length < 3) {
> >   dv.paragraph(`➡️ 次要任務少於 3 個，可以從待辦升級！`);
> > }
> > 
> > ```
> 
> >[!IMPORTANT] 🟡 待辦任務
> > ```dataviewjs
> >const all = dv.pages('"SmartTaskVault/tasks"').file.tasks.where(t => !t.completed);
> > const rest = all.where(t => t.text.includes("#重要度3"));
> > rest.forEach(t => dv.paragraph(`- [ ] ${t.text}`));
> > ```

> >[!IMPORTANT] 🟢 完成任務(最近3項)
> > ```dataviewjs
const tasks = dv.pages('"SmartTaskVault/tasks"')
  .file
  .tasks
  .where(t => t.completed)
  .sort(t => -t.line) // 以行數代表完成時間
  .slice(0, 3);
>for (let t of tasks) {
  dv.paragraph(`- 🟢 ${t.text}  —  *[${t.path}](obsidian://open?path=${encodeURIComponent(t.path)})*`);
}
> > ```
