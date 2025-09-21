# Linux Shell 编程基础

## Shell 与 Bash 简介

Shell 是 Linux 下的命令行解释器，Bash（Bourne Again Shell）是最常用的 Shell 之一。Shell 脚本可自动化批量任务、系统管理和运维工作。

---

## 变量与数据类型

### 变量定义与使用

```bash
变量名=值
echo $变量名
```
- 变量名与等号之间不能有空格。
- 变量默认全为字符串类型。

### 常见系统变量

| 变量   | 含义                       |
|--------|----------------------------|
| `$PATH`| 可执行文件搜索路径         |
| `$PWD` | 当前工作目录               |
| `$HOME`| 当前用户的家目录           |
| `$USER`| 当前用户名                 |
| `$SHELL`| 当前使用的 shell 路径     |
| `$LANG`| 当前语言/区域设置          |
| `$?`   | 上一个命令的退出状态码     |

示例：
```bash
echo $PATH
echo $PWD
echo $HOME
```

### 变量作用域

- **局部变量**：只在当前 shell 或脚本中有效。
- **环境变量**：使用 `export` 导出，子进程可见。

```bash
export PATH=$PATH:/opt/bin
```

### 数组声明

```bash
arr=(a b c)
echo ${arr[0]}
echo ${arr[@]}
```

#### 关联数组

Bash 4.0+ 支持关联数组（键值对）：

```bash
declare -A map
map[foo]=bar
map[hello]=world
echo ${map[foo]}
echo ${!map[@]}   # 所有键
echo ${map[@]}    # 所有值
```

---

## 输入输出与格式化

### 读取输入：`read`

```bash
read 变量名
read -p "请输入姓名：" name
echo "你好, $name"
```

### 输出：`echo`

```bash
echo "Hello, world"
echo -e "第一行\n第二行"
```

### 格式化输出：`printf`

```bash
printf "姓名：%s\t年龄：%d\n" "张三" 18
```

---

## 条件与分支结构

### if/elif/else

```bash
if [ 条件 ]; then
    命令
elif [ 条件 ]; then
    命令
else
    命令
fi
```
示例（字符串比较）：
```bash
if [ "$USER" = "root" ]; then
    echo "管理员"
else
    echo "普通用户"
fi
```
示例（整数比较，使用 $(( ))）：
```bash
a=5
b=3
if (( a > b )); then
    echo "a 大于 b"
fi
```
或
```bash
if [ $a -gt $b ]; then
    echo "a 大于 b"
fi
```

#### 常见 test/[] 比较内容

- 整数比较：`-eq` 等于，`-ne` 不等于，`-gt` 大于，`-lt` 小于，`-ge` 大于等于，`-le` 小于等于
- 字符串比较：`=` 相等，`!=` 不等，`-z` 空字符串，`-n` 非空字符串
- 文件判断：
  - `-e 文件`：存在
  - `-f 文件`：存在且为普通文件
  - `-d 目录`：存在且为目录
  - `-s 文件`：存在且非空
  - `-r/-w/-x 文件`：可读/写/执行

示例：
```bash
if [ -e /etc/passwd ]; then
    echo "文件存在"
fi
if [ -d /tmp ]; then
    echo "目录存在"
fi
if [ -z "$str" ]; then
    echo "字符串为空"
fi
```

### case 语句

用于多分支条件判断，适合处理多种可能的值。

```bash
case 变量 in
    模式1)
        命令
        ;;
    模式2)
        命令
        ;;
    *)
        默认命令
        ;;
esac
```

示例：
```bash
read -p "请输入星期几（1-7）: " day
case $day in
    1)
        echo "星期一"
        ;;
    2)
        echo "星期二"
        ;;
    3)
        echo "星期三"
        ;;
    4)
        echo "星期四"
        ;;
    5)
        echo "星期五"
        ;;
    6|7)
        echo "周末"
        ;;
    *)
        echo "输入有误"
        ;;
esac
```

---

## 循环结构

### for 循环（列表型）

```bash
for 变量 in 列表; do
    命令
done
```
示例：
```bash
for i in 1 2 3; do
    echo $i
done
```

### for 循环（C语言型）

```bash
for ((i=0; i<5; i++)); do
    echo $i
done
```

### while 循环

```bash
while [ 条件 ]; do
    命令
done
```

---

## 函数定义与参数、返回值

```bash
myfunc() {
    echo "Hello $1"
    return 123
}
myfunc world      # $1 为第1个参数
echo $?           # 获取函数返回值（0~255）
```

- `$1` `$2` ...：函数或脚本的第1、第2个参数
- `$@`：所有参数
- `return` 只能返回 0~255，超出会取模。更复杂的返回建议用 echo 输出并用命令替换获取。

#### 脚本参数

```bash
echo "脚本名: $0"
echo "第一个参数: $1"
echo "参数个数: $#"
echo "所有参数: $@"
```

#### 函数参数调用

```bash
foo() {
    echo "第一个参数: $1"
    echo "所有参数: $@"
}
foo a b c
```

---

## 内部命令与外部命令

- **内部命令**：由 shell 内部实现（如 cd、echo、export）
- **外部命令**：系统中的可执行文件（如 ls、grep、awk）

可用 `type 命令名` 判断命令类型。

---

## 特殊格式与展开

- `${}`：变量引用、参数展开
  ```bash
  echo ${HOME}
  ```
- `` `命令` `` 或 `$(命令)`：命令替换
  ```bash
  files=$(ls /etc)
  echo $files
  ```
- `$((表达式))`：算术运算和整数比较
  ```bash
  echo $((1+2))
  if (( a > b )); then ...; fi
  ```
- `"$@"`：所有参数列表
- `"$#"`：参数个数

---

## which 命令

查找可执行文件路径。

```bash
which ls
```

---

## Bash 脚本基础

### 脚本文件与 Shebang

- 脚本文件通常以 `.sh` 结尾。
- 第一行建议加上 shebang，指定解释器：
  ```bash
  #!/bin/bash
  ```

### 交互模式与脚本模式

- **交互模式**：直接在终端输入命令并执行。
- **脚本模式**：将命令写入脚本文件，批量执行。

### 脚本中的变量作用域

- 脚本中定义的变量只在当前 shell 或子进程中有效。
- 通过 `export` 导出的变量，子进程可见，但**子进程的变量不会影响父进程**。

---

## 脚本执行方式

1. 赋予执行权限后直接运行：
   ```bash
   chmod +x example.sh
   ./example.sh
   ```
2. 使用 bash 解释器执行：
   ```bash
   bash example.sh
   ```
3. 使用 `source` 或 `.` 让脚本在当前 shell 环境中执行（变量会影响当前 shell）：
   ```bash
   source example.sh
   . example.sh
   ```

---

## 标准输入、输出与重定向

- **标准输入（stdin）**：通常为键盘，文件描述符0
- **标准输出（stdout）**：通常为屏幕，文件描述符1
- **标准错误（stderr）**：错误输出，文件描述符2

### 重定向

- 输出重定向（覆盖/追加）：
  ```bash
  echo "hello" > file.txt    # 覆盖写入
  echo "world" >> file.txt   # 追加写入
  ```
- 输入重定向：
  ```bash
  wc -l < file.txt
  ```
- 错误输出重定向：
  ```bash
  ls not_exist 2> error.log
  ```

### 管道

- 管道 `|` 用于将前一个命令的输出作为下一个命令的输入：
  ```bash
  cat file.txt | grep "pattern" | sort | uniq
  ```

---

> 掌握 Shell 基础语法、输入输出和脚本执行方式，是高效使用 Linux 和自动化运维