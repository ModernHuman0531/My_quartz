<%*
  let title = tp.file.title
  if (title.startsWith("Untitled")) {
    title = await tp.system.prompt("Title");
    await tp.file.rename(title);
  }
  const lat = await tp.system.prompt("Latitude（例如 25.0330）");
  const lon = await tp.system.prompt("Longitude（例如 121.5654）"); 
    
  tR += "---"
%>
Location:
Visited: false
Last Visit: 
latitude: ${lat}
longitude: ${lon}
tags: Interest/Travel/Location
---
# <%* tR += title %>
# Short Review
Rating::
Summary:: 

# Long Review

# Related Trips
```dataview
TABLE WITHOUT ID file.inlinks AS Trips
FROM "Interest/Travel"
WHERE file.name = this.file.name
```