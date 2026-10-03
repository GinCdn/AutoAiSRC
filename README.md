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

> **下载**：请到 [Releases](https://github.com/GinCdn/AutoAiSRC/releases) 下载对应平台的压缩包（`AutoAiSRC-vX.Y.Z-linux-amd64.tar.gz` / `AutoAiSRC-vX.Y.Z-windows-amd64.zip`），解压即得下表全部文件；Release 页同时提供裸二进制 `aisrc` / `aisrc.exe` 供脚本化部署。

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

#### Linux · 宝塔面板安装

前提：已安装宝塔面板（[bt.cn](https://www.bt.cn)）。

1. **安装 MySQL**：宝塔 → 软件商店 → 搜索 `MySQL` → 安装 5.7（或 8.0）；
2. **建库**：数据库 → 添加数据库，数据库名 `aisrc`、用户名/密码自定，字符集选 `utf8mb4`；
3. **上传程序**：文件 → 进入 `/www`（自建目录如 `/www/AutoAiSRC`）→ 上传发行包并解压，确认目录内有 `aisrc`、`web/`、`config.example.yaml`；
4. **生成配置**：宝塔终端（或 SSH）执行：

   ```bash
   cd /www/AutoAiSRC
   cp config.example.yaml config.yaml
   vi config.yaml
   # mysql.host 填 127.0.0.1（宝塔 MySQL 装在本机）
   # mysql.user / mysql.password 填第 2 步建的账号
   # token.username / token.password 设置登录面板的账号密码
   chmod +x aisrc start.sh
   ```

5. **进程守护**：软件商店 → 安装 `进程守护管理器（Supervisor）` → 添加守护进程：
   - 名称：`AutoAiSRC`
   - 启动命令：`/www/AutoAiSRC/aisrc`
   - 运行目录：`/www/AutoAiSRC`
   - 启动后确保状态为 `RUNNING`，日志无报错；
6. **放行端口**：安全 → 放行端口 `8080`（同时在云服务商安全组放行）；
7. **访问**：浏览器 `http://服务器IP:8080` 登录；
8. **可选 · 域名与 HTTPS**：网站 → 添加站点（绑定域名，无需 PHP）→ 设置 → 反向代理 → 目标 `http://127.0.0.1:8080` → 再用「SSL」签发 Let's Encrypt 证书。

#### Linux · 1Panel 安装

前提：已安装 1Panel（[1panel.cn](https://www.1panel.cn)，docker 架构）。

**方式 A：容器编排（推荐，与 docker-compose 安装等效）**

1. 文件 → 上传发行包到 `/opt/AutoAiSRC` 并解压；
2. 生成配置：

   ```bash
   cd /opt/AutoAiSRC
   cp config.example.yaml config.yaml
   vi config.yaml
   # 关键：mysql.host 改为 mysql（编排内服务名），其余同上
   ```

3. 容器 → 编排 → 创建编排 → 选择 `/opt/AutoAiSRC` 目录（自动识别 `docker-compose.yml`）→ 确认启动；
4. 容器页确认 `aisrc-mysql` 与 `aisrc-server` 均为运行中，日志无报错；
5. 主机 → 防火墙 → 放行 `8080`（云安全组同步放行）→ 访问 `http://服务器IP:8080`。

**方式 B：二进制 + systemd（不用容器跑应用）**

1. 应用商店 → 安装 `MySQL 5.7`（1Panel 会映射 3306 到宿主机）→ 数据库页创建 `aisrc` 库（utf8mb4）；
2. 文件 → 上传发行包到 `/opt/AutoAiSRC` 解压，按上文修改 `config.yaml`（mysql.host 填 `127.0.0.1`）；
3. 主机 → 终端执行：

   ```bash
   chmod +x /opt/AutoAiSRC/aisrc
   cat > /etc/systemd/system/autuaisrc.service <<'EOF'
   [Unit]
   Description=AutoAiSRC Server
   After=network.target

   [Service]
   WorkingDirectory=/opt/AutoAiSRC
   ExecStart=/opt/AutoAiSRC/aisrc
   Restart=always
   RestartSec=5

   [Install]
   WantedBy=multi-user.target
   EOF
   systemctl daemon-reload && systemctl enable --now autuaisrc
   systemctl status autuaisrc   # 确认 active (running)
   ```

4. 主机 → 防火墙放行 `8080`；网站 → 创建网站（静态）→ 反向代理 `http://127.0.0.1:8080` 可挂域名与 HTTPS。

#### Windows

1. 安装 MySQL 5.7+；
2. 复制 `config.example.yaml` 为 `config.yaml`，编辑数据库连接与登录账号；
3. 双击 `start.bat`（或命令行运行 `aisrc.exe`）；
4. 浏览器访问 `http://127.0.0.1:8080` 登录。

#### 默认管理员账号

| 项 | 值 |
|---|---|
| 账号 | `admin`（`config.yaml` 未配置 `token.username` 时的默认值） |
| 密码 | `123456`（模板默认值，见 `config.example.yaml` 的 `token.password`） |

> ⚠️ **安全警告**：默认密码为弱口令，公网部署**务必在首次登录后立即修改**（系统设置中修改），并同时更换 `token.secret` 为不少于 32 位的随机串——该密钥用于签发登录令牌，使用公开默认值等于 anyone 可伪造登录态。

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

> **Download**: grab the archive for your platform from the [Releases](https://github.com/GinCdn/AutoAiSRC/releases) page (`AutoAiSRC-vX.Y.Z-linux-amd64.tar.gz` / `AutoAiSRC-vX.Y.Z-windows-amd64.zip`); extracting it yields all files listed below. Bare binaries (`aisrc` / `aisrc.exe`) are also attached for scripted deployments.

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

#### Linux · Server Management Panels (BT Panel / 1Panel)

For users in China who prefer a web-based server panel, step-by-step tutorials for **宝塔面板 (BT Panel)** and **1Panel** are provided in the Chinese section above (「Linux · 宝塔面板安装」 / 「Linux · 1Panel 安装」). In short:

- **BT Panel**: install MySQL from the App Store, create the `aisrc` database (utf8mb4), upload the package to `/www/AutoAiSRC`, generate `config.yaml`, then keep the binary alive with the Supervisor add-on and open port 8080;
- **1Panel (Docker-based)**: Option A — deploy the bundled `docker-compose.yml` via Container → Orchestration (set `mysql.host` to `mysql`); Option B — run the binary under systemd and reverse-proxy it through the website module.

#### Windows

1. Install MySQL 5.7+;
2. Copy `config.example.yaml` to `config.yaml` and edit the database settings and login credentials;
3. Double-click `start.bat` (or run `aisrc.exe` from a terminal);
4. Visit `http://127.0.0.1:8080` and log in.

#### Default Administrator Account

| Item | Value |
|---|---|
| Username | `admin` (fallback when `token.username` is not set in `config.yaml`) |
| Password | `123456` (template default, see `token.password` in `config.example.yaml`) |

> ⚠️ **Security warning**: the default password is weak. On any public deployment **change it immediately after the first login** (via System Settings), and replace `token.secret` with a random string of at least 32 characters — this key signs the login tokens; leaving the public default means anyone can forge a session.

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
