---
name: code-review-doc
description: Run the code-review skill, have fresh subagents risk-analyze each finding before it's trusted (including a likelihood-of-occurring-in-production and impact rating), and write the surviving findings to a markdown file at the repo root with the changed line, a comment body, a risk rating, and a suggested solution. Use when the user asks to code-review with a written report, invokes /code-review-doc, or says to write up code-review findings as markdown.
user-invocable: true
---

# code-review-doc

Wraps the `code-review` skill so every run produces a durable markdown
report, instead of only a chat summary - and so every finding in that
report has survived a skeptical, evidence-based risk-analysis pass before
it's written down, not just whatever the review's first draft claimed.

## Steps

1. Parse arguments the same way `code-review` does (effort level, optional
   PR/branch/path target). Do not pass through `--comment` or `--fix` even
   if given; strip them and tell the user this wrapper only writes the
   doc, then suggest running plain `/code-review --fix` or `--comment`
   themselves afterward if they want those.
2. Invoke the `code-review` skill with the parsed level/target.
3. Once findings come back, verify each finding's file and line number
   against the actual diff (`git diff <base>...<head>` for the same range
   the review used) before anything else. A finding's line must be one
   the diff added or changed on the new side of the file. If a reported
   line doesn't match, re-anchor it to the nearest correct line in the
   same hunk and note the correction - don't drop the finding over this
   alone.
4. Determine the base/head range used for the review (same resolution
   `code-review` itself used: diff against the PR/branch/path target, or
   `origin/main...HEAD` otherwise).
5. **Risk-analyze every finding with fresh subagents, following the
   pattern in `~/.config/ORCHESTRATION.md`.** This is not optional for any
   finding, including small style/naming ones - a finding that doesn't
   survive five minutes of someone actually reading the code shouldn't go
   in the report regardless of its size. See "Risk-analysis pass" below.
6. Integrate the verdicts (see "Integrating verdicts" below).
7. Write the report to `CODE_REVIEW_<slug>.md` at the repo root, where
   `<slug>` is the current branch's ticket key if one is recognizable
   (e.g. `ESS-2070`), else the branch name with `/` replaced by `-`.
   Overwrite if the file already exists from a prior run on this branch.
8. Do not commit the file. Mention its path in the chat reply along with
   a short summary - findings kept, findings revised, findings withdrawn
   - the same way you would after a plain `/code-review`.

## Risk-analysis pass

