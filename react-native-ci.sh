#!/bin/bash

# 检查node是否安装
node_version=`node -v`
if [[ $? -eq 0 ]]
then
  echo "node version is $node_version"
else
  echo "node does not exist"
fi

# 检查npm是否安装
npm_version=`npm -v`
if [[ $? -eq 0 ]]
then
  echo "npm version is $npm_version"
else
  echo "npm does not exist"
fi

# 杀掉原有node进程
kill_node=`ps -ef | grep node | grep -v grep | awk '{print $2}' | xargs kill -9`
# kill_node=`killall node`
if [[ $? -eq 0 ]]
then
  echo "killed node process"
else
  echo "no node project is running"
fi

# 安装依赖
npm_install=`npm install`
if [[ $? -eq 0 ]]
then
  echo "installing packages successful: $npm_install"
else
  echo "installing packages failed: $npm_install"
fi

# 启动node服务
echo "开始启动node服务"
# npm_start=`npm start`
npm_start=`nohup npm start > log.txt &`
if [[ $? -ne 0 ]]
then
  echo "node服务启动成功"
else
  echo "node服务启动失败"
fi

exit 0
