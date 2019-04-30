#!/bin/bash
#echo -e Up Time : `date` "\n"
printf "\033[33m%-50s \033[0m\n" UpTime:"`date "+%Y-%m-%d %H:%M:%S"`"
work_dir=`pwd`"/"
dest_dir="/root/go/src/go_wechat/"
ip="94.191.91.104" #CQ
port="1111"
#echo $?  #最后一个命令执行结果
#echo $#  #传递给脚本的参数个数
#echo $@  #所有传递给脚本的参数列表 ，不作为整体
#echo $modify_file
if [ $# -gt 0 ];then
	in_what=$@
	work_dir=$PWD
	work_dir=${work_dir}"/"
else
	modify_file=`git status |grep  "^\s*modified:" |sed -e 's/\s//g'|awk 'BEGIN{FS=":"}{print $2}'|sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/   /g'`
	in_what=$modify_file
fi

work_dir_len=${#work_dir}
max_len=0
for i in $in_what
do
	tmp_len=${#i}
	if [ $tmp_len -gt $max_len ];then
		max_len=${#i}
	fi
done

max_l=$(expr $work_dir_len + $max_len + 10)

for i in $in_what
do
	head=${i:0:1}
	if [ $head == '/' ];then
		up_file=$i
		dest_file=$dest_dir
		
	else
		up_file=$work_dir$i
		dest_file=$dest_dir$i
	fi	
	
	scp -P $port -r $up_file root@$ip:$dest_file > /dev/null 2>&1
	if [ $? -ne 0 ];then
		printf "%-"$max_l"s%-5s\033[31m %-15s \033[0m\n" $work_dir$i : ERROR!
#		echo $work_dir$i" upload error!"
	else
		printf "%-"$max_l"s%-5s\033[32m %-15s \033[0m\n" $work_dir$i : success
#		echo -e $work_dir$i"   ---------   success!"
	fi
done
#TODO 还可以判断传递参数的第一个字符是否是./;如果是则按照相对路径算，如果是/按照绝对路径算；如果啥都没有则按照当前路径算；并且要判断文件是否存在;路径修复
# 字符串截取：https://www.cnblogs.com/zwgblog/p/6031256.html
# 打印输出 颜色：https://blog.csdn.net/andylauren/article/details/60873400
# 打印输出格式化：https://blog.csdn.net/matengbing/article/details/81104726
# $# $@ $* https://www.cnblogs.com/davygeek/p/5670212.html
# sed 替换换行符 https://cloud.tencent.com/developer/ask/137080
# 连接远程主机 环境变量，本地变量的问题 https://blog.csdn.net/whitehack/article/details/51705889  ssh user@hostname -t 'cd /apps/app1/logs; bash --login'
# 接上一条 https://blog.csdn.net/fight4gold/article/details/50327383
# 在远程机器上执行n条命令 https://www.cnblogs.com/djoker/p/8342500.html  http://www.cnblogs.com/softidea/p/6855045.html
