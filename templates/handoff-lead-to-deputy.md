# Lead → Deputy Handoff Templates

Lead sends via terminal-bridge MCP (`focus_terminal` → `send_text_to_terminal` → **Enter submit**). **Always** two-step send: message with `execute: false`, then `"\r"` with `execute: false`.

Placeholders: `{PLAN_PATH}` `{SKILLS_ROOT}` `{VERSION}` `{CHANGED_FILES}` `{CHECKLIST_REF}` `{IMPLEMENTATION_LEAD}` `{DEPUTY_NAME}` `{ISSUE_SUMMARY}`

Default `{SKILLS_ROOT}` = `.cursor/skills/superpowers`

When `superpowers_mode: off`, use §1–§3 **classic** variants (bottom). When `on`, use **Skill-first** variants.

---

## 1. Plan review

### Skill-first (`superpowers_mode: on`) — **default when on**

Use in Phase A after Lead drafts plan.

```text
@{PLAN_PATH} 请做 Plan 审阅（只审不改，不进入实施）。严格按以下顺序：

1) 读取 {SKILLS_ROOT}/executing-plans/SKILL.md，开头 announce 使用该 skill
2) 仅执行其中 Step 1「Load and Review Plan」— 批判性审阅；不要进入 Step 2 实施
3) 额外检查（对照 writing-plans 质量标准，只作审阅清单，不要重写 plan）：
   - 任务粒度是否 bite-sized（每步 2–5 分钟级）
   - 每个任务是否有 verification 命令
   - 文件边界与仓库惯例（AGENTS.md、现有模块）是否清晰
4) 输出表格：项 | 建议 | 严重程度（high/med/low）| 待 Lead 澄清（如有）
5) 禁止：修改 plan 文件、问 User、invoke 其他 skill、开始写代码

审阅完成后在终端回复摘要。有疑问写入「待 Lead 澄清」列，由 Lead 在接纳建议时处理。
```

### Classic (`superpowers_mode: off`)

```text
@{PLAN_PATH} 请审阅本 plan，只审不改：
1) 范围与验收标准是否可测、有无遗漏；
2) 技术风险与边界情况；
3) 与仓库惯例（AGENTS.md、现有模块结构）是否冲突。
输出表格：项 | 建议 | 严重程度（high/med/low）。
不要直接修改 plan 文件。审阅完成后在终端回复摘要。
```

---

## 2. Deputy-led implementation

### Skill-first (`superpowers_mode: on`) — **default when on**

Use when `implementation_lead: deputy`.

```text
User 已确认 plan，implementation_lead=deputy。请严格按以下顺序执行，不要跳过：

1) 读取 {SKILLS_ROOT}/executing-plans/SKILL.md，开头 announce 使用该 skill
2) 读取 @{PLAN_PATH}，批判性审阅；有疑问先停下询问，不要猜测
3) 按 executing-plans 逐步执行 plan 任务；每个涉及代码改动的任务先读 {SKILLS_ROOT}/test-driven-development/SKILL.md 并遵循
4) 全部任务与 verification 通过后，读取 {SKILLS_ROOT}/finishing-a-development-branch/SKILL.md 并收尾
5) 不要修改 plan 正文

完成后按实施交接格式汇报：
version_or_build_id、changed_files、run_url、build_steps、ready_for_acceptance: yes/no、notes

Lead 将只读 review diff，不并行改同一模块。遇阻塞立即停止并说明。
```

### Classic (`superpowers_mode: off`)

```text
@{PLAN_PATH} User 已确认 plan，implementation_lead=deputy。
请按 plan 实施，注意：
1) 仅改 plan 范围内文件；
2) 完成后汇报：version_or_build_id、changed_files、run_url、构建/重启步骤；
3) 不要改 plan 正文。
Lead 将只读 review diff，不并行改同一模块。
```

---

## 3. Acceptance (Deputy accepts Lead's work)

### Skill-first (`superpowers_mode: on`)

Use when `implementation_lead: lead`.

```text
Lead 已完成实施。请严格按以下顺序验收：

1) 读取 {SKILLS_ROOT}/verification-before-completion/SKILL.md，开头 announce 使用该 skill
2) 读取 @{PLAN_PATH} 的「验收标准」与「测试环境配置」
3) 运行 plan 中的 verification 命令（必须重新执行，不用旧结果）
4) 输出验收报告，表格：项 | 结果 | 证据（文件行号或 curl 状态码）。中文。
5) 浏览器/UI 项标「待人工」，附操作步骤

version={VERSION}，改动文件参考：{CHANGED_FILES}
报告结构见项目 acceptance-report 模板。结论须基于 fresh evidence。
```

### Classic (`superpowers_mode: off`)

```text
@{PLAN_PATH} Lead 已完成实施。请按 plan「验收标准」和「测试环境配置」验收：
1) 静态代码与 {CHECKLIST_REF} 检查；
2) 确认服务运行；curl 页面与关键资源（version={VERSION}）；
3) 列出与 plan 不符或高风险项（含资源泄漏、边界数据）；
4) 浏览器/UI 项标「待人工」，附操作步骤。
报告格式见 acceptance-report 模板：项 | 结果 | 证据。中文。
改动文件参考：{CHANGED_FILES}
```

---

## 4. Fix loop (Skill-first — `superpowers_mode: on`)

Send to **implementer** (Deputy or Lead terminal) when acceptance or review found issues.

```text
验收/审阅发现问题，请修复。严格按以下顺序：

1) 读取 {SKILLS_ROOT}/systematic-debugging/SKILL.md，开头 announce 使用该 skill
2) 读取 @{PLAN_PATH} 相关章节与以下问题摘要：
{ISSUE_SUMMARY}
3) 先定位根因再改代码；不要猜测性修补
4) 修复后重新运行 plan 中的 verification 命令
5) 汇报：根因、修改文件、verification 证据、ready_for_re_acceptance: yes/no
```

---

## Manual mode (no MCP bridge)

When `terminal_bridge: manual`, Lead prints the same text in chat:

```text
请将以下内容粘贴到 {DEPUTY_NAME} 终端并回车：

<paste variant above>
```
