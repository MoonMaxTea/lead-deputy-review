# Terminal Bridge Setup Reference

Lead + Deputy collaboration requires a **terminal bridge**: MCP tools that list integrated terminals and send text into them. This document covers Preflight, installation, equivalents, and troubleshooting.

## Preflight checklist (Lead runs every session)

```
Terminal Bridge Preflight:
- [ ] MCP client has terminal-bridge tools (list + send)
- [ ] Test call: list_terminals succeeds
- [ ] Provider extension running (or degraded PTY MCP noted)
- [ ] Port aligned: mcp.json URL port = terminalMcp.port = status bar port
- [ ] Config scope aligned: user-level mcp.json ↔ user settings; project mcp.json ↔ .vscode/settings.json
- [ ] Deputy terminal visible OR User will start start_command
- [ ] Lead is dialogue Agent (not the terminal CLI session under test)
```

Report to User:

```text
terminal_bridge: ok | missing | degraded | manual
deputy_skills_bundle: ok | missing | n/a
provider: <name>
deputy_terminal: <name or pending>
```

## Deputy Superpowers bundle (`superpowers_mode: on`)

Deputy (TTY CLI) cannot use the Superpowers plugin. Copy a **project-local skill bundle** so Lead and Deputy follow the same protocol.

### Bootstrap (once per repo)

From skill repo scripts, run against your project root:

```powershell
# Windows — adjust path to cloned skill repo
.\scripts\sync-deputy-superpowers-bundle.ps1 -ProjectRoot C:\path\to\your-repo
```

```bash
./scripts/sync-deputy-superpowers-bundle.sh /path/to/your-repo
```

Creates `.cursor/skills/superpowers/` with 5 skills + MANIFEST.md.

### Bundled skills

| Skill | Purpose |
|-------|---------|
| executing-plans | Deputy implements plan step-by-step |
| test-driven-development | Per-task code changes |
| finishing-a-development-branch | Required wrap-up after executing-plans |
| verification-before-completion | Deputy acceptance with fresh evidence |
| systematic-debugging | Fix loop root-cause analysis |

Full matrix: [deputy-superpowers-bundle/MANIFEST.md](deputy-superpowers-bundle/MANIFEST.md).

### Preflight add-on (superpowers on)

```
Deputy Superpowers Bundle Preflight:
- [ ] .cursor/skills/superpowers/MANIFEST.md exists
- [ ] All 5 skill folders contain SKILL.md
- [ ] Plan includes per-task verification commands
- [ ] Lead will use Skill-first handoff (not @plan.md alone)
```

Re-run sync script when Superpowers plugin updates.

## Equivalent providers

| Priority | Provider | Extension / package | Lead MCP config |
|----------|----------|---------------------|-----------------|
| 1 | Terminal Automatization | `davidrsch.terminal-automatization` | HTTP URL in host MCP config |
| 2 | Arc Terminal Bridge | `mercurial.arc-terminal` | Extension HTTP + stdio bridge on CLI side |
| 3 | vscode-terminal-mcp | Extension + `npx vscode-terminal-mcp` | stdio in mcp.json |
| 4 (degraded) | mcp-interactive-terminal | `npx mcp-interactive-terminal` | stdio; no editor extension; TUI behavior may differ |

**Minimum capability**: list terminals + send text to a chosen integrated terminal.

## Terminal Automatization (preferred)

### Install

