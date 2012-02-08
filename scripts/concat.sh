#!/bin/bash

rm ./build/*

cat ./wrap/top.js > ./build/loader.js
cat ./js/yui-core.js >> ./build/loader.js
cat ./js/get.js >> ./build/loader.js
cat ./js/loader-base.js >> ./build/loader.js
cat ./wrap/bottom.js >> ./build/loader.js

# Swap out the temp version for a CDN version
sed -e 's/@VERSION@/3.5.0pr2/' ./build/loader.js > ./build/loader-v.js
mv ./build/loader-v.js ./build/loader.js

wait
yuicompress ./build/loader.js
wait
mv ./build/loader.js-min ./build/loader-min.js
wait
cp ./build/loader-min.js ./build/loader-zip.js
wait
gzip ./build/loader-zip.js
