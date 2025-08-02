---
limit: 20
mapWithTag: false
icon: plane
tagNames:
  - Interest/Travel/Trip
filesPaths: 
bookmarksGroups: 
excludes: 
extends: 
savedViews: []
favoriteView: 
fieldsOrder:
  - VVoEG5
  - FOSRtc
  - kztWft
  - gloYKM
  - Cwzl62
  - Ad1gGB
version: "2.1"
fields:
  - name: Depature
    type: Date
    options:
      dateShiftInterval: 1 day
      dateFormat: YYYY-MM-DD
      defaultInsertAsLink: false
      linkPath: ""
    path: ""
    id: FOSRtc
  - name: Return
    type: Date
    options:
      dateShiftInterval: 1 day
      dateFormat: YYYY-MM-DD
      defaultInsertAsLink: false
      linkPath: ""
    path: ""
    id: VVoEG5
  - name: Country
    type: Select
    options:
      sourceType: ValuesListNotePath
      valuesList: {}
      valuesListNotePath: Interest/90 Organize/Lookups/Travel/Lookup - Countries.md
    path: ""
    id: Ad1gGB
  - name: Travel Type
    type: Select
    options:
      sourceType: ValuesListNotePath
      valuesList: {}
      valuesListNotePath: Interest/90 Organize/Lookups/Travel/Lookup - Travel Type.md
    path: ""
    id: gloYKM
  - name: Travel Status
    type: Select
    options:
      sourceType: ValuesListNotePath
      valuesList: {}
      valuesListNotePath: Interest/90 Organize/Lookups/Travel/Lookup - Travel Status.md
    path: ""
    id: kztWft
  - name: Review Status
    type: Select
    options:
      sourceType: ValuesListNotePath
      valuesList: {}
      valuesListNotePath: Interest/90 Organize/Lookups/Travel/Lookup - Review Status.md
    path: ""
    id: Cwzl62
---
