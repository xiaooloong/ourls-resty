# Ourls-Resty

[Ourls][1] 是由 [takashiki][2] 实现的一个基于发号和 hashid 的短网址服务。
受这个项目的启发，将此项目移植到 [OpenResty][3] 。

### 待增加的特性：

 - Cache 支持

### 安装方法：

 - 安装 openresty [预编译包][9] （[手动编译教程][10]）
 - 安装 gcc、make、libidn、libidn-devel （yum gcc make install libidn-devel）
 - 将本工程解压到 openresty 目录，执行 `install.sh` （bash install.sh）
 - 修改 lualib/ourl/config.lua 中的数据库配置、hashids 参数、可信代理的 cidr
 - 恢复 urls.sql 至 mysql 或 mariadb 数据库
 - 进入 nginx/conf 目录，根据自己的实际情况修改 （合并配置，修改 server_name …）
 - 启动 openresty （service openresty start）

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
  [9]: http://openresty.org/cn/rpm-packages.html
  [10]: https://moonbingbing.gitbooks.io/openresty-best-practices/content/openresty/install_on_centos.html