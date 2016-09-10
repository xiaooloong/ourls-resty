# Ourls-Resty

[Ourls][1] 是由 [takashiki][2] 实现的一个基于发号和 hashid 的短网址服务。
受这个项目的启发，将此工程移植，使用 [OpenResty][3] 实现。

### 待增加的特性：

 - 工程目录优化，以 OpenResty 目录结构为准
 - Cache 支持

### 安装方法：

 - 安装 openresty rpm 包（或手动编译，建议使用 --prefix=/usr/local/openresty）
 - 安装 libidn-devel 库（yum install libidn-devel）
 - 将原 openresty/nginx/conf 目录备份
 - 将本工程解压到 openresty/nginx/conf 目录，执行 `install.sh`
 - 修改 ourl/config.lua 中的数据库等配置
 - 恢复 urls.sql 至 mysql/mariadb 数据库
 - 进入 vhosts 目录，修改 ourl.conf 中的 server_name 为你自己的域名
 - 启动 openresty

### 使用到的其他项目

 - [leihog/hashids.lua][4]
 - [APItools/router.lua][5]
 - [golgote/neturl][6]
 - [mah0x211/lua-idna][7]
 - [hamishforbes/lua-resty-iputils][8]

  [1]: https://github.com/takashiki/Ourls
  [2]: https://github.com/takashiki
  [3]: http://openresty.org/
  [4]: https://github.com/leihog/hashids.lua
  [5]: https://github.com/APItools/router.lua
  [6]: https://github.com/golgote/neturl
  [7]: https://github.com/mah0x211/lua-idna
  [8]: https://github.com/hamishforbes/lua-resty-iputils