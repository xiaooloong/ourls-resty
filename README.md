# Ourls-Resty

[Ourls][1] 是由 [takashiki][2] 实现的一个基于发号和 hashid 的短网址服务。
受这个项目的启发，将此项目移植到 [OpenResty][3] 。

移植了原项目的功能和特性，并加入了内存缓存支持。

### 使用方法

#### 环境
 - 安装 openresty [预编译包][9] （或 [手动编译教程][10]）
 - 安装 libidn ： `yum install libidn`

#### 安装
 - 使用 opm 包管理安装本库： `opm install xiaooloong/ourls-resty`
 - 安装 lua 库依赖： `luarocks install net-urls router`
 - 参考 [hashids.lua][4] 的说明安装 hashids。

#### 配置
 - 进入工程目录，复制 `config.sample.lua` 为 `config.lua`
 - 修改 `config.lua` 中的数据库配置、hashids 参数、可信代理服务器的 cidr
 - 恢复 `urls.sql` 至 `mysql` 或 `mariadb` 数据库
 - 进入 nginx/conf 目录，根据自己的实际情况修改 （合并配置，修改 server_name …）

#### 完成 
 - 启动 openresty （service openresty start）

### 使用到的其他项目

 - [leihog/hashids.lua][4]
 - [APItools/router.lua][5]
 - [golgote/neturl][6]
 - [hamishforbes/lua-resty-iputils][8]

  [1]: https://github.com/takashiki/Ourls
  [2]: https://github.com/takashiki
  [3]: http://openresty.org/
  [4]: https://github.com/leihog/hashids.lua
  [5]: https://github.com/APItools/router.lua
  [6]: https://github.com/golgote/neturl
  [8]: https://github.com/hamishforbes/lua-resty-iputils
  [9]: http://openresty.org/cn/rpm-packages.html
  [10]: https://moonbingbing.gitbooks.io/openresty-best-practices/content/openresty/install_on_centos.html