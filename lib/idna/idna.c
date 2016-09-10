/*
 *  Copyright 2014 Masatoshi Teruya. All rights reserved.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a 
 *  copy of this software and associated documentation files (the "Software"), 
 *  to deal in the Software without restriction, including without limitation 
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 *  and/or sell copies of the Software, and to permit persons to whom the 
 *  Software is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL 
 *  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
 *  DEALINGS IN THE SOFTWARE.
 *
 *  idna.c
 *  lua-idna
 *
 *  Created by Masatoshi Teruya on 14/12/06.
 *
 */

#include <stdlib.h>
#include <lua.h>
#include <lauxlib.h>
#include <stringprep.h>
#include <idna.h>

#define lstate_fn2tbl(L,k,v) do{ \
    lua_pushstring(L,k); \
    lua_pushcfunction(L,v); \
    lua_rawset(L,-3); \
}while(0)

#define pdealloc(p)     free((void*)p)

static int encode_lua( lua_State *L )
{
    const char *src = luaL_checkstring( L, 1 );
    char *dest = NULL;
    int rc = idna_to_ascii_8z( src, &dest, 0 );
    
    if( rc == IDNA_SUCCESS ){
        lua_pushstring( L, dest );
        pdealloc( dest );
        return 1;
    }
    
    // got error
    lua_pushnil( L );
    lua_pushstring( L, idna_strerror( rc ) );
    
    return 2;
}


static int decode_lua( lua_State *L )
{
    const char *src = luaL_checkstring( L, 1 );
    char *dest = NULL;
    int rc = idna_to_unicode_8z8z( src, &dest, 0 );
    
    if( rc == IDNA_SUCCESS ){
        lua_pushstring( L, dest );
        pdealloc( dest );
        return 1;
    }
    
    // got error
    lua_pushnil( L );
    lua_pushstring( L, idna_strerror( rc ) );
    
    return 2;
}


LUALIB_API int luaopen_idna( lua_State *L )
{
    lua_createtable( L, 0, 2 );
    lstate_fn2tbl( L, "encode", encode_lua );
    lstate_fn2tbl( L, "decode", decode_lua );
    
    return 1;
}


