# Twenty CRM 啟動與管理指南

## 📋 目錄
- [系統概述](#系統概述)
- [前置條件檢查](#前置條件檢查)
- [啟動服務](#啟動服務)
- [日誌查看](#日誌查看)
- [訪問地址](#訪問地址)
- [故障排除](#故障排除)
- [停止服務](#停止服務)

## 🏗️ 系統概述

Twenty CRM 是一個開源的客戶關係管理系統，基於以下技術棧：
- **後端**: NestJS + PostgreSQL + Redis
- **前端**: React + Vite
- **開發環境**: Node.js v22 + Yarn

### 系統架構
```
Twenty CRM
├── 後端服務 (Port 3000) - API & GraphQL
├── 前端服務 (Port 3001) - Web界面
├── PostgreSQL (Port 5432) - 主資料庫
└── Redis (Port 6379) - 快取服務
```

## ✅ 前置條件檢查

在啟動Twenty CRM之前，請確保以下服務正在運行：

### 檢查PostgreSQL
```powershell
netstat -an | Select-String ":5432"
```
**預期結果**: 應該看到 `LISTENING` 狀態的連接

### 檢查Redis
```powershell
netstat -an | Select-String ":6379"
```
**預期結果**: 應該看到 `LISTENING` 狀態的連接

### 檢查Node.js版本
```powershell
node --version
```
**預期結果**: `v22.x.x`

### 檢查Yarn
```powershell
yarn --version
```
**預期結果**: `4.x.x` 或更高版本

## 🚀 啟動服務

### 方法1: 使用自動啟動腳本（推薦）

直接執行啟動腳本：
```powershell
cd D:\program\twenty
.\start-twenty.bat
```

或者雙擊 `start-twenty.bat` 文件。

### 方法2: 手動啟動

需要開啟 **2個PowerShell窗口**：

#### 窗口1 - 啟動後端服務
```powershell
cd D:\program\twenty\packages\twenty-server
$env:NODE_ENV="development"; npx nest start --watch
```

#### 窗口2 - 啟動前端服務
```powershell
cd D:\program\twenty
npx nx start twenty-front
```

#### 可選: 窗口3 - 啟動Worker
```powershell
cd D:\program\twenty
npx nx worker twenty-server
```

### 啟動順序說明
1. **先啟動後端** - 等待看到 "Nest application successfully started"
2. **再啟動前端** - 等待看到 "Local: http://localhost:3001/"
3. **最後啟動Worker**（可選）- 用於處理背景任務

## 📋 日誌查看

### 後端日誌
- **位置**: 啟動後端的PowerShell窗口
- **內容**: 
  - API請求記錄
  - 資料庫連接狀態
  - 錯誤信息
  - GraphQL查詢日誌

**典型的成功啟動日誌**:
```
[Nest] 25828 - LOG [NestApplication] Nest application successfully started
[Nest] 25828 - LOG [GraphQLModule] Mapped {/graphql, POST} route
```

### 前端日誌
- **位置**: 啟動前端的PowerShell窗口
- **內容**:
  - Vite構建信息
  - 熱重載狀態
  - 編譯錯誤

**典型的成功啟動日誌**:
```
➜  Local:   http://localhost:3001/
[TypeScript] Found 0 errors. Watching for file changes.
```

### 瀏覽器日誌
1. 打開瀏覽器訪問 http://localhost:3001
2. 按 `F12` 打開開發者工具
3. 切換到 **Console** 標籤
4. 查看JavaScript錯誤和API調用日誌

### 系統狀態監控

#### 檢查所有Node.js進程
```powershell
Get-Process -Name node | Format-Table Id,ProcessName,CPU,WorkingSet -AutoSize
```

#### 檢查服務端口狀態
```powershell
# 檢查所有相關端口
netstat -an | findstr "3000\|3001\|5432\|6379"

# 分別檢查各服務
netstat -an | Select-String ":3000"  # 後端
netstat -an | Select-String ":3001"  # 前端
```

## 🌐 訪問地址

| 服務 | 地址 | 說明 |
|------|------|------|
| **前端CRM界面** | http://localhost:3001 | 主要的Web界面 |
| **後端API** | http://localhost:3000 | REST API端點 |
| **GraphQL Playground** | http://localhost:3000/graphql | GraphQL查詢界面 |
| **REST API文檔** | http://localhost:3000/rest | REST API端點 |

## 🔑 登入資訊

- **Email**: [email protected]
- **Password**: [email protected]

## 🔧 故障排除

### 常見問題及解決方案

#### 1. 後端無法啟動
**錯誤**: `NODE_ENV=development && nest start --watch` 命令失敗

**解決方案**:
```powershell
# 使用Windows PowerShell語法
cd D:\program\twenty\packages\twenty-server
$env:NODE_ENV="development"; npx nest start --watch
```

#### 2. 前端顯示 "Unable to Reach Back-end"
**原因**: 後端服務未啟動或未監聽端口3000

**檢查方法**:
```powershell
netstat -an | Select-String ":3000"
```

**解決方案**: 確保後端服務已成功啟動並監聽端口3000

#### 3. 資料庫連接失敗
**檢查PostgreSQL狀態**:
```powershell
netstat -an | Select-String ":5432"
```

**重置資料庫**:
```powershell
cd D:\program\twenty
npx nx database:reset twenty-server
```

#### 4. Redis連接失敗
**檢查Redis狀態**:
```powershell
netstat -an | Select-String ":6379"
```

#### 5. 端口被占用
**查找占用端口的進程**:
```powershell
netstat -ano | findstr ":3000"
netstat -ano | findstr ":3001"
```

**終止占用進程**:
```powershell
taskkill /PID <進程ID> /F
```

### 完全重啟系統

如果遇到複雜問題，可以完全重啟：

```powershell
# 1. 停止所有Node.js進程
taskkill /F /IM node.exe

# 2. 檢查端口是否釋放
netstat -an | findstr "3000\|3001"

# 3. 重新啟動服務
.\start-twenty.bat
```

## 🛑 停止服務

### 優雅停止
在各個PowerShell窗口中按 `Ctrl+C`

### 強制停止
```powershell
# 停止所有Node.js進程
taskkill /F /IM node.exe

# 驗證進程已停止
Get-Process -Name node -ErrorAction SilentlyContinue
```

## 📝 開發工作流程

### 日常開發流程
1. **啟動服務**: 執行 `.\start-twenty.bat`
2. **開發代碼**: 修改 `packages/` 目錄下的源碼
3. **查看變更**: 前端和後端都支持熱重載
4. **查看日誌**: 在對應的PowerShell窗口中查看
5. **測試功能**: 在瀏覽器中測試修改
6. **停止服務**: 按 `Ctrl+C` 或執行 `taskkill`

### 代碼修改位置
- **前端代碼**: `packages/twenty-front/`
- **後端代碼**: `packages/twenty-server/`
- **共享代碼**: `packages/twenty-shared/`
- **UI組件**: `packages/twenty-ui/`

## 🔍 進階調試

### 查看詳細日誌
```powershell
# 啟動時添加詳細輸出
npx nx start twenty-server --verbose
npx nx start twenty-front --verbose
```

### 資料庫調試
```powershell
# 連接到PostgreSQL
psql -h localhost -p 5432 -U postgres -d default

# 查看資料表
\dt

# 查看特定資料表
SELECT * FROM "user" LIMIT 5;
```

### GraphQL調試
訪問 http://localhost:3000/graphql 使用GraphQL Playground進行API測試

---

## 📞 支援

如果遇到問題，可以：
1. 檢查本文檔的故障排除章節
2. 查看Twenty官方文檔: https://twenty.com/developers
3. 查看GitHub Issues: https://github.com/twentyhq/twenty/issues

---

**文檔版本**: v1.0  
**最後更新**: 2025-07-21  
**適用系統**: Windows 10/11 + PowerShell
