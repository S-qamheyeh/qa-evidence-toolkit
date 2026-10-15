# qa-evidence-toolkit

Evidence capture and indexing for manual QA work, plus the templates I use to keep a long engagement consistent.

Built during a four-month manual regression engagement where evidence volume became the bottleneck — not capturing it, but finding it again and knowing what it showed. The fix was to stop treating screenshots as the record and start treating the index as the record.

## Why

On a long engagement you accumulate hundreds of screenshots and video clips. Six weeks later nobody can tell you what `Screenshot 2026-08-05 184344.png` proved, and a folder reorganisation can orphan half of them.

The approach here:

1. **Name the file for what it shows**, not when it was taken.
2. **Write one index row per file** at capture time, including the result and a one-line note of what actually happened.
3. **Read the index, not the images.** Open a file only when a result is contested, when someone asks, or when it would close a work item.

In practice this cut evidence review cost by roughly 40x — one index line is a fraction of the cost of opening the equivalent screenshot, and it carries the finding.

## Contents

| File | Purpose |
|---|---|
| `Save-Evidence.ps1` | Prompts for test ID, category, description and note; renames and files the newest screenshot; appends a row to `EVIDENCE-INDEX.csv` |
| `templates/daily-qa-log.md` | One per testing day. Ends with the section a project owner actually reads: questions and decisions needed from them. |
| `templates/defect-report.md` | One per issue. Sections 1-7 paste into a tracker; 8-10 are working notes including what you ruled out. |
| `templates/workflow-guide.md` | Folder layout, daily rhythm, and the ten conventions that mattered most. |

## Naming convention

```
TC-XXX_CATEGORY_Kebab-Case-Description.png
```

Categories: `PASS` `FAIL` `BLOCKED` `SETUP` `OBSERVATION` `APPROVED-DIFF` `NOT-RUN` `FIXED` `REPRODUCES`

For areas with no test case number yet, substitute the module name for `TC-XXX`.

## Index format

```csv
Date,TestID,Category,Description,Result,Filename,Note
```

The `Note` column is the one that earns its place. "Reproduces" tells you nothing in six weeks; "balance owing in the letter does not match the financial summary" tells you everything.

## Usage

```powershell
# Capture with Win + Shift + S, cropped to the relevant region, then:
.\Save-Evidence.ps1
```

The script takes the newest image from your screenshots folder, prompts for the fields, renames it into the current evidence folder and appends the index row.

## Licence

MIT. Take it, change it, no attribution needed.
