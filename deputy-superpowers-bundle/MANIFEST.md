# Deputy Superpowers Bundle — Manifest

Project-local Superpowers skills for **Deputy** (TTY CLI in integrated terminal). Lead uses the Superpowers **plugin**; Deputy reads skills from the project repo so both agents follow the same protocol.

## Install location (per project)

```
<repo>/.cursor/skills/superpowers/
├── MANIFEST.md              ← copy from this file (update version after sync)
├── executing-plans/
├── test-driven-development/
├── finishing-a-development-branch/
├── verification-before-completion/
└── systematic-debugging/
```

Default path in plans and handoffs: `.cursor/skills/superpowers/`

## Bootstrap

From repo root:

```powershell
# Windows
.\path\to\sync-deputy-superpowers-bundle.ps1 -ProjectRoot .
```

```bash
# macOS / Linux
./path/to/sync-deputy-superpowers-bundle.sh .
```

Or copy this `deputy-superpowers-bundle/` folder's sync scripts from the skill repo `scripts/` directory.

## Bundled skills (required)

| Skill | Phase | Role | Why included |
|-------|-------|------|--------------|
| `executing-plans` | B — Implement | Deputy (or Lead in terminal) | Step-by-step plan execution with stop conditions |
| `test-driven-development` | B — per task | Implementer | Code changes follow red-green-refactor |
| `finishing-a-development-branch` | B — wrap-up | Implementer | **Required sub-skill** of executing-plans |
| `verification-before-completion` | C — Acceptance | Acceptor (Deputy when `implementation_lead: lead`) | Evidence before pass claims |
| `systematic-debugging` | D — Fix loop | Implementer | Root-cause before fixes |

## Lead-only skills (plugin — do NOT copy to Deputy bundle)

| Skill | Phase | Role |
|-------|-------|------|
| `brainstorming` | A — draft | Lead |
| `writing-plans` | A — draft | Lead |
| `subagent-driven-development` | B — implement | Lead (when Task/subagents available) |
| `requesting-code-review` | B/C — review | Lead reviews Deputy diff |
| `receiving-code-review` | B/C | Deputy responds to Lead review feedback |

## Phase × Role × Skill matrix (`superpowers_mode: on`)

| Phase | `implementation_lead: lead` | `implementation_lead: deputy` |
|-------|----------------------------|------------------------------|
| A — Plan draft | Lead: `brainstorming` → `writing-plans` (plugin) | Same |
| A — Plan review | Deputy: critique only (no skill file) | Same |
| B — Implement | Lead: `executing-plans` (plugin) + TDD | Deputy: read `executing-plans` → TDD → `finishing-a-development-branch` from **project bundle** |
| B — Post-impl review | Deputy: `verification-before-completion` + acceptance-report | Lead: `requesting-code-review` (plugin) on Deputy diff |
| C — Acceptance | Deputy: `verification-before-completion` (bundle) + report template | Lead: `verification-before-completion` (plugin) triage |
| D — Fix | Implementer: `systematic-debugging` (bundle or plugin by role) | Same |

## Deputy TTY constraints

- Deputy typically has **no subagents** — use `executing-plans`, not `subagent-driven-development`.
- Deputy must **read SKILL.md files explicitly** — handoff text must include full paths.
- Deputy must **announce** at skill start (per each SKILL.md).
- Blockers → stop and ask; do not guess.

## Version sync

Record after each sync:

```yaml
source: cursor-superpowers-plugin
synced_at: YYYY-MM-DD
plugin_cache_glob: ~/.cursor/plugins/cache/cursor-public/superpowers/*/skills/
bundle_skills:
  - executing-plans
  - test-driven-development
  - finishing-a-development-branch
  - verification-before-completion
  - systematic-debugging
```

Re-run sync script when Superpowers plugin updates to avoid drift.

## Preflight (Lead checks when `superpowers_mode: on`)

```
Deputy Superpowers Bundle Preflight:
- [ ] .cursor/skills/superpowers/MANIFEST.md exists
- [ ] All 5 bundled skill folders contain SKILL.md
- [ ] Plan includes verification commands per task
- [ ] Handoff uses Skill-first template (read SKILL.md before plan)
```
