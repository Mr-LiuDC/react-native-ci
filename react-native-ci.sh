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
kill_node=`killall node`
if [[ $? -eq 0 ]]; then
echo "killed node process"
else echo "no node project is running"
fi

# 安装依赖
npm_install=`npm install`

# 启动node服务
npm_start=`npm start`

echo 'start successfully'