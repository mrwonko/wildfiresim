#include "jar/LuabindSFML.h"
#include <lua.hpp>
#include <luabind/class.hpp>
#include <luabind/operator.hpp>
#include <SFML/Graphics/Texture.hpp>
#include <SFML/Graphics/RenderWindow.hpp>

namespace jar
{

void LuabindSFMLImage(lua_State* L)
{
    luabind::module(L, "sf")
    [
        luabind::class_<sf::Texture>("Image")
            .def(luabind::constructor<>())
            .def(luabind::constructor<const sf::Texture&>())
            .def("LoadFromFile", &sf::Texture::loadFromFile)
            .def("LoadFromMemory", &sf::Texture::loadFromMemory)
            .def("GetSize", &sf::Texture::getSize)
    ];
}

}
