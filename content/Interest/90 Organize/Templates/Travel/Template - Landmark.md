<%*
  let title = tp.file.title
  if (title.startsWith("Untitled")) {
    title = await tp.system.prompt("Title");
    await tp.file.rename(title);
  } 
    
  tR += "---"
%>
Location:
Visited: false
Last Visit: 
tags: Interest/Travel/Location, Landmark
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