# Deputy → Lead Report Templates

Deputy outputs in terminal. Lead ingests via terminal snapshot or User relay.

---

## Plan review report (Phase A)

When `superpowers_mode: on`, Deputy follows `{SKILLS_ROOT}/executing-plans/SKILL.md` Step 1 only before reporting.

```markdown
## Plan 审阅报告 — {FEATURE_TITLE}

| 项 | 建议 | 严重程度 | 待 Lead 澄清 |
|----|------|----------|--------------|
| {ITEM} | {SUGGESTION} | high / med / low | {CLARIFICATION_OR_—} |

### 总结
{ONE_PARAGRAPH}
```

Lead must map each row to **采纳 / 部分采纳 / 不采纳** in plan before User confirmation. Resolve「待 Lead 澄清」items in 审阅结论 section.

---

## Acceptance report (Phase C)

Follow `{SKILLS_ROOT}/verification-before-completion/SKILL.md` — run **fresh** verification commands; cite evidence.

Use [acceptance-report.md](acceptance-report.md) structure. Minimum:

```markdown
## 验收报告 — {FEATURE_TITLE}

version_or_build_id: {VERSION}
implementation_lead: {lead|deputy}

### 自动化检查

| 项 | 结果 | 证据 |
|----|------|------|
| {CHECK} | pass / fail / skip | {file:line or curl code} |

### 问题（须修复）

| 项 | 严重程度 | 说明 | 证据 |
|----|----------|------|------|
| {ISSUE} | critical / major | {DESC} | {EVIDENCE} |

### 待人工（User 浏览器）

| 项 | 建议操作 |
|----|----------|
| {UI_CHECK} | {STEPS} |

### 结论
- [ ] 可进入 User UI 验收
- [ ] 须 Lead/Deputy 修复后复验
```

---

## Implementation complete (Deputy as implementer)

Follow `{SKILLS_ROOT}/executing-plans/SKILL.md` and `{SKILLS_ROOT}/finishing-a-development-branch/SKILL.md` before reporting.

```markdown
## 实施交接 — {FEATURE_TITLE}

version_or_build_id: {VERSION}
changed_files:
  - {FILE}
run_url: {URL}
build_steps:
  - {STEP}
ready_for_acceptance: yes / no
notes: {OPTIONAL}
```

Lead then runs Phase C acceptance.
