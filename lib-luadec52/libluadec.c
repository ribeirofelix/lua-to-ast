#include "lua.h"
#include "lauxlib.h"
#include "lfunc.h"
#include "lmem.h"

#include "lopcodes.h"
#include "StringBuffer.h"
#include "print.h"
#include "lobject.h"


const char *const luaP_opnames[];

static Proto* toproto(lua_State* L, int i)
{
 const Closure* c=(const Closure*)lua_topointer(L,i);
 return c->l.p;
}


static int l_luadec(lua_State * L )
{
  Proto * proto = toproto(L,1);
  //DecTable * p = (DecTable*) malloc(sizeof(DecTable)) ;
  char * code = ProcessCode(proto, 0);
  char * resp = (char*) malloc(strlen(code) + 12 ) ;
  strcpy(resp,"function a1");
  strcat(resp,code);
  strcat(resp,"end");
  lua_pushstring(L, resp  );
  return 1;
  
}



static const luaL_Reg R[] =
{
   { "luadec",  l_luadec },
   { NULL,        NULL   }
};

LUALIB_API int luaopen_luadec(lua_State *L)
{
 luaL_newlib(L,R);
 return 1;
}
