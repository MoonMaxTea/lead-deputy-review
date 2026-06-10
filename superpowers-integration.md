# Superpowers Integration (optional)

When `superpowers_mode: on`, Lead and Deputy follow **the same Superpowers protocol** — not just shared vocabulary.

- **Lead** invokes skills from the Superpowers **plugin** (dialogue Agent).
- **Deputy** reads skills from the **project bundle** at `.cursor/skills/superpowers/` (TTY CLI).

Deputy handoffs must be **Skill-first** (read `SKILL.md` before plan). Enter submit and activity watch **still apply**. When `superpowers_mode: off`, ignore this file.

## Prerequisites

| Prerequisite | Who | Action |
|--------------|-----|--------|
| Superpowers plugin | Lead | `/plugin-add superpowers` in Cursor |
| Deputy skill bundle | Project | Run [scripts/sync-deputy-superpowers-bundle.ps1](scripts/sync-deputy-superpowers-bundle.ps1) or `.sh` → creates `.cursor/skills/superpowers/` |
| Plan with verification commands | Lead | Per `writing-plans` discipline in plan skeleton |
| Terminal bridge | Lead | See [setup-reference.md](setup-reference.md) |

Bundle manifest and role matrix: [deputy-superpowers-bundle/MANIFEST.md](deputy-superpowers-bundle/MANIFEST.md).

## Preflight (when `superpowers_mode: on`)

Lead adds to standard Preflight:

```
Deputy Superpowers Bundle:
- [ ] .cursor/skills/superpowers/MANIFEST.md exists
- [ ] All 5 skills present (executing-plans, test-driven-development, finishing-a-development-branch, verification-before-completion, systematic-debugging)
- [ ] Plan tasks include verification commands
```

If bundle missing: run sync script or ask User to bootstrap before Phase B.

## Phase × Role × Skill matrix

| Phase | `implementation_lead: lead` | `implementation_lead: deputy` |
|-------|----------------------------|------------------------------|
| **A — Plan draft** | Lead: `brainstorming` → `writing-plans` (plugin) | Same |
| **A — Plan review** | Deputy: **bundle** `executing-plans` Step 1 only (critical review, no implement) | Same |
| **B — Implement** | Lead: `executing-plans` or `subagent-driven-development` (plugin) + per-task `test-driven-development` | Deputy: **bundle** `executing-plans` → TDD → `finishing-a-development-branch` |
| **B — Post-impl review** | Deputy accepts next (Phase C) | Lead: `requesting-code-review` (plugin) on Deputy diff — **Lead only, not Deputy** |
| **C — Acceptance** | Deputy: **bundle** `verification-before-completion` + [acceptance-report](templates/acceptance-report.md) | Lead: `verification-before-completion` (plugin) triage + User summary |
| **D — Fix loop** | Implementer: `systematic-debugging` (bundle if Deputy, plugin if Lead) | Same |

### Lead-only plugin skills (never copy to Deputy bundle)

`brainstorming`, `writing-plans`, `subagent-driven-development`, `requesting-code-review`, `receiving-code-review`

### Deputy bundle skills (project-local)

`executing-plans`, `test-driven-development`, `finishing-a-development-branch`, `verification-before-completion`, `systematic-debugging`

## Skill-first MCP handoffs

Lead **must not** send plan path alone when `superpowers_mode: on`. Use templates in [templates/handoff-lead-to-deputy.md](templates/handoff-lead-to-deputy.md):

| Variant | When | Deputy reads |
|---------|------|--------------|
| §1 Skill-first plan review | Phase A | `executing-plans` Step 1 only → review table (no implement) |
| §2 Skill-first implement | `implementation_lead: deputy` | `executing-plans` full → plan → TDD → `finishing-a-development-branch` |
| §3 Skill-first acceptance | `implementation_lead: lead` | `verification-before-completion` → plan criteria → report template |
| §4 Skill-first fix | Phase D | `systematic-debugging` → fix → re-verify |

