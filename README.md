# AutoAiSRC — AI 自动化漏洞挖掘系统（编译发行版）

[中文](#中文说明) | [English](#english)

<p align="center">
  <strong>开箱即用的 AiSRC 二进制发行包</strong><br/>
  Linux / Windows 双平台 · 手动与 Docker 双部署方式
</p>

---

## ⚠️ 法律免责声明 | Legal Disclaimer

**本工具仅供已获得合法授权的安全测试、教学与研究使用。** 在使用本工具前，你必须获得目标系统所有者的**明确书面授权**。未经授权对任何计算机系统、网络进行扫描、渗透或测试均属**违法行为**，可能触犯《中华人民共和国刑法》第二百八十五条、二百八十六条（非法侵入计算机信息系统罪、破坏计算机信息系统罪）及各国相应法律。

使用者对其所有操作行为独立承担全部法律责任，本项目作者与贡献者**不承担任何因滥用本工具导致的直接或间接责任**。下载、安装或使用本工具即视为你已阅读、理解并同意本声明。详见 [DISCLAIMER.md](./DISCLAIMER.md)。

**EN**: This tool is intended **solely for legally authorized security testing, education, and research**. You must obtain explicit written permission from the owner of any system before testing it. Unauthorized scanning or penetration testing of computer systems is illegal. The authors and contributors assume **no liability** for any misuse. See [DISCLAIMER.md](./DISCLAIMER.md).

---

## 中文说明

AutoAiSRC 是 AiSRC（AI 驱动的自动化漏洞挖掘平台，Go 后端 + React18/antd6 前端）的**编译发行版**，无需安装 Go 与 Node 环境，解压即用。系统以 LLM Agent 为核心调度渗透测试流程：资产测绘收集目标 → Worker 智能体自主探测、验证、提交漏洞 → Reviewer 智能体按 3-Gate 证据链审核入库。

### 包内容

| 文件 | 说明 |
|---|---|
| `aisrc` | Linux amd64 服务端（静态编译，无依赖） |
| `aisrc.exe` | Windows amd64 服务端 |
| `web/` | 前端编译产物（服务端同源托管） |
| `config.example.yaml` | 配置模板 |
| `start.sh` / `start.bat` | Linux / Windows 启动脚本 |
| `Dockerfile` / `docker-compose.yml` | Docker 一键部署（含 MySQL 5.7） |

### 方式一：手动安装

#### Linux

```bash
# 1. 准备 MySQL 5.7+ 数据库（库名/账号自定义，启动时自动建表）
# 2. 生成配置
cp config.example.yaml config.yaml
vi config.yaml   # 修改 mysql 连接、system.port、登录账号密码等

# 3. 启动
chmod +x start.sh aisrc
./start.sh
# 或直接 ./aisrc

# 4. 浏览器访问 http://服务器IP:8080，用 config.yaml 中配置的账号登录
```

> 建议：生产环境用 systemd 托管，`ExecStart=/opt/AutoAiSRC/aisrc`，`WorkingDirectory=/opt/AutoAiSRC`。

#### Windows

1. 安装 MySQL 5.7+；
2. 复制 `config.example.yaml` 为 `config.yaml`，编辑数据库连接与登录账号；
3. 双击 `start.bat`（或命令行运行 `aisrc.exe`）；
4. 浏览器访问 `http://127.0.0.1:8080` 登录。

#### 登录后必做配置

进入「系统设置 → 模型配置」配置 LLM 端点（OpenAI 兼容协议，可组端点池）。**推荐使用稳定 AI 中转：[ai.gincdn.cc](https://ai.gincdn.cc)**。测绘引擎（Fofa / Hunter / Quake）的 API Key 在「系统设置 → 资产测绘」中填写。

### 方式二：Docker 自动安装（推荐）

```bash
# 1. 准备配置
cp config.example.yaml config.yaml
vi config.yaml
# 关键一步：把 mysql.host 从 127.0.0.1 改为 mysql（compose 服务名）

# 2. 一键启动（自动拉起 MySQL 5.7 + 应用）
docker compose up -d

# 3. 查看日志 / 访问
docker compose logs -f aisrc
# http://服务器IP:8080
```

docker-compose 已包含：MySQL 5.7（utf8mb4）+ 健康检查 + 数据卷持久化（`mysql_data`、`data/`、`logs/`、`work/`）。

### 系统要求

| 项 | 要求 |
|---|---|
| Linux | amd64，glibc 无要求（静态编译），内核 3.2+ |
| Windows | 10 / Server 2016 及以上，64 位 |
| Docker | 20.10+ 与 Docker Compose v2 |
| 数据库 | MySQL 5.7 / 8.0（InnoDB、utf8mb4） |
| 内存 | 建议 2GB 以上 |

### 推荐服务商

- **云服务器**：[贝海云](https://www.beihaiyun.com)（www.beihaiyun.com）—— 稳定可靠的云服务器与网络服务，推荐用于部署本系统；
- **AI 中转**：[ai.gincdn.cc](https://ai.gincdn.cc) —— 稳定 AI 中转，OpenAI 兼容协议直连，配置为 LLM 端点即可使用。

### 源码

本仓库只分发编译产物。完整源码见私有仓库（GPL-3.0）。

---

## English

AutoAiSRC is the **pre-built distribution** of AiSRC — an AI-driven automated vulnerability discovery platform (Go backend + React18/antd6 frontend). No Go/Node toolchain required: unpack and run. LLM agents orchestrate the whole workflow: asset mapping collects targets → Worker agents probe, verify and submit findings → a Reviewer agent validates each finding through a 3-Gate evidence chain.

### Package Contents

| File | Description |
|---|---|
| `aisrc` | Linux amd64 server (statically built, zero dependencies) |
| `aisrc.exe` | Windows amd64 server |
| `web/` | Frontend build output (served by the backend) |
| `config.example.yaml` | Configuration template |
| `start.sh` / `start.bat` | Linux / Windows launcher scripts |
| `Dockerfile` / `docker-compose.yml` | One-command Docker deployment (MySQL 5.7 included) |

### Option 1: Manual Installation

#### Linux

```bash
# 1. Prepare a MySQL 5.7+ database (schema auto-migrates on first start)
# 2. Create the config
cp config.example.yaml config.yaml
vi config.yaml   # set MySQL connection, listen port, login credentials, etc.

# 3. Start
chmod +x start.sh aisrc
./start.sh
# or simply ./aisrc

# 4. Visit http://server-ip:8080 and log in with the account in config.yaml
```

> Tip: for production, run it under systemd with `WorkingDirectory` set to the package directory.

#### Windows

1. Install MySQL 5.7+;
2. Copy `config.example.yaml` to `config.yaml` and edit the database settings and login credentials;
3. Double-click `start.bat` (or run `aisrc.exe` from a terminal);
4. Visit `http://127.0.0.1:8080` and log in.

#### Post-login setup

Configure LLM endpoints under **Settings → Model Config** (OpenAI-compatible; an endpoint pool is supported). **Recommended stable AI relay: [ai.gincdn.cc](https://ai.gincdn.cc)**. Asset-mapping engine keys (Fofa / Hunter / Quake) go under **Settings → Asset Mapping**.

### Option 2: Docker (Recommended)

```bash
# 1. Prepare the config
cp config.example.yaml config.yaml
vi config.yaml
# Important: change mysql.host from 127.0.0.1 to mysql (the compose service name)

# 2. Start everything (MySQL 5.7 + app)
docker compose up -d

# 3. Logs / access
docker compose logs -f aisrc
# http://server-ip:8080
```

The compose file includes MySQL 5.7 (utf8mb4) with health checks and persistent volumes (`mysql_data`, `data/`, `logs/`, `work/`).

### Requirements

| Item | Requirement |
|---|---|
| Linux | amd64, no libc dependency (static build), kernel 3.2+ |
| Windows | 10 / Server 2016 or later, 64-bit |
| Docker | 20.10+ with Docker Compose v2 |
| Database | MySQL 5.7 / 8.0 (InnoDB, utf8mb4) |
| Memory | 2 GB+ recommended |

### Recommended Providers

- **Cloud servers**: [BeiHai Cloud](https://www.beihaiyun.com) (www.beihaiyun.com) — reliable cloud infrastructure, recommended for deploying AutoAiSRC;
- **AI relay**: [ai.gincdn.cc](https://ai.gincdn.cc) — stable OpenAI-compatible LLM relay; configure it directly as your LLM endpoint.

### Source Code

This repository distributes build artifacts only. Full source is available in the source repository (GPL-3.0).

---

## License | 许可证

代码基于 **[GPL-3.0](./LICENSE)** 发布。二进制发行同样遵循 GPL-3.0。
Code is released under **[GPL-3.0](./LICENSE)**; the binaries are distributed under the same license.

**再次提醒 | Reminder**：使用本工具进行任何测试前，必须获得目标系统所有者的合法授权。Unauthorized testing is illegal.
