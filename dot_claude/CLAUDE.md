# AI 開發規範指南

## 使用說明
極簡token設計：符號+縮寫+規則分組+條件邏輯
規組=相關規則分組 ?專案→特定做法 符號取代文字描述

## 規則撰寫原則
→描述通用規則 NOT具體案例
→簡潔精準 NOT冗長範例
→說明規則本質 NOT單一實作細節

## 符號字典
→必須 NO禁止 NOT否定 ?條件 #使用 |或 &且

## 縮寫字典
TW=台灣正體(繁體)中文 PR=PullRequest DB=資料庫 py=Python CR=CodeReview APIM=API管理系統 CRM=後台管理

## 專案架構模式識別
?Profile模式(如104-profile-api)→三app實例+UUID/PID
?Nabi模式(如104-nabi-classroom)→startup載入

---

# 通用開發規則（跨專案共用）

## 規組1：語言+程式碼+重構
→TW用語語境: 以台灣軟體工程師的口吻撰寫 目標讀者=同事與主管
  語感=專業但自然口語 NO書面文言腔 NO浮誇商業詞(賦能/痛點/抓手/打通/落地)
  以下為典型範例NOT全部清單 未列舉詞彙仍須符合台灣在地慣用語 主動過濾對岸用語
  台灣工程師日常中英混用(Log/Instance/Trace/Sprint/Endpoint/Dashboard等) NO硬翻中文
  避開對岸慣用詞(如: 告警→警報 實例→Instance 端點→Endpoint 翻Log→撈Log 監控空白→監控死角 鎖定方案→綁定方案 全景視圖→總覽畫面 閾值→門檻值 接入→串接 運行→運作 回歸→復發 排查→除錯 額度→配額 埋點→埋設追蹤碼 文檔→文件 數據庫→資料庫 代碼→程式碼 增量→差異 全量→整批)
→pythonic(py慣用寫法)+PEP8風格指南+重構共用邏輯+型別安全
→識別重複邏輯→提取共用函數→明確職責→Union型別確保參數正確性
→新做法→詢問更新CLAUDE.md →即時記錄經驗
→規則同步檢查: AGENTS.md(專案)→CLAUDE.md(全域)→gist同步前確認通用規則已提升至全域
→gist同步:
  CLAUDE.md: gh gist edit 56b83c52ea12d94c4125d3aba96ef9cf --filename CLAUDE.md /Users/jack.lin/.claude/CLAUDE.md
  reviewing-code-SKILL.md: gh gist edit 56b83c52ea12d94c4125d3aba96ef9cf --filename reviewing-code-SKILL.md /Users/jack.lin/.claude/skills/reviewing-code/SKILL.md

## 規組2：CR+Git操作
→/reviewing-code skill執行完整CR流程(詳見~/.claude/skills/reviewing-code/SKILL.md)
→TW回應+#TodoWrite管理進度+顯示N/M計數
→遵循查證/量化/誠實標示/修正前確認原則

## 規組3：API開發+DB
### 三層架構
serializers(請求回應) + actions(業務邏輯) + views(API端點)
→api_{domain}命名慣例
回應格式: ApiOutputModel.serialize_success(data)

### 應用架構
?Profile→三app實例(app/app_apim/app_crm)+路由分配規則
?Nabi→單app+動態路由載入 /{service_type}/{service_name}

### API串接方式
?Profile→經過APIM系統→#APIMCaller|非APIM→#AsyncServiceCaller
?Nabi→直接HTTP整合模式
Services匯入: from services.{service_name} import actions as {service_name}_service

### 命名慣例
類別名:{ServiceName}API
方法名:snake_case描述性命名
目錄名:snake_case NO hyphen連字號
Request模型:{Action}Request
Response模型:{Entity}Response

