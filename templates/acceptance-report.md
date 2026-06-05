# Acceptance Report Template

Deputy (or Lead when `implementation_lead: deputy`) fills this after Phase C checks.

---

```markdown
# 验收报告 — {FEATURE_TITLE}

| 字段 | 值 |
|------|-----|
| plan | {PLAN_PATH} |
| version_or_build_id | {VERSION} |
| implementation_lead | lead / deputy |
| terminal_bridge | ok / manual / degraded |
| 验收方 | Lead / Deputy |
| 日期 | {DATE} |

## 1. 自动化检查

| 项 | 结果 | 证据 |
|----|------|------|
| 服务 HTTP 可达 | pass / fail | curl {URL} → {CODE} |
| 构建产物/version 一致 | pass / fail | {EVIDENCE} |
| {CUSTOM_CHECK_1} | pass / fail / skip | {EVIDENCE} |
| {CUSTOM_CHECK_2} | pass / fail / skip | {EVIDENCE} |

## 2. 与 plan 一致性

| plan 条目 | 结果 | 备注 |
|-----------|------|------|
| {ACCEPTANCE_CRITERION} | pass / fail | {NOTE} |

## 3. 问题清单

| 项 | 严重程度 | 说明 | 证据 | 建议修复方 |
|----|----------|------|------|------------|
| {ISSUE} | critical / major / minor | {DESC} | {file:line or log} | Lead / Deputy |

严重程度：
- **critical**：阻塞发布，须修复后复验
- **major**：应修复，可协商
- **minor**：建议，不阻塞

## 4. 待人工（User 浏览器 / UI）

| 项 | 操作步骤 | 预期 |
|----|----------|------|
| {UI_ITEM} | {STEPS} | {EXPECTED} |

## 5. 结论

- 总体：pass / pass-with-manual / fail
- 须复验：是 / 否
- 给 User 的一句话：{SUMMARY}
```

---

## Lead triage after report

| Bucket | Action |
|--------|--------|
| critical | Implementer fixes before User UI pass |
| major | Fix or document waiver in plan |
| 待人工 | Hand User the table in §4 |
| minor / suggestion | Lead 接纳建议 in plan or defer |
