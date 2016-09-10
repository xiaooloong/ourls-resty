#/usr/bin/env bash
BASE=$(dirname $(readlink -f ${0}))
PLATFORM=$(uname -s)
case ${PLATFORM} in
    Darwin)     PLATFORM='macosx'   ;;
    FreeBSD)    PLATFORM='bsd'      ;;
    *)          PLATFORM='linux'    ;;
esac
cp "${BASE}/lualib/ourl/config.sample.lua" "${BASE}/lualib/ourl/config.lua"
cd "${BASE}/lualib/hashids" && make
cd "${BASE}/idna" && make ${PLATFORM} && mv "${BASE}/idna/idna.so" "${BASE}/lualib" && cd ${BASE}