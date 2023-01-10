# redis_batch_del_script
一个Redis的批量删除脚本，使用scan和异步删除

## 使用方式
``` 
[root@localhost tool]# sh redis_batch_del_script.sh 
请输入键名表达式或指定key，例如：cache:*，cache:1 
输入键名表达式 > cache*
Are You Sure? match: cache*  [Y/n] y
删除的key个数为: 6
```

键名表达式可以为具体的key或者所有scan支持的表达式
