# Lead → Deputy Handoff Templates

Lead sends via terminal-bridge MCP (`focus_terminal` → `send_text_to_terminal` → **Enter submit**). **Always** use two-step send: message with `execute: false`, then `"\r"` with `execute: false`. Skipping Enter leaves text in the input buffer — Deputy never receives the task.

Placeholders: `{PLAN_PATH}` `{VERSION}` `{CHANGED_FILES}` `{CHECKLIST_REF}` `{IMPLEMENTATION_LEAD}` `{DEPUTY_NAME}`

---

## 1. Plan review

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

Use when `implementation_lead: deputy`.

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

Use when `implementation_lead: lead`.

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

## Manual mode (no MCP bridge)

When `terminal_bridge: manual`, Lead prints the same text in chat:

```text
请将以下内容粘贴到 {DEPUTY_NAME} 终端并回车：

<paste variant 1/2/3 above>
```
