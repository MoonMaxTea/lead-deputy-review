---
name: lead-deputy-review
description: >-
  Orchestrates Lead Agent and terminal Deputy CLI dual review with Preflight
  terminal-bridge MCP checks. Use when the user wants dual-agent review,
  lead-deputy handoff, terminal MCP preflight, plan review with adoption
  recommendations, or TTY CLI acceptance by a secondary coding assistant.
disable-model-invocation: true
---

# Lead + Deputy Collaboration

Agent-agnostic workflow: **whoever loads this Skill is Lead**. Deputy is a **TTY CLI in the host's integrated terminal**. Plan authoring is always Lead. Implementation lead is chosen by User.

## Phase -1: Preflight (run first, every session)

Before plan work or MCP dispatch, Lead must self-check and report to User.

| Check | Pass | Fail action |
|-------|------|-------------|
| Terminal-bridge MCP | `list_terminals` + `send_text_to_terminal` (or equivalent) available and callable | See [setup-reference.md](setup-reference.md); install Terminal Automatization or equivalent |
| Host extension running | MCP tools return non-error; status bar shows bridge (if applicable) | Reload window; restart MCP server |
| Deputy terminal ready | Target session visible in `list_terminals`, or User will start `start_command` | Ask User to start Deputy CLI in integrated terminal |
| Lead runtime shape | Current session is **dialogue Agent**, not the terminal CLI being typed into | If only terminal CLI mode, ask User to load this Skill from app dialogue Agent as Lead |

Record: `terminal_bridge: ok | missing | degraded` + provider name.

**Equivalent bridges** (any that list terminals + send text to integrated terminals):

1. Terminal Automatization (preferred)
2. Arc Terminal Bridge
3. vscode-terminal-mcp
4. mcp-interactive-terminal (degraded)

If `missing` and User declines install: **manual mode** — paste handoff text to Deputy; label plan `terminal_bridge: manual`. Do not skip Preflight reporting.

Full install, dual-role (dialogue vs terminal CLI) notes, and fallbacks: [setup-reference.md](setup-reference.md).

## Phase 0: Session init (after Preflight pass or manual mode)

Ask User (use AskQuestion when available):

1. **Implementation lead**: `lead` (default) | `deputy`
2. **Deputy identity**: display name + `start_command` (User's chosen CLI entrypoint)

Write into plan roster and Project Config below. **`plan_author` is always `lead`** — does not change when implementation lead is deputy.

## Roles

| Role | Definition | Owns | Must not |
|------|------------|------|----------|
| Lead | Loader of this Skill; MCP-capable dialogue Agent | Plan draft; MCP dispatch; synthesis; default implementation | Edit same module as Deputy in parallel; dispatch without Preflight |
| Deputy | TTY CLI in integrated terminal | Plan review; static/HTTP checks; acceptance report; optional implementation | Edit plan body or large impl changes without User authorization |
| User | Human | UI acceptance; product calls; pick implementation lead; install bridge | — |

**Lead eligibility**: MCP terminal-bridge client + integrated terminals — not tied to a specific product. **App dialogue Agent** (with bridge) qualifies. **Terminal CLI session** in the integrated terminal is Deputy, not Lead.

## Project Config (copy per repo/session)

```yaml
lead:
  # implicit: current Agent loading this Skill
terminal_bridge:
  status: ok              # ok | missing | degraded | manual
  provider: terminal-automatization
  mcp_endpoint: "http://127.0.0.1:6070/mcp"
deputy:
  name: "{DEPUTY_NAME}"
  start_command: "{START_COMMAND}"
  requires_tty: true
implementation_lead: lead   # lead | deputy
plan_author: lead             # fixed
plans_dir: docs/plans
lead_handoff_fields:
  - version_or_build_id
  - changed_files
  - run_url
  - start_command
```

## Workflow phases

### Phase A — Plan review

1. Lead drafts plan from [templates/plan-skeleton.md](templates/plan-skeleton.md) or aligns existing `docs/plans/*.md`
2. MCP send **Plan review** variant from [templates/handoff-lead-to-deputy.md](templates/handoff-lead-to-deputy.md)
3. Deputy **reviews only** — no plan edits; returns table: `项 | 建议 | 严重程度`
4. Lead **second review**: fill plan section **审阅结论 / 接纳建议** — each Deputy item: **采纳 / 部分采纳 / 不采纳** + reason
5. **User confirms** plan → then Phase B

### Phase B — Implementation

| `implementation_lead` | Implementer | Other party |
|-----------------------|---------------|-------------|
| `lead` (default) | Lead edits code | Deputy standby or read-only checks |
| `deputy` | MCP **Deputy implement** handoff | Lead reviews diff only; no parallel edits |

Implementer completes handoff fields: `version_or_build_id`, `changed_files`, `run_url`, build/restart steps.

### Phase C — Acceptance

| `implementation_lead` | Acceptor | Output |
|-----------------------|----------|--------|
| `lead` | Deputy | [templates/acceptance-report.md](templates/acceptance-report.md) via MCP |
| `deputy` | Lead | Static review + fix list to Deputy terminal or plan |

Browser/UI items: always **待人工** with steps for User.

### Phase D — Fix loop

Acceptance findings → implementer fixes → update handoff → optional re-acceptance. Lead records rejected suggestions in plan with rationale.

## MCP protocol (Lead only)

1. Read MCP tool schema before `CallMcpTool`
2. `list_terminals` → match Deputy by name/`start_command` → `focus_terminal` → `send_text_to_terminal`
3. **TUI submit**: prefer `text` + `execute: false`, then separate `text: "\r"` + `execute: false` (not `execute: true` alone)
4. **Receive**: read host terminal snapshot files or User says "看副手回复"
5. **Never** start Deputy CLI in Agent non-TTY sub-shell (non-interactive pipe flags)

Details: [setup-reference.md](setup-reference.md).

## After Deputy report

1. Triage: Critical / fixable / 待人工 / suggestion
2. Fix Critical + automatable items (if Lead is implementer)
3. Report to User: version, fixed items, manual UI checklist, re-acceptance needed?

## Anti-patterns

- Both agents editing the same file
- Acceptance without written criteria in plan
- Announcing done without reading Deputy output
- `run_command` huge output instead of Deputy TUI session
- Treating Deputy as host sub-Agent with auto callback
- Skipping User choice of `implementation_lead`
- Lead secretly editing while `implementation_lead: deputy`
- Skipping Preflight then blaming "Deputy no response"

## Templates

- Plan skeleton: [templates/plan-skeleton.md](templates/plan-skeleton.md)
- Lead → Deputy handoffs: [templates/handoff-lead-to-deputy.md](templates/handoff-lead-to-deputy.md)
- Deputy → Lead format: [templates/handoff-deputy-to-lead.md](templates/handoff-deputy-to-lead.md)
- Acceptance report: [templates/acceptance-report.md](templates/acceptance-report.md)