### 匯入慣例
模組級匯入避免循環相依:
→匯入模組actions設別名 NOT直接匯入函數
→呼叫用別名.函數名
→適用api_*模組&services/*模組相互引用
→延遲函數解析避免循環相依

### DB資料庫慣例
#inject_session(DB連線裝飾器)(DBName.ASYNC_READ_ONLY查詢|ASYNC_DEFAULT寫入)
→所有寫入操作必須#@transactions裝飾器(@inject_session之下)
→#@transactions時NO手動commit() 裝飾器自動處理
→寫入後需回傳資料→#flush() NOT commit()+refresh()
Model位置: 與actions同模組 NOT統一放app/models.py
表名: 單數形式(word非words)
軟刪除: delete_date欄位NULL=未刪除
Migration: Model修改→make makemigrations→make migrate
Migration修正(開發): downgrade→刪檔→修Model→makemigrations→migrate
Migration ENUM: Alembic新增值採保守策略(保留原順序+新值放最後)→constants.py新值必須放最後與Alembic一致|檢查migration確認ENUM順序|順序差異不影響功能
AsyncSession參數: db:AsyncSession=None(放最後參數)
OffsetPaginator: start/size參數+迭代result+OffsetPageOutModel.from_page

### 環境變數配置+FastAPI+外部API+Components
環境變數: 所有yml+environment.py添加os.getenv()
導入: from settings import VARIABLE_NAME (NOT from settings.environment)
FastAPI: ErrorLoggingRoute+logger.getLogger(__name__)+Import順序(標準庫→第三方→專案)
外部API回應: 先直傳→TypeError表示已dict移除json.loads→字串用json.loads
Components架構: api_service(回應格式) e104(104服務整合+APIMCaller基類) fastapi(擴展工具) sqlalchemy(DB工具+inject_session) http(APIM/HTTP呼叫) redis(AioRedisCache快取) utils(通用工具)
APIM文件分離: apim_openapi()函數+專門路由

### Dramatiq背景任務+Redis快取
tasks.py+專屬佇列(DRAMATIQ_QUEUES_*)+settings/common.py定義
Import: from api_module import tasks as module_tasks (NOT lazy import)
調用: module_tasks.task_name.send(參數)
Redis快取: 明確鍵命名+TTL(24h)+延遲載入+JSON序列化+不命中日誌

### 業務規則檢查
app/error_code.py+前綴命名+獨立檢查函數+BusinessRuleError+create/update整合

## 規組4：測試+品質+文件
### 測試策略
分層測試: 核心邏輯(業務) + DB整合(資料存取) + 快取功能
測試狀態標記: ✅通過 ⚠️跳過 ❌失敗
記錄: 執行時間+結果+跳過原因
容器網路限制下替代方案+區分必要vs可選測試+核心功能任何環境驗證
Mock策略: 測試API→Mock actions函數 NOT Mock DB Session(降低耦合+實作改變測試不變)
測試資料: 集中常數+輔助函數+parametrize減少重複
測試檔案: tests/目錄鏡像原始碼目錄結構+test_模組名.py

### 程式碼品質檢查+開發指令
開發段落完成→執行品質檢查工具
範圍限制: 只修正本次開發相關問題
即時修正: 發現問題立即修正
?Profile→make ruff-diff
?Nabi→ruff check/format+python local.py|uvicorn app.main:app

### 文件撰寫標準
實作文件: 概述+架構設計+實作細節+錯誤處理+測試驗證
需求文件: 功能描述+業務規則+API規格+資料結構+錯誤處理
範圍控制: 僅包含實際討論確認的功能需求 NO未討論擴充

### 技術文件規範
→單一概念只講一次 NO重複段落+NO重複圖表
→設定檔集中同章節 方便複製貼上
→表格化設定說明+處理選項 取代冗長文字
→inline註解取代頁尾附註(如: rev: v8.24.2 # 定期更新)
→單一流程圖呈現完整架構 NO複雜sequenceDiagram
→進階內容連結官方文件 NO內嵌細節
→精簡優先: 能用100行說清楚就不要寫200行

## 規組5：註解與文件品質
→宏觀視角: spec主軸+商業邏輯 NOT實作細節
→程式碼自述: 型別註解已說明 NOT docstring重複
→必要註解: 非顯而易見商業規則+架構決策原因+重要限制+複雜演算法關鍵步驟
→NO冗餘: 重述邏輯+明顯賦值+重複型別+框架標準操作+階段性小需求(組裝參數/呼叫API)

## 規組6：開發流程
品質檢查: make ruff→make ruff-diff (順序)
測試: make test
單一測試: podman compose exec backend poetry run pytest path -v
pytest.ini需asyncio marker配置
採用: TDD Pythonic
日誌層級: 只用info/error except區塊內用logger.exception 否則用logger.error(exc_info=e)

---

# 專案特有規則

## Profile專屬
### 三應用實例架構
app: 主要業務API(/api/*) app_apim: APIM系統API(/apim/api/*) app_crm: 後台管理API(/crm/api/*)
路由分配: apim模組→app_apim apic模組→app_crm 其他→app
資料庫配置: ASYNC_DEFAULT/ASYNC_READ_ONLY(非同步) DEFAULT/READ_ONLY(同步) HEYBAR(外部系統)

### UUID/PID雙向轉換
目的: 對外UUID內部PID
Request: UUID→PID#ac_service.get_pid_by_uuid_or_fail()(失敗拋異常)
Actions: 內部PID處理邏輯
Response: PID→UUID#transform_uuid_pid_in_dict(search_depth,target_key_list,delete_key=True,assign_new_key_name="uuid")

### 高級查詢+分頁+複用模式
列表查詢流程: OffsetPaginator(本地DB分頁)→me_service.profile_search(tops=pid_list批次查)→transfer_page_model(共用轉換)
OffsetPaginator: OffsetPaginator(session=db,stmt=stmt,limit=size).page(start)→result(rows)/count/has_next/next屬性
me_service.profile_search: tops參數(PID列表)用於批次查詢代替搜尋條件 &start=1&size=len(pid_list)
transfer_page_model: #共用函數查詢關注狀態(is_in_followed_list)→自動組裝ConnectionsProfileOutModel→分頁資訊轉換
Model擴充: 新欄位#SkipJsonSchema[None]+Field(None,title=...)→向後相容 NO強制欄位
分層資料過濾: parent_id.is_not(None)=子類別 parent_id.is_(None)=父類別 #select().distinct()避免重複
分組複用: 批次查詢結果→dict[pid→list[data]]組織→迴圈賦值給profile物件→count/has_next/next覆蓋本地分頁值

### 路由設計+欄位慣例
通用資源路由: /categories/{id}/resources=按分類查詢 /resources/{id}=按單一資源查詢
個人資源路由: /{uuid}/resources=個人資源 #transform_route_uuids_to_pids裝飾器自動轉換
關注狀態欄位: is_watcher_follow(bool)=觀看者是否已關注 #transfer_page_model自動填充 NO其他名稱變體

### 其他Profile慣例
PR標題前綴+標籤: develop→Develop:+develop標籤 lab→Lab:+無標籤 staging→Staging:+staging標籤 master→Production:+production標籤
參數驗證: #Enum+Pydantic自動驗證 constants/IntEnum
列表回應: SuccessModel[list[Model]] NO EntityListResponse包裝
5階段開發:
1.需求分析(確認需求+研究模式+架構決策+規格確認)
2.TodoList規劃(Serializers+Actions+Views+服務整合)
3.程式碼實作(遵循模式+保持一致+漸進開發+主動確認)
4.程式碼提交(status+diff檢查+commit+push)
5.PR審查(建立PR+標題標籤+執行/review+修正更新)
開發指令: poetry install→uvicorn(--reload --host 0.0.0.0 --port 8080 --log-level debug app.main:app)|make(up-build|up|logs|stop|bash|makemigrations|migrate|downgrade|ruff|ruff-diff|ruff-add-noqa)
路由載入詳細: 啟動掃描api_*/apim_*/apic_*目錄→必含views.py|views/__init__.py+router物件→apim_*→app_apim apic_*→app_crm api_*→app(main.py:100-134)
環境載入順序: settings/env/{BUILD_STAGE}.yml→.env覆蓋→environment.py所有變數os.getenv()

## Nabi專屬
### 開發啟動+模組嵌套
python local.py開發啟動
api_apim下有子模組: ability/course/exam/hrmall等

## 104公司架構模式
單進程多app實例+動態路由載入+四環境配置(local/dev/stg/prod)
app實例: app/app_apim/app_b/app_c/app_crm/app_d
路由掃描: api_*/apim_*/apib_*/apic_*/apid_*目錄(需含views.py或views/__init__.py)
DB連線: ASYNC_DEFAULT/ASYNC_READ_ONLY+外部系統DB
環境配置: BUILD_STAGE載入對應yml+domain(local/dev:104dc-dev.com stg:104dc-staging.com prod:104dc.com)
Components: fastapi/http/sqlalchemy/e104/structlog共享組件

---

## 重要提醒
NO建立新檔案除非絕對必要 →優先編輯現有檔案 NO主動建立*.md文件除非使用者明確要求