For each finding `code-review` produced, spawn one fresh subagent (no
shared context, no awareness of the other findings' subagents) to verify
it the way a skeptical senior engineer would - not to re-describe the bug,
but to check whether it actually holds up.

**Model tier:** one tier below your own, per ORCHESTRATION.md ("the
implementation should be passed to one of the lower tier models"). If you
are Opus, spawn Sonnet subagents; if Sonnet, spawn Haiku; if already
Haiku, stay at Haiku. All per-finding subagents and the adversarial
reviewer in the next section use this same tier.

**Dispatch all of them in parallel in a single batch** (one `Agent` call
per finding, all in the same turn) - they're independent of each other.

Each subagent's prompt must include:
- The repo path, and that this is read-only investigation - no file edits.
- The finding's current text verbatim: file, line, comment, suggested
  solution.
- The specific files to read to verify it (you know these from having
  just produced the finding).
- The checks to run, stated explicitly:
  1. Verify every concrete factual claim (file:line references, described
     behavior, config defaults, "always"/"every"/magnitude claims) against
     the actual source - read it, don't take the finding's word for it.
  2. Check whether the claimed trigger is really as narrow or hidden as
     described, or whether the same precondition is exercised by a
     hotter, more-frequently-run path (a success path, a sync path, a
     different caller) that would already surface the same problem
     earlier and louder - which would mean the finding's scenario isn't
     actually what makes this risky, even if the underlying code smell is
     real.
  3. Check whether frequency/timing/magnitude claims are calibrated or
     overstated.
  4. Check whether the suggested solution addresses the root cause as
     verified, not just the originally-stated (possibly wrong) one.
- The required output shape:
  ```
  VERDICT: CONFIRMED | REVISE | WITHDRAWN

  RATIONALE: (2-6 sentences, with file:line evidence for every claim checked)

  (if REVISE or WITHDRAWN: exact replacement markdown for the Comment
  section, and Suggested solution if that also needs to change, in the
  same style as the original)

  LIKELIHOOD: Routine | Operational | Narrow | External-dependent
  LIKELIHOOD NOTE: (1-3 sentences - see "Risk classification" below)

  IMPACT: Critical | High | Medium | Low
  IMPACT NOTE: (1-2 sentences on what actually happens if it fires, and for whom)
  ```

## Risk classification

Every finding gets a likelihood and an impact rating, each judged
separately - a finding can be low-likelihood and high-impact (worth
keeping visible) or high-likelihood and low-impact (worth keeping low in
the list, not dropping). Don't collapse them into one "severity" label;
report both so a reader can weigh them for their own context.

**Likelihood** is about reachability, not plausibility-sounding prose:
- `Routine`: fires on the normal/hot path whenever its precondition holds
  - no failure or rare condition needed (e.g. a code path every async
  request takes).
- `Operational`: needs a real but ordinary operational condition (an
  outage, a transient DB/broker failure, a race) that recurs in
  production over time, without needing anything exotic.
- `Narrow`: needs a specific combination of conditions that's fully
  explainable by this codebase's own logic (a particular exception
  sequence, a boundary alignment) but isn't the common case.
- `External-dependent`: reachability depends on something this repo
  doesn't control or can't observe from its own source - an external
  producer writing to an internal topic, a downstream consumer's
  behavior, a vendor's actual message wording, an ops/seed-data decision,
  deployment config not in this repo. Say so plainly in the note, and
  name what would have to be true outside this codebase for it to fire -
  don't assert a likelihood you can't actually back from what's in front
  of you. This is not a lesser finding because of it; it's an honestly
  bounded one.

A big part of what earlier passes get wrong is treating "the code permits
this" as "this happens in production" - trace whether the precondition is
the normal case, a recurring operational one, a narrow in-repo
coincidence, or a condition this repo can't settle on its own.

**Impact** is what happens if it fires, independent of how often that is:
- `Critical`: an irreversible customer-facing consequence (a real-world
  duplicate communication sent), or a security/PII exposure.
- `High`: a service availability or resource-exhaustion problem, or a
  published/external data-integrity break that other systems consume.
- `Medium`: an internal state inconsistency, a misleading operational
  signal, or a contract violation with no direct customer or security
  consequence.
- `Low`: cosmetic or maintainability-only - no runtime consequence.

Some findings aren't independent bugs (an architectural recommendation
that's really about findings elsewhere, a pure duplication/reuse note) -
for these, say `N/A` for both fields and name which findings carry the
actual risk instead of forcing an artificial rating.

After every per-finding subagent reports back, spawn at least one
adversarial review subagent (same tier, fresh context) given all the
findings and all the verdicts. Its job: check that each verdict is
actually earned - flag any CONFIRMED that looks rubber-stamped (no real
file:line evidence, or evidence that doesn't actually support the claim),
and any REVISE/WITHDRAWN that itself doesn't hold up. It should also check
the LIKELIHOOD rating specifically: flag any `Routine` or `Operational`
call that's actually gated on something the finding's own evidence doesn't
support reaching, and any `External-dependent` call that's actually
reachable from something in this repo after all. It should prioritize the
same qualifiers as any other adversarial review here: correctness of the
verification, not just plausibility of the prose. If it flags an analysis
as inadequate, redo that one finding's subagent with a fresh context
addressing the specific gap, then re-check only that fix.

Trust but verify applies to the subagents' own conclusions too, including
reversals: if a later pass (the adversarial reviewer, or your own reading)
contradicts an earlier one, don't take either side's word for it - trace
the disputed call path yourself against the actual source before
integrating. Verdicts on the same finding have flipped more than once in
practice; that's fine, it means the process is doing its job, but it means
the orchestrator needs to personally settle anything that's been
contradicted before writing it down, not just take the most recent answer.

You (the orchestrator) do the integration yourself in the next step -
subagents report back, they don't edit the report file.

## Integrating verdicts

- **CONFIRMED:** keep the finding as originally written, applying any
  minor wording fixes the subagent noted.
- **REVISE:** replace the Comment (and Suggested solution, if flagged)
  with the subagent's replacement text.
- **WITHDRAWN:** drop the finding from the numbered list. Don't let it
  disappear silently - list it in a short "Findings withdrawn during risk
  review" section at the end of the report, one line each: the original
  title and a one-sentence reason, so a reader can see what was
  considered and ruled out rather than wonder if it was simply missed.

Order (and reorder, including findings that were CONFIRMED unchanged) by
the LIKELIHOOD/IMPACT pair that came out of the risk-analysis pass, not by
the original review's severity guess - that guess is exactly what the risk
pass exists to correct. There's no single formula; weigh both axes
together (a `Narrow`-likelihood/`Critical`-impact finding like a
customer-facing duplicate send typically outranks a `Routine`/`Low` one,
and an `External-dependent` finding with no in-repo reachability path
usually drops toward the bottom regardless of how severe it would be if it
did fire). State the reasoning isn't mechanical; use judgment, but anchor
it to the two ratings, not to how alarming the original prose sounded.

Renumber the surviving findings sequentially in this new order after
withdrawals.

## Report format

```markdown
# Code review: <ticket-or-branch>

Diff reviewed: `<base>...<head>` on `<branch>`.
Every line number below is a line added or changed in that diff, on the
new side of the file. Paths are relative to the repo root unless noted.

Findings are ordered by likelihood and impact, highest risk first - not by
how the original review ranked them. Each one passed a risk-analysis pass
by a fresh subagent before being included here (see the skill for the
method); findings that didn't survive it are listed at the end instead.
No code or tests were run for this review.

---

## <n>. <short title>

**File:** `<path>`
**Line:** <line>

**Comment:**

<the finding's summary and failure scenario, in prose, with enough
concrete detail (classes, methods, line refs) that someone reading only
this file - not the original review - can verify it>

**Risk:** Likelihood: <Routine|Operational|Narrow|External-dependent> -
<one-line reachability note, explicit about anything outside this repo
the assessment depends on> · Impact: <Critical|High|Medium|Low> - <one
line on what actually happens, and for whom>

**Suggested solution:**

<a concrete fix direction, not just "fix this">

---
```

Repeat the `## <n>.` block per surviving finding in risk order, separated
by `---`. Keep the same level of concrete detail the underlying
code-review findings had - don't compress scenarios into vague one-liners.
End with:

```markdown
## Findings withdrawn during risk review

- **<original title>:** <one-sentence reason it didn't hold up>
```

Omit this last section entirely if nothing was withdrawn.
