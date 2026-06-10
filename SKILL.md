---
name: superpowers-dual-agent-collab
description: >-
  Superpowers-enhanced dual-agent collaboration: Lead (dialogue Agent) orchestrates
  terminal Deputy (TTY CLI) via MCP handoff for plan co-review, implementation,
  and acceptance. Use when the user wants superpowers-dual-agent-collab,
  dual-agent collab, lead-deputy handoff, terminal MCP preflight, optional
  Superpowers overlay (brainstorming, writing-plans, executing-plans,
  verification), or classic Lead + Deputy flow without Superpowers.
disable-model-invocation: true
---

# Superpowers Dual-Agent Collab

Lead + Deputy collaboration workflow (Superpowers optional overlay).

Agent-agnostic workflow: **whoever loads this Skill is Lead**. Deputy is a **TTY CLI in the host's integrated terminal**. Plan authoring is always Lead. Implementation lead is chosen by User.

## Phase -1: Preflight (run first, every session)

Before plan work or MCP dispatch, Lead must self-check and report to User.

| Check | Pass | Fail action |
|-------|------|-------------|
| Terminal-bridge MCP | `list_terminals` + `send_text_to_terminal` (or equivalent) available and callable | See [setup-reference.md](setup-reference.md); install Terminal Automatization or equivalent |
| Port & scope aligned | mcp.json URL port = `terminalMcp.port` = status bar port; user-level mcp.json paired with user settings (not project-only) | Fix scope mismatch per [setup-reference.md](setup-reference.md); reload window |
| Host extension running | MCP tools return non-error; status bar shows bridge (if applicable) | Reload window; restart MCP server |
| Deputy terminal ready | Target session visible in `list_terminals`, or User will start `start_command` | Ask User to start Deputy CLI in integrated terminal |
| Lead runtime shape | Current session is **dialogue Agent**, not the terminal CLI being typed into | If only terminal CLI mode, ask User to load this Skill from app dialogue Agent as Lead |
| Deputy Superpowers bundle | When `superpowers_mode: on`: `.cursor/skills/superpowers/` exists with all 5 bundled SKILL.md files | Run [scripts/sync-deputy-superpowers-bundle.ps1](scripts/sync-deputy-superpowers-bundle.ps1); see [deputy-superpowers-bundle/MANIFEST.md](deputy-superpowers-bundle/MANIFEST.md) |

Record: `terminal_bridge: ok | missing | degraded` + provider name. When superpowers on, also record: `deputy_skills_bundle: ok | missing`.

**Equivalent bridges** (any that list terminals + send text to integrated terminals):

1. Terminal Automatization (preferred)
2. Arc Terminal Bridge
3. vscode-terminal-mcp
4. mcp-interactive-terminal (degraded)

If `missing` and User declines install: **manual mode** — paste handoff text to Deputy; label plan `terminal_bridge: manual`. Do not skip Preflight reporting.

Full install, dual-role (dialogue vs terminal CLI) notes, and fallbacks: [setup-reference.md](setup-reference.md).

## Phase 0: Session init (after Preflight pass or manual mode)

Ask User (use AskQuestion when available):

1. **Superpowers 协作** (ask **every session** when User invokes this skill): `on` | `off`
   - Explain briefly: `on` = Lead 用 Superpowers 插件技能；Deputy 读项目内 `.cursor/skills/superpowers/` 同名协议；handoff 为 Skill-first（先读 SKILL.md 再执行 plan）；`off` = 经典双 Agent 流程
   - If User already stated preference this message, still confirm unless they said "always on/off for this project"
   - If `on` and bundle missing: offer to run sync script before Phase B
