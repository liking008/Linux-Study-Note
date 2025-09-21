# Linux 与 Termux 简介

## GNU/Linux 与 Termux 的区别

GNU/Linux 是由 Linux 内核、gcc 编译器、glibc 等自由软件组成的操作系统，目录结构遵循 FHS（Filesystem Hierarchy Standard）标准。常见发行版有 Ubuntu、Debian、CentOS、RHEL 等。

Termux 是 Android 平台上的终端模拟器，集成了大量 Linux 命令行工具，目标是在移动设备上提供类 Linux 体验，无需 root 权限。

Termux **不遵循** FHS 标准，常见的 `/bin`、`/etc`、`/usr`、`/tmp` 等目录在 Termux 中不存在。所有程序和数据都安装在：

```
/data/data/com.termux/files/usr
```

该路径称为 `$PREFIX`，是 Termux 的环境变量。

---

## Linux 目录结构简述

| 目录         | 说明                                                         |
| ------------ | ------------------------------------------------------------ |
| /bin         | 常用二进制命令                                               |
| /boot        | 启动相关文件                                                 |
| /dev         | 设备文件                                                     |
| /etc         | 系统配置文件                                                 |
| /home        | 用户主目录（Termux 为 `/data/data/com.termux/files/home`）   |
| /lib         | 系统基本共享库                                               |
| /media       | 可移动设备挂载点                                             |
| /mnt         | 临时挂载点                                                   |
| /opt         | 第三方软件                                                   |
| /proc        | 内核和进程信息（虚拟文件系统）                               |
| /root        | root 用户主目录                                              |
| /sbin        | 系统管理命令                                                 |
| /srv         | 服务相关数据                                                 |
| /sys         | 内核设备树                                                   |
| /tmp         | 临时文件                                                     |
| /usr         | 用户应用和资源                                               |
| /var         | 可变数据（日志等）                                           |
| /run         | 系统运行时数据                                               |

---

## /usr 及其子目录详解

`/usr` 目录用于存放用户级应用程序和共享资源，是 Linux 系统中最庞大的目录之一。其下常见子目录有：

| 目录                | 说明                                                         |
|---------------------|--------------------------------------------------------------|
| /usr/bin            | 大多数用户命令的二进制文件                                   |
| /usr/sbin           | 系统管理员命令                                               |
| /usr/lib            | 用户级程序的共享库                                           |
| /usr/include        | C/C++ 头文件                                                 |
| /usr/share          | 架构无关的共享数据（如字体、图标、locale、man 手册等）       |
| /usr/share/applications | 桌面环境下的 `.desktop` 启动器文件                      |
| /usr/share/fonts    | 系统字体                                                     |
| /usr/share/man      | 联机帮助文档（man 手册）                                     |
| /usr/src            | 源代码（如内核源码 `/usr/src/linux-*`）                      |
| /usr/local          | 本地安装的软件及资源（用户自行编译或第三方安装的软件）       |
| /usr/local/bin      | 用户本地安装的可执行文件                                     |
| /usr/local/lib      | 用户本地安装的库文件                                         |
| /usr/local/share    | 用户本地安装的共享数据                                       |
| /usr/local/include  | 用户本地安装的头文件                                         |

### 说明

- `/usr/local` 主要用于存放**手动编译安装**的软件，与系统包管理器安装的软件分开，便于管理和卸载。
- `.desktop` 文件用于桌面环境菜单和应用快捷方式。
- 字体一般位于 `/usr/share/fonts`，也可在 `~/.fonts` 下存放用户自定义字体。
- 内核源码和第三方驱动源码常见于 `/usr/src`。
- man 手册页分布在 `/usr/share/man` 下的不同子目录（如 man1、man5 等）。
- 自己编译的软件一般安装到 `/usr/local/bin`、`/usr/local/lib` 等，避免覆盖系统自带文件。

---

如需进一步了解各目录作用，可通过 `man hier` 查看官方说明