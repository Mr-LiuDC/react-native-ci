#author zengling20180319

function getLastTime(){
  dArray=(`grep -e "$1" logs/zbj.log | awk '{print $1,$2}' | xargs -n2`)
  len=${#dArray[@]}
  startup_end=0
  if [ "$len" -ge 2 ]
    then
        END=${dArray[len-2]}' '${dArray[len-1]}
        startup_end=`date -d "$END" +%s`
  fi
  echo $startup_end
}

export TOMCAT_HOME=/opt/appserver/zbjdevelop

cd $TOMCAT_HOME

echo Start script powered by wanghu

if [ $# -lt 1 ]
    then
    echo Please enter jar name
        exit 1
fi

jarName=$1.jar
echo $jarName
ls | grep -- "^$jarName$"
exist=`echo $?`
echo "exist"$exist
if [ $exist -ne 0 ]
  then
        echo jar包不存在或者不在目录 `pwd` 中
        exit 1
fi

echo "kill java -jar  $jarName"
ps -ef | grep "java -jar $jarName" | grep -v grep | awk '{print $2}' | xargs kill -9

frontPages=`wc -l logs/zbj.log | awk '{print $1}'`
frontPages=`expr $frontPages + 1`

echo start java jar $jarName
nohup java -jar $jarName > nul 2>nul &

BEGIN=`date "+%Y-%m-%d %T"`
startup_begin=`date +%s`

echo begin time is $BEGIN
startupStatus=1
while true 
do
  ret=`getLastTime "ERROR \[zbj,,,\] .* \[           main\]"`
  echo $ret
  INTER=`expr $ret - $startup_begin`
  if [ "$INTER" -le 0 ]
  then
    echo please waiting next 10 seconds
    sleep 10
  else
    startupStatus=1;
    currentPages=`wc -l logs/zpj.log | awk '{print $1}'`
    sed -n $frontPages,$currentPages'p' logs/zbj.log
    break
  fi

  ret=`getLastTime "Started RestApplication in .* seconds"`
  echo $ret
  INTER=`expr $ret - $startup_begin`

  if [ "$INTER" -le 0 ]
  then
    echo please waiting next 10 seconds
    sleep 10
  else
    startupStatus=0
    currentPages=`wc -l logs/zbj.log | awk '{print $1}'`
    sed -n $frontPages,$currentPages'p' logs/zbj.log
    break
  fi
  current_time=`date +%s`
  elapsed_time=`expr $current_time - $startup_begin`
  if [ "$elapsed_time" -ge 100 ]
    then
    startupStatus=2
    currentPages=`wc -l logs/zbj.log | awk '{print $1}'`
    sed -n $frontPages,$currentPages'p' logs/zbj.log
    break
  fi
done
if [ "$startupStatus" -eq 0 ]
   then
        echo *******************congratulations, application started successfully!!!!!!!*************************
   elif [ "$startupStatus" -eq 1 ]
        then
        echo *******************congratulations, application started failed!!!!!!!*************************
   else
        echo *******************congratulations, execute time out*************************
fi
unset TOMCAT_HOME
exit $startupStatus
