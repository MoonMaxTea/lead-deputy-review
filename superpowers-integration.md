# Superpowers Integration (optional)

When `superpowers_mode: on`, Lead **layers** Superpowers process skills onto the Lead + Deputy workflow. Deputy handoffs, Enter submit, and activity watch **still apply**. When `superpowers_mode: off`, ignore this file entirely.

## Prerequisites

- Superpowers plugin installed in Cursor (`/plugin-add superpowers`)
- Lead can invoke Superpowers skills from the plugin (e.g. `brainstorming`, `writing-plans`)

## Phase mapping

| Lead-Deputy phase | Superpowers skill(s) | Who runs | Notes |
|-------------------|----------------------|----------|-------|
| A — Plan (draft) | `brainstorming` → `writing-plans` | Lead | Skip brainstorming if User already has an approved spec/plan path |
| A — Plan (review) | *(none)* | Deputy | Unchanged: Deputy critiques; Lead writes 接纳建议 |
| B — Implement (`lead`) | `executing-plans` or `subagent-driven-development`; per-task `test-driven-development` | Lead | Prefer `subagent-driven-development` when Task/subagents available |
| B — Implement (`deputy`) | `requesting-code-review` on Deputy's diff | Lead (review only) | Lead does not parallel-edit |
| C — Acceptance | `verification-before-completion` | Lead (if acceptor) or Lead triage | Deputy still fills acceptance-report when acceptor |
| D — Fix loop | `systematic-debugging` | Implementer | Root cause before fix; then re-accept |

## Phase A detail (superpowers on)

1. **brainstorming** (if greenfield or no approved spec):
   - Explore context, clarify with User, propose approaches, get design approval
   - Optional design doc: `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`
2. **writing-plans** — draft plan using [templates/plan-skeleton.md](templates/plan-skeleton.md)
   - Save to `docs/plans/<feature>.md` (lead-deputy canonical path; superpowers default `docs/superpowers/plans/` overridden here)
   - Include bite-sized tasks, file list, verification commands per writing-plans discipline
3. Continue standard Phase A: MCP Deputy plan review → Lead 接纳建议 → User confirms

## Phase B detail (superpowers on)

### `implementation_lead: lead`

1. Announce: using `executing-plans` (or `subagent-driven-development`)
2. TodoWrite from plan tasks; TDD per step when applicable
3. `finishing-a-development-branch` before handoff to Deputy acceptance

### `implementation_lead: deputy`

1. MCP Deputy implement handoff (unchanged)
2. Lead activity watch during Deputy work
3. When Deputy reports done: Lead invokes `requesting-code-review` (or read diff + checklist) before Phase C

## Phase C detail (superpowers on)

1. Acceptor runs checks (Deputy or Lead per `implementation_lead`)
2. **Before any "pass" claim**: Lead invokes `verification-before-completion` — run fresh commands, cite evidence
3. Merge Deputy acceptance report with verification evidence in User summary

## Phase D detail (superpowers on)

1. On failures/bugs: invoke `systematic-debugging` before proposing fixes
2. Implementer fixes → update handoff → optional `verification-before-completion` + re-acceptance

## What does NOT change (superpowers on)

- Preflight terminal-bridge checks
- Mandatory Enter (`\r`) after MCP handoffs
- Deputy activity watch intervals
- `plan_author: lead` fixed
- User confirms plan before Phase B
- Browser/UI items → 待人工

## Announce pattern

When superpowers on, Lead announces at phase start:

```text
[Lead-Deputy + Superpowers] Phase A — using writing-plans to draft plan
[Lead-Deputy + Superpowers] Phase B — using executing-plans (implementation_lead: lead)
[Lead-Deputy + Superpowers] Phase C — verification-before-completion before sign-off
```