1. Install extension: [Terminal Automatization MCP](https://marketplace.visualstudio.com/items?itemName=davidrsch.terminal-automatization)
2. Reload window (`Developer: Reload Window`)
3. Confirm status bar shows Terminal MCP / port
4. Connect in host MCP settings (connected / green)

### Configure MCP (HTTP)

**6070 is an example fixed port**, not magic — any free port works if both sides match.

#### Option A — Fixed port (recommended for global setup)

Configure **both** MCP client URL and extension port at the **same scope**:

| Scope | MCP config file | Editor settings file |
|-------|-----------------|----------------------|
| User (all projects) | `~/.cursor/mcp.json` (Cursor) | User Settings (`settings.json`) |
| Project | `.vscode/mcp.json` | `.vscode/settings.json` |

**User-level example (Cursor):**

`~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "terminal-automatization": {
      "url": "http://127.0.0.1:6070/mcp"
    }
  }
}
```

User Settings (same scope — **required when using a fixed port in mcp.json**):

```json
{
  "terminalMcp.port": 6070,
  "terminalMcp.enableHttpServer": true,
  "terminal.integrated.shellIntegration.enabled": true
}
```

**Project-level example:**

`.vscode/mcp.json` and `.vscode/settings.json` with the same port values.

After editing settings, **reload the window** (`Developer: Reload Window`) — the extension reads the port only at startup.

#### Option B — Auto port (`terminalMcp.port: 0`)

Let the OS assign a port; read the status bar (`MCP :<port>`), then sync that port into your mcp.json URL. Re-sync whenever the port changes.

#### Common misconfiguration

- User-level `~/.cursor/mcp.json` points to `6070`, but `terminalMcp.port` is set only in one project's `.vscode/settings.json` → other projects get `ECONNREFUSED 127.0.0.1:6070`.
- Fix: move `terminalMcp.port` to user settings, or use project-scoped mcp.json in each repo.

### Common tools

| Tool | Use |
|------|-----|
| `list_terminals` | Find Deputy session |
| `focus_terminal` | Focus before send |
| `send_text_to_terminal` | Dispatch task text |
| `run_command` | Shell commands with capture (not for Deputy TUI chat) |

## MCP dispatch protocol

### Order

1. Read tool schema from MCP descriptors
2. `list_terminals` — match Deputy by terminal title or known `start_command` shell
3. `focus_terminal` — target index or name
4. `send_text_to_terminal` — handoff body (`execute: false`)
5. **Mandatory Enter** — separate `send_text_to_terminal { text: "\r", execute: false }` to submit; **never skip step 5**

### Two-step Enter (interactive TUIs) — required

Typing the message alone does **not** send it to Deputy. Lead must always complete both steps:

```
Step 1: send_text_to_terminal { text: "<full message>", execute: false }
Step 2: send_text_to_terminal { text: "\r", execute: false }   ← Enter/submit; REQUIRED
```

`execute: true` alone often fails on interactive TUIs — do not use it as a substitute for Step 2.

After Step 2, Lead confirms to User: "已向 Deputy 发送并回车提交".

### Receiving Deputy output

- Read host terminal snapshot files (if your environment exposes them)
- Or ask User: "看副手回复" / paste output
- No automatic push subscription — Lead must poll or User relay

### Deputy activity watch (while Deputy works)

After Enter-submitting a handoff, Lead polls Deputy terminal at User-configured intervals (default: 1, 5, 10, 30 minutes). At each check: read terminal snapshot, compare to last state, report progress or stall to User. Stop when Deputy completes. See SKILL.md § Deputy activity watch.

### Forbidden

- Deputy CLI via Agent **non-TTY** sub-shell (piped / headless flags)
- Huge `run_command` output instead of maintaining Deputy TUI session
- Deputy CLI calling terminal bridge MCP in default topology (Lead calls MCP)

## Lead vs Deputy by runtime shape

| Runtime | Role in this Skill |
|---------|-------------------|
| App **dialogue Agent** + MCP client + integrated terminals | **Lead** (Skill loader) |
| **CLI inside integrated terminal** (interactive TUI) | **Deputy** |
| Headless / remote agent without host MCP | Needs separate bridge; not default |

**Same host product, two roles:** A single application may offer both a **dialogue Agent** (Lead, with MCP) and a **terminal CLI tab** (Deputy). Role follows **current session shape**, not the product name.

## Manual mode (Preflight `missing`)

When User will not install a bridge yet:

1. Lead prints handoff text in chat for User to paste into Deputy terminal
2. User relays Deputy reply or asks Lead to read terminal file
3. Plan roster: `terminal_bridge: manual`
4. Encourage installing bridge before next feature cycle

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| MCP not connected | Reload window; restart Terminal MCP server |
| `ECONNREFUSED 127.0.0.1:6070` | Extension not listening on that port — set `terminalMcp.port` at the **same scope** as mcp.json, reload window |
| Wrong port | Match `terminalMcp.port` with mcp.json URL **and** status bar |
| Works in one project only | User-level mcp.json + project-only `.vscode/settings.json` — promote port settings to user scope |
| Deputy silent | `focus_terminal` first; **mandatory two-step Enter (`\r`)**; shorten message |
| Message stuck in input, not sent | Lead forgot Step 2 Enter — resend with `\r` submit |
| Lead idle, Deputy still working | Enable **Deputy activity watch** at 1/5/10/30m intervals |
| Extension unavailable in marketplace | Try Terminal Automatization; Arc may need manual VSIX |
| `run_command` empty | Enable shell integration on supported editors (1.93+) |
| Lead and Deputy same terminal | Wrong topology — Deputy must be separate TTY CLI session |

## Advanced: CLI as MCP client

If a terminal CLI has its own MCP client and supports HTTP to the bridge port, it could theoretically orchestrate terminals. Out of default Skill topology; requires manual MCP wiring per CLI docs.
