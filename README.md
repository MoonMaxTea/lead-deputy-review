# superpowers-dual-agent-collab

> **Ship with a second pair of eyes — Superpowers optional.** An agent-agnostic Skill for **dual-agent collaboration**: **Lead** (dialogue Agent) + **Deputy** (TTY CLI in the integrated terminal), orchestrated through terminal-bridge MCP, structured plan review, and acceptance reports.

**中文说明** → [README.zh-CN.md](README.zh-CN.md)

### Repository description (GitHub About)

> Superpowers-enhanced dual-agent collab: Lead + Deputy via MCP terminal bridge. Preflight, optional Superpowers overlay, plan adoption, acceptance templates.

---

## Why this exists

One agent can move fast; two roles catch what one misses. This Skill defines a repeatable **Lead + Deputy** collaboration workflow:

- **Preflight** — verify terminal-bridge MCP before any handoff  
- **Superpowers optional** — User chooses each session: overlay brainstorming / writing-plans / executing-plans / verification, or classic dual-agent flow only  
- **Deputy skill bundle** — when Superpowers is on, sync project-local skills so Deputy (TTY CLI) follows the same protocol as Lead  
- **Skill-first handoffs** — Lead sends MCP instructions that require reading `SKILL.md` before the plan, not plan path alone  
- **Plan review** — Deputy critiques; Lead publishes adoption decisions; you confirm  
- **Flexible implementation** — you choose Lead or Deputy as the primary coder  
- **Acceptance** — static/HTTP checks in tables; UI steps flagged for manual testing  
- **No copy-paste** — when the bridge is configured, Lead dispatches tasks directly into Deputy’s terminal  
- **Enter to submit** — Lead always sends `\r` after handoff text so Deputy receives the task  
- **Activity watch** — Lead polls Deputy terminal at User-chosen intervals (default 1/5/10/30 min) while Deputy works  

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

Optional: [Superpowers](https://github.com/obra/superpowers) plugin in Cursor (`/plugin-add superpowers`).

When Superpowers is **on**, bootstrap the Deputy bundle in each project:

```powershell
.\scripts\sync-deputy-superpowers-bundle.ps1 -ProjectRoot .
```

→ Full matrix: [deputy-superpowers-bundle/MANIFEST.md](deputy-superpowers-bundle/MANIFEST.md)

→ Full setup: [setup-reference.md](setup-reference.md)

## Install

Clone into your host’s **personal skills directory** (see your agent documentation for the exact path):

```bash
git clone https://github.com/MoonMaxTea/superpowers-dual-agent-collab.git
# copy or symlink into your host personal skills folder as superpowers-dual-agent-collab/
```

## Quick start

1. Install a terminal bridge; configure MCP **and** matching `terminalMcp.port` at the **same scope** (user or project). Example fixed port: `http://127.0.0.1:6070/mcp` + `"terminalMcp.port": 6070` — then reload window. See [setup-reference.md](setup-reference.md).
2. If Superpowers **on**: run `scripts/sync-deputy-superpowers-bundle.ps1` in your project repo.
3. Start your Deputy CLI in an integrated terminal (`start_command` of your choice).
4. In a new agent chat:

   ```text
   Use superpowers-dual-agent-collab skill. Run Preflight, then review docs/plans/my-feature.md
   ```

5. Expect: Preflight report → **Superpowers on/off?** → questions (implementation lead + Deputy `start_command`) → phases A–C.

## Workflow

```
Preflight → Session init → Plan review (A) → Implement (B) → Accept (C) → Fix loop (D)
```

**Fixed rule:** Plan authoring stays with **Lead**, even when Deputy implements.

## Repository layout

```
superpowers-dual-agent-collab/
├── README.md / README.zh-CN.md
├── SKILL.md                 # Agent instructions
├── setup-reference.md       # Bridge install & troubleshooting
├── superpowers-integration.md  # Superpowers overlay + Deputy bundle
├── deputy-superpowers-bundle/
│   └── MANIFEST.md          # Bundle spec & phase×role matrix
├── scripts/
│   ├── sync-deputy-superpowers-bundle.ps1
│   └── sync-deputy-superpowers-bundle.sh
└── templates/
    ├── plan-skeleton.md
    ├── handoff-lead-to-deputy.md
    ├── handoff-deputy-to-lead.md
    └── acceptance-report.md
```

## Invocation

- Skill id: `superpowers-dual-agent-collab`
- Mention it explicitly (`disable-model-invocation: true`) or use triggers: *superpowers-dual-agent*, *dual-agent-collab*, *deputy*, *Preflight*, *副手*

## License

MIT — see [LICENSE](LICENSE).
