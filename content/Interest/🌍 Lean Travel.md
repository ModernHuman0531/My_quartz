---
created: 2025-07-31T01:46
updated: 2025-08-01T03:27
cssclasses:
  - dashboard
  - hide-properties
tags: 
---
# ⚡ Quick Actions

> [!multi-column]
> > ➕ Add
> > ```button
> > name Trip
> > type command
> > action QuickAdd: New Trip
> > color blue
> > ```
> > ^button-AddTrip
> 
> > ➕ Add
> > ```button
> > name Accommodation
> > type command
> > action QuickAdd: New Accommodation
> > color blue
> > ```
> > ^button-AddAccommodation
> 
> > ➕ Add
> > ```button
> > name Landmark
> > type command
> > action QuickAdd: New Landmark
> > color blue
> > ```
> > ^button-Addlandmark
> 
> > ➕ Add
> > ```button
> > name Location
> > type command
> > action QuickAdd: New Location
> > color blue
> > ```
> > ^button-AddLocation
> > 
> > ➕ Add
> > ```button
> > name Restaurant
> > type command
> > action QuickAdd: New Restaurant/Bar
> > color blue
> > ```
> > ^button-AddRestaurantandBar
> > 

# ✈️ Trips
- ⏳ Planned
```dataviewjs
dv.list(dv.pages('').filter(f => f.file.path.startsWith("Travel/")).filter(f => f.tags && Array.isArray(f.tags) ? f.tags.some(tag => tag.includes("Trip")) : false).filter(f => f["Travel Status"] && f["Travel Status"].includes("Planned")).sort(f => f.Departure, "asc").map(f => `${f.file.link}\n${f.Country}`))
```
- 🧪 Booked
```dataviewjs
dv.list(dv.pages('').filter(f => f.file.path.startsWith("Travel/")).filter(f => f.tags && Array.isArray(f.tags) ? f.tags.some(tag => tag.includes("Trip")) : false).filter(f => f["Travel Status"] && f["Travel Status"].includes("Booked")).sort(f => f.Departure, "asc").map(f => `${f.file.link}\n${f.Country}`))
```
- 🌙 Missing review
```dataviewjs
dv.list(dv.pages('').filter(f => f.file.path.startsWith("Travel/")).filter(f => f.tags && Array.isArray(f.tags) ? f.tags.some(tag => tag.includes("Trip")) : false).filter(f => f["Travel Status"] && f["Travel Status"].includes("Over")).filter(f => f["Review Status"] && f["Review Status"].includes("Missing")).sort(f => f.Departure, "desc").map(f => `${f.file.link}\n${moment(f.Return).format("DD-<<-YYYY")}`))
```
# ⏰ Top 10
- 💡 Most recent trips
```dataviewjs
dv.list(dv.pages('').filter(f => f.file.path.startsWith("Travel/")).filter(f => f.tags && Array.isArray(f.tags) ? f.tags.some(tag => tag.includes("Trip")) : false).filter(f => f["Travel Status"] && f["Travel Status"].includes("Over")).sort(f => f.Return, "desc").map(f => `${f.file.link}\n${f.Country}`).slice(0,10))
```
- 📝 Most recent landmarks
```dataviewjs
dv.list(
  dv.pages('')
    .filter(f => f.file.path.startsWith("Travel/"))
    .filter(f => f.tags && Array.isArray(f.tags) ? f.tags.some(tag => tag.includes("Landmark")) : false)
    .filter(f => f.Visited === true)
    .sort(f => f.Return, "desc")
    .map(f => `${f.file.link}\n${f.Country}`)
    .slice(0, 10)
);

```
- 📈 Best rated trips
# ✅ Completed
- 🗂️ This year
```dataviewjs
const currentYear = new Date().getFullYear(); // 取得目前年份

dv.list(
  dv.pages('')
    .filter(f => Array.isArray(f.tags) ? f.tags.some(tag => tag.includes("Trip")) : false)
    .filter(f => f["Review Status"] && f["Review Status"].includes("Done"))
    .filter(f => {
      const departureDate = new Date(f.Departure);
      return departureDate.getFullYear() === currentYear;
    })
    .sort(f => f.file.link, "asc")
    .map(f => f.file.link)
);

```
- 📄 Last year
```dataviewjs
const currentYear = new Date().getFullYear(); // 取得目前年份
const previousYear = currentYear - 1;
dv.list(
  dv.pages('')
    .filter(f => Array.isArray(f.tags) ? f.tags.some(tag => tag.includes("Trip")) : false)
    .filter(f => f["Review Status"] && f["Review Status"].includes("Done"))
    .filter(f => {
      const departureDate = new Date(f.Departure);
      return departureDate.getFullYear() === previousYear;
    })
    .sort(f => f.file.link, "asc")
    .map(f => f.file.link)
);

```
- 🗑️ Older
```dataviewjs
const currentYear = new Date().getFullYear(); // 取得目前年份
const startOfPreviousYear = new Date(currentYear - 1,0,1);
dv.list(
  dv.pages('')
    .filter(f => Array.isArray(f.tags) ? f.tags.some(tag => tag.includes("Trip")) : false)
    .filter(f => f["Review Status"] && f["Review Status"].includes("Done"))
    .filter(f => {
      const departureDate = new Date(f.Departure);
      return departureDate < startOfPreviousYear;
    })
    .sort(f => f.file.link, "asc")
    .map(f => f.file.link)
    .slice(0,10)
);

```
