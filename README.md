<div align="center">

# USB-Blaster Driver for Windows 11

**Altera / Intel USB-Blaster 驱动包 — 解决 Windows 11 (24H2+) 下驱动签名问题**

![Driver](https://img.shields.io/badge/driver-2.12.28-blue.svg)
![Windows](https://img.shields.io/badge/Windows-7%20%7C%2010%20%7C%2011-success.svg)
![License](https://img.shields.io/badge/license-FTDI%20%2F%20Intel-important.svg)
![Architecture](https://img.shields.io/badge/arch-x32%20%7C%20x64-lightgrey.svg)

</div>

---

## 简介

本仓库提供 **Altera / Intel USB-Blaster** 下载器在 **Windows 11（24H2+）** 下可用的驱动包。

Quartus II 13.1 自带的 USB-Blaster 驱动使用 2009 年的 FTDI FTDIBUS 2.04.16，依赖 VeriSign 2009/2011 旧交叉证书签名。Windows 11 24H2 及以后版本的代码完整性策略不再放行这类旧签名内核驱动，导致设备管理器报 **代码 39**（黄色感叹号），驱动加载返回 `0xC000026C`。

本包取自 Intel Quartus 17.1+ 附带的驱动，使用 FTDI Symantec EV 证书 + Intel Corporation 签名，可正常通过 Windows 11 代码完整性检查。

### 适用硬件

|VID / PID|设备名称|
|---|---|
|`USB\VID_09FB&PID_6001`|Altera USB-Blaster|
|`USB\VID_09FB&PID_6002`|Altera Cubic Cyclonium|
|`USB\VID_09FB&PID_6003`|Altera Nios II Evaluation Board|
|`USB\VID_09FB&PID_6004`|Altera Cyclone III EP3C25 Starter Kit|
|`USB\VID_09FB&PID_6005`|Altera Cyclone III EP3C120 Development Kit|
|`USB\VID_09FB&PID_6006`|Altera Stratix III EP3SL150 Development Kit|
|`USB\VID_09FB&PID_6007`|Altera Stratix III EP3SL340 Development Kit|
|`USB\VID_09FB&PID_6008`|Altera Nios Embedded Evaluation Kit|
|`USB\VID_09FB&PID_6009`|Altera Nios Development Kit, Cyclone III Edition|

涵盖原厂及克隆 USB-Blaster 下载器。

---

## 目录结构

```text
usb-blaster-driver/
├── usbblstr.inf            # 驱动安装信息文件
├── usbblstr.cat            # 数字签名目录（Intel Corporation 签名）
├── license.txt             # FTDI 许可说明
├── 安装说明.txt             # 详细中文安装指南
├── 安装驱动.bat            # 一键安装脚本（需管理员权限）
├── 校验值.txt              # 文件 SHA256 校验值
├── x32/                    # 32 位驱动
│   ├── usbblstr.sys        #   内核驱动（FTDI 2.12.28）
│   ├── usbblstr32.dll      #   D2XX 接口库
│   ├── usbblstrui.dll      #   设备属性页
│   └── usbblstrlang.dll    #   语言资源
├── x64/                    # 64 位驱动
│   ├── usbblstr.sys        #   内核驱动（FTDI 2.12.28）
│   ├── usbblstr64.dll      #   D2XX 接口库
│   ├── usbblstrui.dll      #   设备属性页
│   └── usbblstrlang.dll    #   语言资源
├── README.md
└── .gitignore
```

---

## 快速开始

### 1. 下载驱动包

```powershell
git clone https://github.com/by-Aquarius/usb-blaster-driver.git
```

或点击仓库页面 **Code → Download ZIP** 下载压缩包后解压。

### 2. 安装驱动

**方法 1 — 一键安装（推荐）**

双击 `安装驱动.bat`，UAC 弹窗点"是"。

**方法 2 — 手动安装**

右键 `usbblstr.inf` → 安装。

**方法 3 — 命令行**

```powershell
# 管理员权限
pnputil /add-driver "usbblstr.inf" /install
```

### 3. 验证

打开设备管理器，确认「Altera USB-Blaster」无黄色感叹号。

```powershell
# 路径按实际 Quartus 安装位置调整
<Quartus安装目录>\quartus\bin64\jtagconfig.exe
```

正常输出示例：

```
1) USB-Blaster [USB-0]
   020F10DD   EP3C(10|5)/EP4CE(10|6)
```

---

## 技术背景

### 为什么旧驱动不能用？

| 项目 | 旧驱动（Quartus 13.1 自带） | 本驱动包 |
|---|---|---|
| 驱动版本 | FTDI FTDIBUS 2.04.16 | FTDI FTDIBUS 2.12.28 |
| 签名证书 | VeriSign 2009/2011 交叉证书 | FTDI Symantec EV 证书 |
| CAT 签名 | — | Intel Corporation (Intel FPGA) |
| Windows 11 24H2 | 不通过代码完整性检查 | 正常通过 |

Windows 11 24H2+ 的代码完整性策略不再信任旧版 VeriSign 交叉签名，导致旧驱动加载失败（事件日志 `0xC000026C`，代码完整性日志"未满足 Authenticode 签名要求"）。

### 驱动来源

本包取自 Intel Quartus 17.1+ 官方驱动，二进制文件为 Intel / FTDI 原厂签名，未做任何修改。

---

## 安全提示

- **请勿修改包内任何二进制文件**（`.sys` / `.dll` / `.cat` / `.inf`），改动会导致签名校验失败、驱动无法加载。
- 如需卸载驱动，管理员命令行执行 `pnputil /delete-driver oemXX.inf /uninstall`（`oemXX.inf` 为系统分配编号，可通过 `pnputil /enum-drivers` 查找）。
- 建议安装后使用 `校验值.txt` 中的 SHA256 值验证文件完整性。

---

## 文件校验

安装后可对照 `校验值.txt` 中的 SHA256 值验证文件完整性：

```powershell
Get-FileHash usbblstr.sys -Algorithm SHA256
```

---

## 许可

驱动及相关代码版权归 FTDI / Intel Corporation 所有，使用须遵守 [license.txt](license.txt) 中的 FTDI 许可协议。

本仓库仅做驱动分发包存档，不包含任何自行修改的二进制文件。

---

## 致谢

- [FTDI](https://www.ftdichip.com/) — 驱动原始开发者
- [Intel FPGA](https://www.intel.com/content/www/us/en/products/details/fpga.html) — 驱动签名及分发
- 所有遇到 Windows 11 USB-Blaster 驱动问题的 FPGA 开发者
