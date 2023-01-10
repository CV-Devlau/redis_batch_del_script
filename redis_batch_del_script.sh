#!/bin/bash
num=-1
# 累计删除数量
total_num=0
# 游标
cursor=-1
# redis客户端连接命令 
cli_command=/usr/local/bin/redis-cli
echo "请输入键名表达式或指定key，例如：cache:*，cache:1 "
read -p "输入键名表达式 > " exp

read -r -p "Are You Sure? match: $exp  [Y/n] " input

case $input in
    [yY][eE][sS]|[yY])
        # 循环scan 游标不等于0就继续
        while [ ! $cursor -eq 0  ]
        do
                # 没有do while 所有，第一次将游标设置为0
                if [ $cursor -eq -1 ];then
                        cursor=0
                fi
                # 用scan获取key存到数组中
                key_arr=(`echo "scan $cursor MATCH $exp COUNT 2000" | $cli_command`)
                # 设置新的游标，数组第一个值是游标
                cursor="${key_arr[0]}"
                # 从数组中删除游标
                unset key_arr[0]
                # 这一次scan获取到的数量
                num="${#key_arr[*]}"
                # 加到总数中
                ((total_num=$total_num+$num))
                # 如果数组大小大于0则执行删除
                if [ $num -gt 0 ];then
                        # 异步删除
                        m=`echo "unlink ${key_arr[*]}" | $cli_command`
                fi
                # 删除数组
                unset key_arr
        done
        echo "删除的key个数为: $total_num"
esac
