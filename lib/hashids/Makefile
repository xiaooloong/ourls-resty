UNAME := $(shell uname -s)

all:
ifeq ($(UNAME),Darwin)
	@echo building for OS X
	gcc -bundle -undefined dynamic_lookup -I/usr/local/openresty/luajit/include/luajit-2.1 -o clib.so clib.c
else
	@echo building for Linux
	gcc -Wall -shared -fPIC -I/usr/local/openresty/luajit/include/luajit-2.1 -o clib.so clib.c
endif
