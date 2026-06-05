# Terminal Bridge Setup Reference

Lead + Deputy collaboration requires a **terminal bridge**: MCP tools that list integrated terminals and send text into them. This document covers Preflight, installation, equivalents, and troubleshooting.

## Preflight checklist (Lead runs every session)

```
Terminal Bridge Preflight:
- [ ] MCP client has terminal-bridge tools (list + send)
- [ ] Test call: list_terminals succeeds
- [ ] Provider extension running (or degraded PTY MCP noted)
- [ ] Deputy terminal visible OR User will start start_command
- [ ] Lead is dialogue Agent (not the terminal CLI session under test)
```

Report to User:

```text
terminal_bridge: ok | missing | degraded | manual
provider: <name>
deputy_terminal: <name or pending>
```

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

Add to your **host MCP configuration** (project or user level — see your editor/agent documentation):

```json
{
  "mcpServers": {
    "terminal-automatization": {
      "url": "http://127.0.0.1:6070/mcp"
    }
  }
}
```

Optional editor settings for fixed port and shell integration:

```json
{
  "terminalMcp.port": 6070,
  "terminal.integrated.shellIntegration.enabled": true
}
```

Use port `0` for auto-pick; then read status bar and sync the URL in mcp.json.

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
4. `send_text_to_terminal` — handoff body
5. For TUI apps: second send with `"\r"` if first did not submit

### Two-step Enter (interactive TUIs)

`execute: true` alone often fails on interactive TUIs.

```
Step 1: send_text_to_terminal { text: "<full message>", execute: false }
Step 2: send_text_to_terminal { text: "\r", execute: false }
```

### Receiving Deputy output

- Read host terminal snapshot files (if your environment exposes them)
- Or ask User: "看副手回复" / paste output
- No automatic push subscription — Lead must poll or User relay

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
| Wrong port | Match `terminalMcp.port` with mcp.json URL |
| Deputy silent | `focus_terminal` first; two-step `\r`; shorten message |
| Extension unavailable in marketplace | Try Terminal Automatization; Arc may need manual VSIX |
| `run_command` empty | Enable shell integration on supported editors (1.93+) |
| Lead and Deputy same terminal | Wrong topology — Deputy must be separate TTY CLI session |

## Advanced: CLI as MCP client

If a terminal CLI has its own MCP client and supports HTTP to the bridge port, it could theoretically orchestrate terminals. Out of default Skill topology; requires manual MCP wiring per CLI docs.
