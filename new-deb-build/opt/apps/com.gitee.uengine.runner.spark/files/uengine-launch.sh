#!/bin/bash
FILE=/usr/bin/uengine
if [ -f "$FILE" ]; then
	echo "$FILE 存在，正常打开菜单"
	/usr/bin/uengine launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity
else
	echo "$FILE 不存在，没有安装 UEngine，询问是否安装 UEngine"
	# 读取系统版本
	version=`sed -n '/^NAME/s/NAME="//Ip' /etc/os-release | sed -n 's/\"//Ip'`
	declare -l versionLower=$version
	echo "系统：$version"
	if [ "$versionLower" = "deepin" ] || [ "$versionLower" = "uos" ]; then
		echo "此系统为 Deepin/UOS，使用 apt 安装"
		zenity --question --text="您还未安装 UEngine，是否现在安装？" --no-wrap
		if [[ $? = 0 ]]; then
			deepin-terminal -C "pkexec apt install uengine"
		fi
	else
		echo "非 Deepin/UOS 系统，使用 shenmo 提供的脚本安装"
		zenity --question --text="您还未安装 UEngine，是否现在安装？\n将会使用 shenmo 提供的脚本进行安装" --no-wrap
		if [[ $? = 0 ]]; then
			deepin-terminal -C "bash /opt/apps/com.gitee.uengine.runner.spark/files/uengine-installer"
		fi
	fi
fi
