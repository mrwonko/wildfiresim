#include "jar/LuabindSFML.h"
#include <lua.hpp>
#include <luabind/class.hpp>
#include <luabind/operator.hpp>
#include <SFML/System/Vector2.hpp>
#include <SFML/Graphics/Color.hpp>
#include <SFML/Graphics/Rect.hpp>

namespace jar
{

void LuabindSFMLMath(lua_State* L)
{
    typedef sf::Vector2f (*funcptr1)(const sf::Vector2f&);
    luabind::module(L, "sf")
    [
        luabind::class_<sf::Vector2f>("Vector2f")
            .def(luabind::constructor<>())
            .def(luabind::constructor<float, float>())
            .def_readwrite("x", &sf::Vector2f::x)
            .def_readwrite("y", &sf::Vector2f::y)
            .def("Invert", (funcptr1)&sf::operator-)
            .def(luabind::self + luabind::other<sf::Vector2f>())
            .def(luabind::self - luabind::other<sf::Vector2f>())
            .def(luabind::self * float())
            .def(luabind::self / float())
            .def(luabind::self == luabind::other<sf::Vector2f>()),

        luabind::class_<sf::Color>("Color")
            .def(luabind::constructor<>())
            .def(luabind::constructor<sf::Uint8, sf::Uint8, sf::Uint8>())
            .def_readwrite("r", &sf::Color::r)
            .def_readwrite("g", &sf::Color::g)
            .def_readwrite("b", &sf::Color::b)
            .def_readwrite("a", &sf::Color::a),

        luabind::class_<sf::FloatRect>("FloatRect")
            .def(luabind::constructor<>())
            .def(luabind::constructor<float, float, float, float>())
            .def_readwrite("top", &sf::FloatRect::top)
            .def_readwrite("left", &sf::FloatRect::left)
            .def_readwrite("width", &sf::FloatRect::width)
            .def_readwrite("height", &sf::FloatRect::height)
			.def("Contains", (bool (sf::FloatRect::*)(float, float) const) &sf::FloatRect::contains)
            .def("Intersects", (bool (sf::FloatRect::*)(const sf::FloatRect&) const) &sf::FloatRect::intersects),

        luabind::class_<sf::IntRect>("IntRect")
            .def(luabind::constructor<>())
            .def(luabind::constructor<int, int, int, int>())
            .def_readwrite("top", &sf::IntRect::top)
            .def_readwrite("left", &sf::IntRect::left)
            .def_readwrite("width", &sf::IntRect::width)
            .def_readwrite("height", &sf::IntRect::height)
            .def("Contains", (bool (sf::IntRect::*)(int, int) const) &sf::IntRect::contains)
            .def("Intersects", (bool (sf::IntRect::*)(const sf::IntRect&) const) &sf::IntRect::intersects)
    ];
}

}
