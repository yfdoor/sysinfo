#!/bin/bash

# 获取系统信息
host_name=$(hostname)
architecture=$(uname -m)
kernel_version=$(uname -r)
uptime=$(uptime -p)
os_version=$(grep "PRETTY_NAME" /etc/os-release | cut -d "=" -f 2 | tr -d '"')

# 获取CPU信息
cpu_info=$(lscpu | grep "Model name" | awk -F ":" '{print $2}' | sed 's/^[ \t]*//')
cpu_vendor=$(lscpu | grep "Vendor ID" | awk -F ":" '{print $2}' | sed 's/^[ \t]*//')
cpu_cores=$(nproc)

# 获取内存信息
memory_total=$(free -h | awk '/Mem/ {print $2}')
memory_usage=$(free | awk '/Mem/ {printf "%.1f", $3/$2 * 100.0}')

# 获取硬盘信息
disk_info=$(lsblk -o SIZE,TYPE -b --nodeps --noheadings | awk '!/part|loop|nvme|rom/ {sum += $1} END {printf "%.1f", sum / (1024^3)}')
disk_usage=$(df -h --total | awk 'END{print $(NF-1)}')
partition_info=$(lsblk -o NAME,SIZE,MOUNTPOINT | grep -v "loop")

# 获取网络信息
ip_address=$(dig +short myip.opendns.com @resolver1.opendns.com)

# 显示系统信息
echo "系统信息:"
echo "----------------------------------------"
echo "主机名称: $host_name"
echo "操作系统: $os_version"
echo "系统架构: $architecture"
echo "内核版本: $kernel_version"
echo "开机时间: $uptime"
echo ""

# 显示CPU信息
echo "CPU信息:"
echo "----------------------------------------"
echo "厂商: $cpu_vendor"
echo "型号: $cpu_info"
echo "核心: $cpu_cores"
echo ""

# 显示内存信息
echo "内存信息:"
echo "----------------------------------------"
echo "总内存: $memory_total"
echo "使用率: $memory_usage%"
echo ""

# 显示硬盘信息
echo "硬盘信息:"
echo "----------------------------------------"
echo "分区信息:"
echo "$partition_info"
echo "总空间: $disk_info"
echo "使用率: $disk_usage"
echo ""

# 显示网络信息
echo "网络信息:"
echo "----------------------------------------"
echo "公网 IP: $ip_address"
echo ""
