---
limit: 20
mapWithTag: false
icon: home
tagNames:
  - Interest/Travel/Accomdation
filesPaths:
  - Interest/Travel/Accommodation
bookmarksGroups: 
excludes: 
extends: 
savedViews: []
favoriteView: 
fieldsOrder:
  - TXSxMu
  - lyNoqH
  - e7osrV
  - z9rEda
version: "2.18"
fields:
  - name: Last Visit
    type: Date
    options:
      dateShiftInterval: 1 day
      dateFormat: YYYY-MM-DD
      defaultInsertAsLink: false
      linkPath: ""
    path: ""
    id: z9rEda
  - name: Visited
    type: Boolean
    options: {}
    path: ""
    id: e7osrV
  - name: Accommodation Status
    type: Select
    options:
      sourceType: ValuesListNotePath
      valuesList: {}
      valuesListNotePath: Interest/90 Organize/Lookups/Travel/Lookup - Accomdation Status.md
    path: ""
    id: lyNoqH
  - name: Accommodation Type
    type: Select
    options:
      sourceType: ValuesListNotePath
      valuesList: {}
      valuesListNotePath: Interest/90 Organize/Lookups/Travel/Lookup - Accomdation Type.md
    path: ""
    id: TXSxMu
---
