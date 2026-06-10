# superpowers-dual-agent-collab

> **多一双眼睛再交付 — Superpowers 可选。** 与宿主无关的 Agent Skill：**双 Agent 协作**，由 **Lead（加载本 Skill 的 Agent）** 与 **Deputy（内置终端里的 TTY CLI）** 经终端桥接 MCP 完成 plan 互审与结构化验收。

**English** → [README.md](README.md)

---

## 为什么需要它

单 Agent 快，但容易漏风险、缺二审。本 Skill 定义可复用的 **Lead + Deputy 双 Agent 协作**流程：

- **Preflight** — 派活前先检查终端桥接 MCP  
- **Superpowers 可选** — 每次会话询问是否启用；`on` 叠加 brainstorming / writing-plans 等流程，`off` 走经典双 Agent 流程  
- **Plan 审阅** — Deputy 只审不改；Lead 写接纳建议；你确认  
- **实施分工可选** — 由你指定 Lead 或 Deputy 主改代码  
- **验收** — 静态/HTTP 表格报告；UI 项标「待人工」  
- **免手抄** — 桥接配好后，Lead 直接向 Deputy 终端下发任务  
- **回车提交** — Lead 输入任务后必须按回车（`\r`）发出，否则 Deputy 收不到  
- **活动监测** — Deputy 工作期间 Lead 按约定间隔（默认 1/5/10/30 分钟）轮询终端进度  

适用于支持 Agent Skill 与 MCP 终端控制的**任意宿主**，不绑定单一厂商。

## 角色

| 角色 | 定义 |
|------|------|
| **Lead** | 加载本 Skill 的**对话 Agent**（具备 MCP） |
| **Deputy** | 宿主**内置终端**中的交互式 CLI |
| **你** | 确认 plan、选实施主、浏览器验收、安装桥接 |

同一宿主既可作 Lead（对话 + MCP），也可作 Deputy（终端 CLI 标签页）——看**当前会话形态**。

## 前置条件

安装 **终端桥接**（推荐 [Terminal Automatization](https://marketplace.visualstudio.com/items?itemName=davidrsch.terminal-automatization)）。备选：Arc Terminal Bridge、vscode-terminal-mcp、mcp-interactive-terminal。

可选：Cursor 安装 [Superpowers](https://github.com/obra/superpowers) 插件（`/plugin-add superpowers`）。

→ 详见 [setup-reference.md](setup-reference.md)

## 安装

克隆到宿主文档中的**个人 skills 目录**：

```bash
git clone https://github.com/MoonMaxTea/superpowers-dual-agent-collab.git
# 复制或软链为 superpowers-dual-agent-collab/
```

## 快速开始

1. 安装终端桥接，在**同一作用域**（用户级或项目级）同时配置 MCP URL 与 `terminalMcp.port`。示例固定端口：`http://127.0.0.1:6070/mcp` + `"terminalMcp.port": 6070`，然后重载窗口。详见 [setup-reference.md](setup-reference.md)。
2. 在内置终端启动 Deputy CLI（你的 `start_command`）。
3. 在新对话中说：

   ```text
   使用 superpowers-dual-agent-collab skill，先 Preflight，再审阅 docs/plans/某功能.md
   ```

4. 流程：Preflight 汇报 → **是否启用 Superpowers？** → 询问实施主与副手 → 阶段 A–C。

## 流程

```
Preflight → 会话初始化 → 审 plan (A) → 实施 (B) → 验收 (C) → 修复 (D)
```

**固定规则：** Plan 起草权始终在 **Lead**。

## 目录结构

```
superpowers-dual-agent-collab/
├── README.md / README.zh-CN.md
├── SKILL.md
├── setup-reference.md
├── superpowers-integration.md
└── templates/
```

## 调用

- Skill 名：`superpowers-dual-agent-collab`
- 需显式点名或触发词：*superpowers-dual-agent*、*双 Agent 协作*、*副手*、*Preflight*

## 许可

MIT — 见 [LICENSE](LICENSE)。
