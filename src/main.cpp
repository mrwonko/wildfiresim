#include <iostream>
#include <string>

#include "jar/lua.h"
#include "jar/LuabindSFML.h"

int main()
{
    jar::Lua lua;
    if(!lua.Init())
    {
        std::cout<<lua.GetLastError();
        return EXIT_SUCCESS;
    }
    //eventually leave out the io and os libraries (since they can be used to do evil things)
    if(!lua.OpenLibaries())
    {
        std::cout<<lua.GetLastError();
        return EXIT_SUCCESS;
    }

    jar::LuabindSFMLMath(lua.GetState());
    jar::LuabindSFMLWindowStuff(lua.GetState());
    jar::LuabindSFMLDrawable(lua.GetState());
    jar::LuabindSFMLImage(lua.GetState());
    jar::LuabindSFMLSprite(lua.GetState());
    jar::LuabindSFMLString(lua.GetState());
    jar::LuabindSFMLShape(lua.GetState());

    if(!lua.ExecuteFile("../lua/main.lua"))
    {
        std::cout<<lua.GetLastError()<<std::endl;
    }

    return EXIT_SUCCESS;
}
