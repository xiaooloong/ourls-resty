# Ourls-Resty

[Ourls][1] 是由 [takashiki][2] 实现的一个基于发号和 hashid 的短网址服务。
受这个项目的启发，将此工程移植，使用 [OpenResty][3] 实现。

### 待移植的功能：

 - url 规格化
 - 前置代理支持

### 待增加的特性：

 - Cache 支持

### 安装方法：

 - 安装 openresty rpm 包（或手动编译，建议使用 --prefix=/usr/local/openresty）
 - 将原 openresty/nginx/conf 目录备份
 - 将本工程解压到 openresty/nginx/conf 目录
 - 进入 openresty/nginx/conf/ourl 目录，复制 config.sample.lua 为 config.lua
 - 修改 config.lua 中的数据库等配置
 - 恢复 urls.sql 至 mysql/mariadb 数据库
 - 进入 openresty/nginx/conf/vhosts 目录，修改 ourl.conf 中的 server_name
 - 进入 openresty/nginx/conf/lib/hashids 目录，执行 make 命令
 - 启动 openresty

### 使用到的其他项目

 - [leihog/hashids.lua][4]
 - [APItools/router.lua][5]

  [1]: https://github.com/takashiki/Ourls
  [2]: https://github.com/takashiki
  [3]: http://openresty.org/
  [4]: https://github.com/leihog/hashids.lua
  [5]: https://github.com/APItools/router.lua