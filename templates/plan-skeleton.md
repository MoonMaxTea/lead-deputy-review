# {FEATURE_TITLE}

> 状态：草案 | 创建：{DATE}  
> **分工**：Lead 起草 plan | Deputy 审阅 + 验收 | User 确认与 UI 验收  
> **实施主**：`{IMPLEMENTATION_LEAD}`（lead | deputy）  
> **终端桥接**：`{TERMINAL_BRIDGE_STATUS}`（ok | missing | degraded | manual）  
> 关联代码：{LINKED_PATHS}

## 分工表

| 阶段 | Lead | Deputy | User |
|------|------|--------|------|
| Plan 起草 | 起草与维护 | 只审不改 | 确认 plan |
| 实施 | {LEAD_IMPL_CELL} | {DEPUTY_IMPL_CELL} | 产品取舍 |
| 验收 | {LEAD_ACCEPT_CELL} | {DEPUTY_ACCEPT_CELL} | 浏览器/UI |
| 终端桥接 | MCP 下发（或 manual 粘贴） | TTY 会话内执行 | 安装插件 |

`plan_author` 固定为 **Lead**，不随实施主切换。

## Deputy 监测配置

> Phase 0 / Plan 起草时由 Lead 询问 User 确认；Deputy 工作期间 Lead 按此间隔轮询终端。

| 项 | 配置 |
|----|------|
| 启用监测 | `{DEPUTY_WATCH_ENABLED}`（默认 true） |
| 检查间隔（分钟） | `{DEPUTY_WATCH_INTERVALS}`（默认 `1, 5, 10, 30`） |
| 无进展时 | `{ON_STALL}`（默认 notify_user — 向 User 汇报停滞） |

Lead 职责：每次 MCP 下发任务并**回车提交**后启动监测；每个间隔读取 Deputy 终端快照，有变化则简报，完成则停止。

## 概述

{ONE_PARAGRAPH_GOAL}

## 背景与问题

{CURRENT_STATE_AND_PAIN}

## 目标与范围

### 在范围内

- {IN_SCOPE_1}
- {IN_SCOPE_2}

### 不在范围内

- {OUT_OF_SCOPE_1}

## 审阅结论 / 接纳建议

> 阶段 A：Deputy 审阅后，由 Lead 填写；User 确认前必填。

| Deputy 建议 | 严重程度 | Lead 接纳 | 理由 |
|-------------|----------|-----------|------|
| {SUGGESTION_1} | high / med / low | 采纳 / 部分采纳 / 不采纳 | {REASON} |

## 验收标准

可测试、可勾选的条目（Deputy 静态验收 + User 人工项分开写）：

- [ ] {ACCEPTANCE_CRITERION_1}
- [ ] {ACCEPTANCE_CRITERION_2}
- [ ] 全局筛选/刷新后状态保持正确
- [ ] 无已知内存泄漏或控制台报错（如适用）

## 测试环境配置

### 运行环境

| 项 | 配置 |
|----|------|
| 工作目录 | {REPO_ROOT} |
| 启动命令 | `{START_COMMAND}` |
| 访问 URL | {RUN_URL} |
| 版本核对 | `{VERSION_FIELD}`（如 `app.py` VERSION、`package.json` version） |

### Deputy 可做的自动化检查（无需浏览器）

| 检查项 | 方法 |
|--------|------|
| {CHECK_1} | `{grep/curl/command}` |
| {CHECK_2} | `{grep/curl/command}` |
| HTTP 可达 | `curl` 主页与关键静态资源 → 200 |
| 构建产物 | 源文件改动已反映到 bundle/构建输出（如适用） |

### 待人工（浏览器 / UI）

1. {MANUAL_STEP_1}
2. {MANUAL_STEP_2}
3. 硬刷新（Ctrl+F5）后复测

Deputy 报告中将以上标为 **待人工**。

## Deputy 提示词（供 Lead MCP 发送）

### Plan 审阅版

```text
@{PLAN_PATH} 请审阅本 plan，只审不改：
1) 范围与验收标准是否可测；
2) 风险与遗漏；
3) 与项目惯例冲突点。
输出表格：项 | 建议 | 严重程度。不要直接修改 plan 文件。
```

### 验收版

```text
@{PLAN_PATH} Lead 已完成实施。请按「验收标准」和「测试环境配置」验收：
1) 静态代码与构建检查；
2) 确认服务运行并 curl 关键 URL（version={VERSION}）；
3) 列出与 plan 不符或高风险问题；
4) UI 项标「待人工」并给操作步骤。
报告表格：项 | 结果 | 证据（文件行号或 curl 状态码）。中文。
```

## 实施清单

- [ ] Plan 审阅（Deputy）+ 接纳建议（Lead）+ User 确认
- [ ] 实施完成 + handoff 字段（version、changed_files、run_url）
- [ ] Deputy 静态 + HTTP 验收（或 Lead 验收若 implementation_lead: deputy）
- [ ] User 浏览器验收
- [ ] 修复循环关闭

## Handoff（实施方填写）

```text
version_or_build_id: {VERSION}
changed_files:
  - {FILE_1}
run_url: {RUN_URL}
start_command: {START_COMMAND}
notes: {BUILD_RESTART_STEPS}
```
