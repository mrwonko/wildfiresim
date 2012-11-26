#include "jar/Lua.h"
#include <lua.hpp>
#include <luabind/luabind.hpp> //includes both functions and classes. (function.hpp + class.hpp)

namespace jar
{

Lua::Lua() :
    mState(NULL),
    mIsMainThread(false)
{
    //ctor
}

Lua::~Lua()
{
    //dtor
    //if(mState) is included in Deinit()
    Deinit();
}

const bool Lua::Init()
{
    //try to open the lua state
    mState = lua_open();
    if(!mState)
    {
        //didn't work?
        mLastError = "Could not open lua State!";
        return false;
    }

    //luabind::open may only be called for the main thread. Otherwise it throws an exception.
    mIsMainThread = lua_pushthread(mState) == 1;
    lua_pop(mState, 1);
    if(mIsMainThread)
    {
        luabind::open(mState);
    }
    return true;
}

const bool Lua::OpenLibaries()
{
    if(!mState)
    {
        mLastError = "Not initialized!";
        return false;
    }
    luaL_openlibs(mState);
    return true;
}

const bool Lua::OpenBaseLibrary()
{
    if(!mState)
    {
        mLastError = "Not initialized!";
        return false;
    }
    luaopen_base(mState);
    return true;
}

const bool Lua::OpenPackageLibrary()
{
    if(!mState)
    {
        mLastError = "Not initialized!";
        return false;
    }
    luaopen_package(mState);
    return true;
}

const bool Lua::OpenStringLibrary()
{
    if(!mState)
    {
        mLastError = "Not initialized!";
        return false;
    }
    luaopen_string(mState);
    return true;
}

const bool Lua::OpenTableLibrary()
{
    if(!mState)
    {
        mLastError = "Not initialized!";
        return false;
    }
    luaopen_table(mState);
    return true;
}

const bool Lua::OpenMathLibrary()
{
    if(!mState)
    {
        mLastError = "Not initialized!";
        return false;
    }
    luaopen_math(mState);
    return true;
}

const bool Lua::OpenIOLibrary()
{
    if(!mState)
    {
        mLastError = "Not initialized!";
        return false;
    }
    luaopen_io(mState);
    return true;
}

const bool Lua::OpenOSLibrary()
{
    if(!mState)
    {
        mLastError = "Not initialized!";
        return false;
    }
    luaopen_os(mState);
    return true;
}

const bool Lua::OpenDebugLibrary()
{
    if(!mState)
    {
        mLastError = "Not initialized!";
        return false;
    }
    luaopen_debug(mState);
    return true;
}

void Lua::Deinit()
{
    if(mState)
    {
        lua_close(mState);
        mIsMainThread = false;
    }
}

const bool Lua::ExecuteString(const std::string& str, const std::string& chunkname)
{
    if(!mState)
    {
        mLastError = "Not initialized!";
        return false;
    }
    //I don' do luaL_dostring since I don't want the stack to be filled with return values I need to clean manually. So I just say I expect 0 returns, instead of LUA_MULTRET. Also, I cannot set a chunkname that way.

    //syntax: lua_pcall(lua_State, numArguments, numReturns, errorHandlingFunctionIndex (0 = none))
    if(luaL_loadbuffer(mState, str.c_str(), str.size(), chunkname.c_str())||lua_pcall(mState, 0, 0, 0))
    {
        //return != 0 means error.
        //the error is pushed onto the stack.
        mLastError = lua_tostring(mState, -1);
        return false;
    }
    return true;
}

const bool Lua::ExecuteFile(const std::string& filename)
{
    if(!mState)
    {
        mLastError = "Not initialized!";
        return false;
    }
    //I don' do luaL_dofile since I don't want the stack to be filled with return values I need to clean manually. So I just say I expect 0 returns, instead of LUA_MULTRET.

    //syntax: lua_pcall(lua_State, numArguments, numReturns, errorHandlingFunctionIndex (0 = none))
    if(luaL_loadfile(mState, filename.c_str()) || lua_pcall(mState, 0, 0, 0))
    {
        //returns non-zero on error and pushes the error on the stack.
        mLastError = lua_tostring(mState, -1);
        return false;
    }
    return true;
}

} // namespace jar