2. **Implementation lead**: `lead` (default) | `deputy`
3. **Deputy identity**: display name + `start_command` (User's chosen CLI entrypoint)
4. **Deputy activity watch** (ask again during Phase A plan draft if not set): which check intervals to use while Deputy is working — default preset `1m, 5m, 10m, 30m`; User may pick a subset or custom intervals

Write into plan roster and Project Config below. **`plan_author` is always `lead`** — does not change when implementation lead is deputy.

**Branch rule:** `superpowers_mode: off` → follow sections below only. `superpowers_mode: on` → same phases, plus [superpowers-integration.md](superpowers-integration.md).

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
  mcp_endpoint: "http://127.0.0.1:6070/mcp"   # example; must match terminalMcp.port at same scope
deputy_skills:
  root: .cursor/skills/superpowers   # project bundle for Deputy (superpowers_mode: on)
  status: ok              # ok | missing
deputy:
  name: "{DEPUTY_NAME}"
  start_command: "{START_COMMAND}"
  requires_tty: true
implementation_lead: lead   # lead | deputy
plan_author: lead             # fixed
superpowers_mode: off           # on | off — User choice every session
deputy_watch:
  enabled: true
  intervals_minutes: [1, 5, 10, 30]   # User-confirmed; subset or custom OK
  on_stall: notify_user               # notify_user | reprompt_deputy | escalate
plans_dir: docs/plans
lead_handoff_fields:
  - version_or_build_id
  - changed_files
  - run_url
  - start_command
```

## Workflow phases

> **`superpowers_mode: off`** — phases A–D below as written.
> **`superpowers_mode: on`** — same phases; Lead additionally invokes Superpowers skills per [superpowers-integration.md](superpowers-integration.md). Deputy MCP handoffs, Enter submit, and activity watch unchanged.

### Phase A — Plan review

**Superpowers on (before step 1):** If no approved spec, Lead invokes `brainstorming` with User. Then invoke `writing-plans` discipline when drafting.

1. Lead drafts plan from [templates/plan-skeleton.md](templates/plan-skeleton.md) or aligns existing `docs/plans/*.md` — include **Deputy 监测配置** and **Superpowers 协作** (intervals from Phase 0 or ask User now)
2. MCP send **Plan review** variant from [templates/handoff-lead-to-deputy.md](templates/handoff-lead-to-deputy.md); **must press Enter to submit** (see MCP protocol)
3. Deputy **reviews only** — no plan edits; returns table: `项 | 建议 | 严重程度`
4. Lead **second review**: fill plan section **审阅结论 / 接纳建议** — each Deputy item: **采纳 / 部分采纳 / 不采纳** + reason
5. **User confirms** plan → then Phase B

### Phase B — Implementation

**Superpowers on:** `implementation_lead: lead` → Lead uses plugin `executing-plans`. `implementation_lead: deputy` → MCP **§2 Skill-first implement** handoff; Deputy reads bundle skills; Lead activity watch + `requesting-code-review` on diff before Phase C.

| `implementation_lead` | Implementer | Other party |
|-----------------------|---------------|-------------|
| `lead` (default) | Lead edits code | Deputy standby or read-only checks |
| `deputy` | MCP **Deputy implement** handoff (Skill-first when superpowers on) | Lead reviews diff only; no parallel edits |

Implementer completes handoff fields: `version_or_build_id`, `changed_files`, `run_url`, build/restart steps.

### Phase C — Acceptance

**Superpowers on:** Before any pass claim, acceptor runs `verification-before-completion` (Deputy reads bundle when acceptor; Lead uses plugin). Deputy acceptance report still required when Deputy is acceptor.

| `implementation_lead` | Acceptor | Output |
|-----------------------|----------|--------|
| `lead` | Deputy | Skill-first §3 acceptance handoff → bundle `verification-before-completion` → [templates/acceptance-report.md](templates/acceptance-report.md) |
| `deputy` | Lead | Static review + fix list to Deputy terminal or plan |

Browser/UI items: always **待人工** with steps for User.

### Phase D — Fix loop

**Superpowers on:** Implementer reads bundle/plugin `systematic-debugging` before fixes. Lead sends **§4 Skill-first fix** handoff when implementer is Deputy.

Acceptance findings → implementer fixes → update handoff → optional re-acceptance. Lead records rejected suggestions in plan with rationale.

## MCP protocol (Lead only)

1. Read MCP tool schema before `CallMcpTool`
2. `list_terminals` → match Deputy by name/`start_command` → `focus_terminal` → `send_text_to_terminal`
3. **Mandatory Enter after every handoff** — typing alone does not dispatch. After the full message:
   - Step A: `send_text_to_terminal { text: "<full message>", execute: false }`
   - Step B: `send_text_to_terminal { text: "\r", execute: false }` — **this is the Enter/submit step; never skip**
   - Do **not** rely on `execute: true` alone for interactive TUIs
   - Confirm in chat: "已向 Deputy 发送并回车提交"
4. **Receive**: read host terminal snapshot files or User says "看副手回复"
5. **Never** start Deputy CLI in Agent non-TTY sub-shell (non-interactive pipe flags)

Details: [setup-reference.md](setup-reference.md).

## Deputy activity watch (Lead only)

While Deputy is working (plan review, implementation, or acceptance), Lead **must stay on watch** — do not go idle or declare done until Deputy finishes or User stops the watch.

### When to start

Start the watch immediately after Enter-submitting a handoff to Deputy. Applies to Phase A, B (when `implementation_lead: deputy`), and C (when Deputy is acceptor).

### Intervals

Use `deputy_watch.intervals_minutes` from Project Config / plan. Default preset: **1, 5, 10, 30** minutes from handoff time.

| Elapsed since handoff | Lead action |
|-----------------------|-------------|
| Each configured interval | Read Deputy terminal snapshot (or `list_terminals` + terminal file); note last output line, spinner/prompt state, errors |
| Output changed since last check | Log one-line progress to User; reset stall counter |
| No change across 2 consecutive checks | Report stall to User; apply `on_stall` (default: notify User with last seen state) |
| Deputy reports complete | Stop watch; proceed to next phase |

### Watch log (brief, to User)

At each check, report only when meaningful:

```text
[Deputy watch +5m] 进行中 — 最后输出: "<snippet>" / 状态: running|idle|error|done
```

On completion: `[Deputy watch] 完成 — 进入 Lead 处理`.

### Manual mode

If `terminal_bridge: manual`, Lead cannot poll terminal files — ask User at each interval: "Deputy 终端有新输出吗？" or User pastes snapshot.

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
- Sending handoff text without **Enter/submit** (`\r` second step)
- Dispatching to Deputy then going idle without **activity watch**
- Skipping **Superpowers 协作** ask when User invokes superpowers-dual-agent-collab
- Enabling Superpowers (`on`) when User chose `off`, or skipping Deputy bundle / Skill-first handoffs when User chose `on`
- Replacing Deputy plan review with Superpowers code-review only (Deputy review stays in Phase A)
- Sending `@plan.md` alone to Deputy when `superpowers_mode: on` (must include SKILL.md read order)

## Templates

- Superpowers overlay: [superpowers-integration.md](superpowers-integration.md)
- Plan skeleton: [templates/plan-skeleton.md](templates/plan-skeleton.md)
- Lead → Deputy handoffs: [templates/handoff-lead-to-deputy.md](templates/handoff-lead-to-deputy.md)
- Deputy → Lead format: [templates/handoff-deputy-to-lead.md](templates/handoff-deputy-to-lead.md)
- Acceptance report: [templates/acceptance-report.md](templates/acceptance-report.md)
