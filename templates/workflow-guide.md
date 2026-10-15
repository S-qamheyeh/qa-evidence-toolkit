# QA Working System — how to run a project

Distilled from the the system under test engagement, May–August 2026. Everything here was learned by getting it wrong at least once.

---

## The folder layout

```
[Project]/
├── PROJECT-RULES.md              ← conventions agreed with this client. Update as they emerge.
├── MASTER-RECORD.md              ← every defect, every ID, every status change. One file.
├── Daily-Logs/
│   └── QA-Log_YYYY-MM-DD.md      ← one per testing day. Send at end of day.
├── Defects/
│   └── DEF_YYYY-MM-DD_title.md   ← one per issue. Azure-ready.
├── Evidence/
│   └── Evidence-YYYY-MM-DD/
│       ├── EVIDENCE-INDEX.csv    ← one row per file. Read this, not the images.
│       └── *.png / *.mp4
└── Handover/
    └── Session_Handoff_YYYY-MM-DD.md
```

**One master record, not many.** The single most expensive habit on the system under test was information living in ten workbooks with colliding ID numbers. 45–52 test-case IDs were reused across independently numbered files. **Always pair an ID with its module and source file — never cite one bare.**

---

## The daily rhythm

**Start (10 min).** Ask: *was anything deployed since yesterday?* Fixes ship without a fix log — four defects on the system under test were found already resolved only because someone re-checked. Re-verify anything you plan to report today.

**During.** Log findings as you hit them, into today's log file. Don't rely on memory or on chat history — conversational summaries are not evidence.

**End (20 min).** Fill in the daily log. Write the **Summary** last. Send it.

**Batch your questions.** One message with three numbered questions beats three messages. Same for evidence requests.

---

## The rules that mattered most

### 1. Name the authoritative source before reconciling anything
Four screens showed four different trust balances. The question was unanswerable until the Trust Ledger was verified line by line and declared the record of truth. **Establish the oracle first, then compare everything to it.** Without that step you have a list of numbers that disagree, which is not a defect report.

### 2. Run a clean-baseline experiment before filing
When a system carries months of test data, every finding has an easy rebuttal: *"that's your test data."* Create a fresh record, walk the process through step by step, read every view at each checkpoint. **Two hours removed that rebuttal entirely** and turned an argument into a controlled experiment.

### 3. Attach a falsifying test to every hypothesis
Three hypotheses were proposed in one afternoon and all three were wrong. Each was withdrawn cleanly only because the disproving test was named up front. **Pattern-matching against a list of small numbers will always find a match — that is not evidence.** When you can't explain something, write "cause not identified." That is a complete and professional answer.

### 4. A write only counts if it survives reload
An editable field proves nothing; the server may still reject the save. The standard is: **change it → save → F5 → re-select the record from scratch → confirm it's still there.**

### 5. Verify identity by behaviour, never by display name
Two users legitimately shared a display name. Screenshots could not establish which account was active. A behavioural check settled it in one step. **Set up that check at the start of any multi-account session and re-run it before trusting any result.** Browsers silently reuse sessions — "open the invite link" is not "switch user." Log out fully first.

### 6. Index evidence first; open images only on request
One CSV line ≈ 15 tokens. The equivalent screenshot ≈ 2,700. **Evidence exists for the audit trail, not for browsing.** Open an image only when the result is contested, when it would close a work item, or when someone asks. If you need one, crop it. For video, note the timestamp rather than sampling frames.

### 7. Latest finding supersedes older on conflict — but say so
Two conditions: **(a)** state explicitly that an older finding is being superseded and why — never overwrite silently; **(b)** if the newer evidence is on a *different record*, flag the gap and don't close the item. Recommend a same-record retest first.

### 8. Search the master files before designing anything new
A 16-case suite was written from scratch for something a master file already covered with seven official cases — and it used invented IDs that matched nobody's records. **Grep every `.xlsx` for the ID first. It costs one tool call and it has been right every time.**

### 9. Never infer a status you didn't directly observe
Even when everything else in the batch was confirmed. Log it as unconfirmed.

### 10. Push back once, then execute
Disagreement is valuable; repeating it is not. State the objection **once**, clearly, with a falsifiable test attached. Then act on the decision without re-arguing. New evidence justifies a new position; restating an old one does not.

---

## Working with no specification

Common on rebuilds. Split findings in two:

- **Defect** — crashes, errors, broken flows, silent failures. These need no spec.
- **Needs-Decision** — "role X can do Y", "field shows A not B". No pass/fail. Push the decision to Product.

**Two exceptions you can call Fail with no spec**, because they are universal expectations rather than product choices:
1. **Privilege escalation** — the UI hides an action but the server still accepts it
2. **Cross-tenant data leakage**

**Then produce the observed behaviour matrix and ask them to ratify it as the baseline.** That is faster than waiting for a spec, and it makes you the author of the requirement.

---

## Reporting to a project owner

**Lead with what works.** A report that lists only failures gets discounted as negativity. The clean-client test found nine defects and six correct behaviours — putting the working list first is what made the failures credible.

**Be accurate about impact, not dramatic.** *"No money is missing; the ledger is accurate. The risk is a staff member acting on a wrong number on screen."* That framing survives being forwarded to the developer. Overstating does not.

**Separate what you know from what you suspect.** Two headings, always.

**Ask for decisions, not opinions.** *"Should Total Disbursements on a ticket show only that ticket's disbursements?"* gets an answer. *"The financial module seems inconsistent"* does not.

**Get the scope of sign-off answered in writing.** "QA sign-off" on the tested modules and on the whole system are very different commitments. Do not let that stay ambiguous.

---

## Before you file anything

- [ ] Re-verified on today's build — status treated as hypothesis, not fact
- [ ] Reproduced on a clean record where the data history could be blamed
- [ ] Official repro steps searched for in the master files
- [ ] The ID is paired with its module and source file
- [ ] Evidence proves the before-state as well as the after
- [ ] Nothing speculative left in the text — guesses removed, not softened
- [ ] Impact stated accurately
- [ ] Developer is not mid-deployment on this area
