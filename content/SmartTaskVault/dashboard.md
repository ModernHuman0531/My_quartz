---
created: 2025-08-02T23:23
updated: 2025-08-03T01:27
---

> [!multi-column]

> > [!IMPORTANT] 🔴 主要任務（最多2項）
> > ```dataviewjs
> > const all = dv.pages('"SmartTaskVault/tasks"').file.tasks.where(t => !t.completed);
> > const main = all.where(t => t.text.includes("#重要度1")).slice(0, 2);
> > main.forEach(t => dv.paragraph(`- [ ] ${t.text}`));
> > if (main.length < 2) {
> >   dv.paragraph(`➡️ 主要任務少於 2 個，可以從次要任務升級！`);
> > }
> > 
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
> > 
> > ```




> 