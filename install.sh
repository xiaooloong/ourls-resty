#/bin/sh
BASE=$(dirname $(readlink -f ${0}))
cp "${BASE}/ourl/config.sample.lua" "${BASE}/ourl/config.lua"
cd "${BASE}/lib/hashids" && make
cd "${BASE}/lib/idna" && make linux
mv "${BASE}/lib/idna/idna.so" "${BASE}"
cd ${BASE}