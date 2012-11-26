#include "jar/LuabindSFML.h"
#include <lua.hpp>
#include <luabind/class.hpp>
#include <SFML/Graphics/Image.hpp>
#include <SFML/Graphics/Sprite.hpp>

namespace jar
{

void LuabindSFMLSprite(lua_State* L)
{
    luabind::module(L, "sf")
    [
        luabind::class_<sf::Sprite, sf::Drawable>("Sprite")
            .def(luabind::constructor<>())
            .def(luabind::constructor<const sf::Image&>())
            .def(luabind::constructor<const sf::Image&, const sf::Vector2f&>())
            .def(luabind::constructor<const sf::Image&, const sf::Vector2f&, const sf::Vector2f&>())
            .def(luabind::constructor<const sf::Image&, const sf::Vector2f&, const sf::Vector2f&, float>())
            .def(luabind::constructor<const sf::Image&, const sf::Vector2f&, const sf::Vector2f&, float, const sf::Color&>())
            .def("SetImage", &sf::Sprite::SetImage)
            .def("SetSubRect", &sf::Sprite::SetSubRect)
            .def("Resize", (void(sf::Sprite::*)(float, float))&sf::Sprite::Resize)
            .def("Resize", (void(sf::Sprite::*)(const sf::Vector2f&))&sf::Sprite::Resize)
            .def("FlipX", &sf::Sprite::FlipX)
            .def("FlipY", &sf::Sprite::FlipY)
            .def("GetImage", &sf::Sprite::GetImage)
            .def("GetSubRect", &sf::Sprite::SetSubRect)
    ];
}

}
