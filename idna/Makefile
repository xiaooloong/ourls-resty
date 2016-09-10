# This Makefile is based on lua-zlib's Makefile. Thanks to the lua-zlib developers.
# Inform the location to intall the modules
PREFIX   ?= /usr/local/openresty
LUAPATH  ?= $(PREFIX)/lualib
LUACPATH ?= $(PREFIX)/lualib
INCDIR   ?= -I$(PREFIX)/luajit/include/luajit-2.1
LIBDIR   ?= -L$(PREFIX)/luajit/lib

# For Mac OS X: set the system version
MACOSX_VERSION = 10.4

CMOD = idna.so
OBJS = idna.o

LIBS = -lidn -lluajit-5.1
WARN = -Wall -pedantic

BSD_CFLAGS  = -O2 -fPIC $(WARN) $(INCDIR) $(DEFS)
BSD_LDFLAGS = -O -shared -fPIC $(LIBDIR)

LNX_CFLAGS  = -O2 -fPIC $(WARN) $(INCDIR) $(DEFS)
LNX_LDFLAGS = -O -shared -fPIC $(LIBDIR)

MAC_ENV     = env MACOSX_DEPLOYMENT_TARGET='$(MACVER)'
MAC_CFLAGS  = -O2 -fPIC -fno-common $(WARN) $(INCDIR) $(DEFS)
MAC_LDFLAGS = -bundle -undefined dynamic_lookup -fPIC $(LIBDIR)

CC = gcc
LD = $(MYENV) gcc
CFLAGS  = $(MYCFLAGS)
LDFLAGS = $(MYLDFLAGS)

.PHONY: all clean install none linux bsd macosx

all:
	@echo "Usage: $(MAKE) <platform>"
	@echo "  * linux"
	@echo "  * bsd"
	@echo "  * macosx"

install: $(CMOD)
	cp $(CMOD) $(LUACPATH)

uninstall:
	rm $(LUACPATH)/$(CMOD)

linux:
	@$(MAKE) $(CMOD) MYCFLAGS="$(LNX_CFLAGS)" MYLDFLAGS="$(LNX_LDFLAGS)" INCDIR="$(INCDIR)" LIBDIR="$(LIBDIR)" DEFS="$(DEFS)"

bsd:
	@$(MAKE) $(CMOD) MYCFLAGS="$(BSD_CFLAGS)" MYLDFLAGS="$(BSD_LDFLAGS)" INCDIR="$(INCDIR)" LIBDIR="$(LIBDIR)" DEFS="$(DEFS)"

macosx:
	@$(MAKE) $(CMOD) MYCFLAGS="$(MAC_CFLAGS)" MYLDFLAGS="$(MAC_LDFLAGS)" MYENV="$(MAC_ENV)" INCDIR="$(INCDIR)" LIBDIR="$(LIBDIR)" DEFS="$(DEFS)"

clean:
	rm -f $(OBJS) $(CMOD)

.c.o:
	$(CC) -c $(CFLAGS) $(DEFS) $(INCDIR) -o $@ $<

$(CMOD): $(OBJS)
	$(LD) $(LDFLAGS) $(LIBDIR) $(OBJS) $(LIBS) -o $@
