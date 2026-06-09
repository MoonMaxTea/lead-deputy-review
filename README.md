# lead-deputy-review

> **Ship with a second pair of eyes.** An agent-agnostic Skill that pairs a **Lead** (whoever loads it) with a **Deputy** (a TTY CLI in your editor’s integrated terminal)—orchestrated through terminal-bridge MCP, structured plan review, and acceptance reports.

**中文说明** → [README.zh-CN.md](README.zh-CN.md)

### Repository description (GitHub About)

> Agent-agnostic Skill for **Lead + Deputy** dual review: Preflight terminal-bridge MCP, structured plan adoption, implementation handoffs, and acceptance reports—works with any dialogue agent and TTY CLI deputy.

---

## Why this exists

One agent can move fast; two roles catch what one misses. This Skill defines a repeatable **Lead + Deputy** workflow:

- **Preflight** — verify terminal-bridge MCP before any handoff  
- **Plan review** — Deputy critiques; Lead publishes adoption decisions; you confirm  
- **Flexible implementation** — you choose Lead or Deputy as the primary coder  
- **Acceptance** — static/HTTP checks in tables; UI steps flagged for manual testing  
- **No copy-paste** — when the bridge is configured, Lead dispatches tasks directly into Deputy’s terminal  
- **Enter to submit** — Lead always sends `\r` after handoff text so Deputy receives the task  
- **Activity watch** — Lead polls Deputy terminal at User-chosen intervals (default 1/5/10/30 min) while Deputy works  
- **Superpowers optional** — User chooses each session: overlay brainstorming / writing-plans / executing-plans / verification, or classic lead-deputy only  

Works across **any host** that supports Agent Skills and MCP terminal control—not tied to a single vendor.

## Roles

| Role | Who |
|------|-----|
| **Lead** | The agent session that **loads this Skill** (dialogue Agent with MCP) |
| **Deputy** | An **interactive CLI** running in the host’s integrated terminal |
| **You** | Confirm plans, pick who implements, run browser/UI checks, install the bridge |

The same host application can play **Lead** (dialogue + MCP) or **Deputy** (terminal CLI tab)—role follows **session shape**, not product name.

## Prerequisites

Install a **terminal bridge** (recommended: [Terminal Automatization](https://marketplace.visualstudio.com/items?itemName=davidrsch.terminal-automatization)). Alternatives: Arc Terminal Bridge, vscode-terminal-mcp, mcp-interactive-terminal.

→ Full setup: [setup-reference.md](setup-reference.md)

## Install

Clone into your host’s **personal skills directory** (see your agent documentation for the exact path):

```bash
git clone https://github.com/<your-account>/lead-deputy-review.git
# copy or symlink into your host personal skills folder as lead-deputy-review/
```

## Quick start

1. Install a terminal bridge; configure MCP (HTTP URL, e.g. `http://127.0.0.1:6070/mcp`).
2. Start your Deputy CLI in an integrated terminal (`start_command` of your choice).
3. In a new agent chat:

   ```text
   Use lead-deputy-review skill. Run Preflight, then review docs/plans/my-feature.md
   ```

4. Expect: Preflight report → **Superpowers on/off?** → questions (implementation lead + Deputy `start_command`) → phases A–C.

## Workflow

```
Preflight → Session init → Plan review (A) → Implement (B) → Accept (C) → Fix loop (D)
```

**Fixed rule:** Plan authoring stays with **Lead**, even when Deputy implements.

## Repository layout

```
lead-deputy-review/
├── README.md / README.zh-CN.md
├── SKILL.md                 # Agent instructions
├── setup-reference.md       # Bridge install & troubleshooting
├── superpowers-integration.md  # Optional Superpowers overlay
└── templates/
    ├── plan-skeleton.md
    ├── handoff-lead-to-deputy.md
    ├── handoff-deputy-to-lead.md
    └── acceptance-report.md
```

## Invocation

- Skill id: `lead-deputy-review`
- Mention it explicitly (`disable-model-invocation: true`) or use triggers: *dual-agent*, *deputy*, *Preflight*, *副手*

## License

MIT — see [LICENSE](LICENSE).
