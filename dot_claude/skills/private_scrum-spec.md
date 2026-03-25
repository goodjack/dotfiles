# Scrum 開發範圍文件撰寫原則

## 用途

撰寫適合 scrum team 使用的技術實作規格文件，聚焦於「確認開發範圍」，避免冗餘與重複內容。

## 何時使用

當需要撰寫以下類型的文件時：
- 功能實作計畫 (Implementation Plan)
- 技術規格文件 (Technical Specification)
- API 設計文件 (API Design Document)
- 架構設計文件 (Architecture Design Document)

## 核心原則：探索 + 差異 + 一提 + 範圍

### 1. 探索 (Explore)
**先探索 codebase 現況，再撰寫文件**

- 使用 Glob、Grep、Read 工具探索現有架構
- 識別：models、API modules、services、constants、環境變數
- 比對需求與現況，找出差異

### 2. 差異 (Diff)
**只寫需要變更的部分**

✅ **要寫的**：
- 需要新建的模組、檔案、class、function
- 需要擴充的 enum、constants、API、model 欄位
- 明確標示每項是「新建」還是「擴充」

❌ **不要寫的**：
- 已存在的架構詳細說明
- 現有 model 結構描述
- 已定義的 constants 或 enums
- 詳細的程式碼實作範例（除非必要）

### 3. 一提 (Once)
**每個內容只提一次，不重複**

❌ **避免的重複**：
- 驗收標準章節（Spec 本身就是驗收標準）
- 交付產出清單（與實作章節重複）
- 測試清單（與實作章節重複）
- 同一個 spec 在多個章節出現

✅ **唯一例外**：
- Changelog 可以總結性地提及變更

### 4. 範圍 (Scope)
**文件定位：確認開發範圍**

**文件目的**：
- 讓 scrum team 快速理解「要做什麼」
- 明確開發範圍與邊界
- 提供技術決策參考

**不是**：
- 驗收檢查清單
- 交付檢查表
- 詳細實作教學
- 程式碼範例集

## 文件結構範本

```markdown
# [功能名稱] 實作計畫

> 版本、日期、目標

## Changelog
- 記錄各版本變更

## 一、專案背景與目標
- 開發範圍說明

## 二、資料模型設計
### 需要新建
- [ ] 列出新建的 models

### 需要擴充
- [ ] 列出需要擴充的部分（明確說明擴充什麼）

## 三、API 設計
### 需要新建
- 新建的 API 模組

### 需要擴充
- 需要擴充的 API（明確說明擴充什麼）

## 四、服務架構設計
- 需要新建的 services
- 需要整合的現有服務

## 五、與現有系統整合
- 整合點說明（只列需要新增的部分）

## 六、實作順序
- Phase 1-N（簡潔的階段說明，不重複列舉）

## 七、關鍵決策點
- 需要確認的技術決策
- 需要產品確認的決策

## 八、風險評估與緩解
- 技術風險
- 業務風險
- 協作風險

## 九、附錄
- 參考文件連結
```

## 撰寫風格

### 使用簡潔的 Spec 格式

✅ **好的範例**：
```markdown
### 需要新增的內容（`api_users/constants.py`）：
1. **3 個 SubscriptionGroup 推播通道**：
   - COMMENT_PUSH_GROUP
   - MESSAGE_PUSH_GROUP
   - FOLLOW_PUSH_GROUP

2. **7 個 SubscriptionType 推播類型**：
   - 留言：POST_COMMENT_PUSH、COMMENT_REPLY_PUSH
   - 訊息：NEW_MESSAGE_PUSH、SERVICE_MESSAGE_PUSH
   - 關注：FOLLOW_REQUEST_ACCEPTED_PUSH、FOLLOW_ADD_PUSH
```

❌ **避免的範例**（過於詳細的程式碼）：
```markdown
### SubscriptionGroup 推播通道

現有表結構：
- 複合主鍵：(pid, subscription_group)
- 欄位：pid、subscription_group、is_subscribed

新增內容：
```python
class SubscriptionGroup(StrEnum):
    # 現有 Email 通道
    COMMENT_EMAIL_GROUP = "COMMENT_EMAIL_GROUP"
    MESSAGE_EMAIL_GROUP = "MESSAGE_EMAIL_GROUP"

    # 新增推播通道
    COMMENT_PUSH_GROUP = "COMMENT_PUSH_GROUP"
    MESSAGE_PUSH_GROUP = "MESSAGE_PUSH_GROUP"
```
```

## 執行檢查清單

撰寫完成後，自我檢查：

- [ ] 是否先探索了 codebase？
- [ ] 文件中是否只列出「需要變更」的部分？
- [ ] 是否有描述「已存在架構」的冗餘內容？
- [ ] 是否有重複的章節（驗收標準、交付清單）？
- [ ] 每個 spec 是否只出現一次？
- [ ] 是否使用簡潔的列舉格式，而非詳細程式碼？
- [ ] 是否明確標示「新建」或「擴充」？
- [ ] 文件定位是否清楚（開發範圍確認，非驗收清單）？

## 關鍵記憶口訣

**Scrum Spec = 探索 + 差異 + 一提 + 範圍**

**一句話指令**：
```
請寫 [功能] 的實作 spec：
探索 codebase + 只寫差異 + 一事一提 + scrum 開發範圍
```
