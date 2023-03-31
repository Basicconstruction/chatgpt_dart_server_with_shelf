```aidl
A server app built using [Shelf](https://pub.dev/packages/shelf),
目前可使用的作用  
    简要的非流式传输服务器   
更多细节内容，查看api standard目录  
简单来说就是,服务端对客户进行了额外的控制，用户需要登录才能正常访问api接口。  

如何使用该项目：（编译运行）
ubuntu lts 22.04 
安装dart
```
```
1. 首先，您需要添加 Dart 存储库。打开终端并运行以下命令：
sudo apt-get update  
sudo apt-get install apt-transport-https  
sudo sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'  
sudo sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'  
2. 安装 Dart。
运行以下命令：

sudo apt-get update
sudo apt-get install dart

验证安装是否成功。
运行以下命令：

dart --version
```
```aidl
下载本项目代码。
初始化： 查看lib下的resources查看sql文件，创建数据库以及数据表。  
当前： 更改lib/workflow/database/connectionImpl.dart更改数据库连接信息  
未来： 在项目根/resources下的config.ini中修改链接信息
```
```aidl
然后,cd到项目bin目录
执行dart server.dart即可
或者进行编译
dart compile exe server.dart
然后直接 ./server.exe执行即可
```
```aidl
用户控制：目前后端部分实现了 1用户1可用请求的形式，当一个请求没有被返回时，另外一个请求会返回
Response(202,body:'请等待先前的请求结束')

```
```aidl
计费: 本项目采用了缓存技术，但是没有额外地加锁，有线程安全的问题，但是一般来说不会有
很大的问题，最多就是用户的token消耗没有被计入，对于同一用户，请求10次就会同步一次数据库，同时
服务端使用ctrl+c进行终止时，也会进行数据同步，有可能会出现问题。
为什么这么设计，因为数据库操作是很耗时间的操作，如果请求一次就同步到数据库，那么会严重影响服务器的性能。
本项目直接关联到openai的token，在设计token充值页面时，可以优化一下。
比如openai的计费是	$0.002 / 1K tokens
那么我们在可以获得3元/5美元的账号时，我们可以把5美元的key的成本计费为20元。
那么5$ = 5*500*1000 = 250 wtoken.
我们收费就是1元10wtoken左右。
当没有这么优惠的key时,250w/35/1.8 约等于 4w token。即可
```
```aidl
设计成免费时，可以在注册成功时，使得当前key可用token以及总token是一个很大的数即可。
也可避免被人恶意使用.
```