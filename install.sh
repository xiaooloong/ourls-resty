#/usr/bin/env bash
BASE=$(dirname $(readlink -f ${0}))
cp "${BASE}/lualib/ourl/config.sample.lua" "${BASE}/lualib/ourl/config.lua"
cd "${BASE}/lualib/hashids" && make