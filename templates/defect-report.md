# Defect — [short title]

One file per issue: `DEF_YYYY-MM-DD_short-title.md`. Sections 1-7 paste into a tracker; 8-10 are working notes.

**Type:** Bug · **State:** New · **Severity:** 1 Critical / 2 High / 3 Medium / 4 Low
**Tags:** · **Linked test case:** (ID plus the file it came from — IDs collide across workbooks)

## 1. Repro steps
Numbered, from a clean start, with the exact values used.

## 2. Actual
What happened. Quote error text exactly.

## 3. Expected
What should happen, and why you believe that — prior behaviour, spec, or a universal expectation.

## 4. Environment
Build / URL · date · role · record identifiers.

## 5. Evidence
| File | Shows |
|---|---|

## 6. Frequency
Every time / intermittent, n of m / once.

## 7. Impact
Who is affected and what they would do wrong as a result. Accurate, not dramatic.

## 8. Ruled out
The section that earns trust.
- [ ] Not test-data contamination — reproduced on a clean record
- [ ] Not a refresh issue — persists after reload and reopening
- [ ] Not permissions — reproduced as [role]
- [ ] Not already fixed — re-verified on today's build

## 9. Unexplained
Say "cause not identified" rather than offering a guess. A wrong mechanism in a bug report is worse than none.

## 10. Source check
- [ ] Searched existing files for this ID before writing steps from inference
- [ ] Official steps found in: [file] / none exists
