all: source

source: copysource concat

copysource:
	cp ~/src/yui3/build/loader-base/loader-base.js ./js/
	cp ~/src/yui3/build/yui-core/yui-core.js ./js/
	cp ~/src/yui3/build/get/get.js ./js/

debug: copydebug concat

copydebug:
	cp ~/src/yui3/build/loader-base/loader-base-debug.js ./js/loader-base.js
	cp ~/src/yui3/build/yui-core/yui-core-debug.js ./js/yui-core.js
	cat ~/src/yui3/build/yui-log/yui-log-debug.js >> ./js/yui-core.js
	cp ~/src/yui3/build/get/get-debug.js ./js/get.js

concat:
	./scripts/concat.sh