Placeholder `{SKILLS_ROOT}` defaults to `.cursor/skills/superpowers`.

## Phase A detail

1. **brainstorming** (if greenfield or no approved spec) — Lead only
2. **writing-plans** — Lead drafts [templates/plan-skeleton.md](templates/plan-skeleton.md) → `docs/plans/<feature>.md`
   - Include Superpowers 协作 table with bundle path
   - Bite-sized tasks + verification commands per task
3. MCP §1 Skill-first plan review to Deputy (`executing-plans` Step 1 only — critical review, **do not** use full `brainstorming` or `writing-plans` on Deputy side)
4. Deputy outputs review table → Lead 接纳建议 → User confirms

**Phase A Deputy must NOT:** run full `brainstorming` (Lead-only, requires User dialogue), run full `writing-plans` (Lead drafts plan), edit plan file, or proceed to Step 2 implementation.

## Phase B detail

### `implementation_lead: lead`

1. Lead announces: `executing-plans` (or `subagent-driven-development` if subagents available)
2. TodoWrite from plan; `test-driven-development` per code-changing task
3. `finishing-a-development-branch` before Deputy acceptance handoff
4. MCP §3 Skill-first acceptance to Deputy

### `implementation_lead: deputy`

1. MCP §2 Skill-first implement to Deputy
2. Lead **activity watch** during Deputy work (mandatory — Deputy has no subagents)
3. When Deputy reports `ready_for_acceptance: yes`:
   - Lead invokes **`requesting-code-review`** (plugin) on Deputy diff
   - Lead does **not** parallel-edit
4. Proceed to Phase C only after review pass or fix list dispatched

## Phase C detail

### Deputy as acceptor (`implementation_lead: lead`)

1. Deputy received §3 Skill-first acceptance handoff
2. Deputy runs `verification-before-completion` from bundle — **fresh commands, cite evidence**
3. Output per [handoff-deputy-to-lead.md](templates/handoff-deputy-to-lead.md) acceptance report
4. Lead triages; User handles 待人工 UI items

### Lead as acceptor (`implementation_lead: deputy`)

1. Lead runs `verification-before-completion` (plugin)
2. Lead merges evidence with Deputy's implementation handoff
3. Report to User with fix list if needed

**Before any "pass" claim** — verification skill is mandatory, not optional.

## Phase D detail

1. Implementer reads `systematic-debugging` (bundle or plugin by role)
2. Root cause before fix — no speculative patches
3. Fix → update handoff → optional re-acceptance with `verification-before-completion`

## Deputy TTY constraints

- No subagents in typical TTY setup → **always** `executing-plans` for Deputy, never `subagent-driven-development`
- Phase A: Deputy uses `executing-plans` **Step 1 only** — never full `brainstorming` or `writing-plans` (Lead-only)
- Deputy must **read SKILL.md** at handoff path — `@plan.md` alone is insufficient
- Deputy must **announce** skill name at start (per each SKILL.md)
- Blocker → stop and ask User/Lead; do not force through

## What does NOT change

- Preflight terminal-bridge + port scope checks
- Mandatory Enter (`\r`) after MCP handoffs
- Deputy activity watch intervals
- `plan_author: lead` fixed
- User confirms plan before Phase B
- Browser/UI → 待人工

## Announce pattern

```text
[Superpowers Dual-Agent Collab] Phase A — Lead: writing-plans; Deputy: executing-plans Step 1 review (bundle)
[Superpowers Dual-Agent Collab] Phase B — Deputy: executing-plans (bundle) + activity watch
[Superpowers Dual-Agent Collab] Phase B — Lead: requesting-code-review on Deputy diff
[Superpowers Dual-Agent Collab] Phase C — Deputy: verification-before-completion (bundle)
[Superpowers Dual-Agent Collab] Phase D — systematic-debugging
```
