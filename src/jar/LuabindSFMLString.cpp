#include "jar/LuabindSFML.h"
#include <lua.hpp>
#include <luabind/class.hpp>
#include <luabind/operator.hpp>
#include <SFML/Graphics/String.hpp>
#include <SFML/System/Unicode.hpp>

namespace jar
{

void LuabindSFMLString(lua_State* L)
{
    luabind::module(L, "sf")
    [
        luabind::class_<sf::Font>("Font")
            //static functions go in a scope
            .scope
            [
                luabind::def("GetDefaultFont", &sf::Font::GetDefaultFont)
            ],

        luabind::namespace_("Unicode")
        [
            luabind::class_<sf::Unicode::Text>("Text")
                .def(luabind::constructor<const std::string&>())
                .def("str", &sf::Unicode::Text::operator std::string) //TODO: Document! Or remember.
        ],

        luabind::class_<sf::String, sf::Drawable>("String")
            .enum_("Style")
            [
                luabind::value("Regular", sf::String::Regular),
                luabind::value("Bold", sf::String::Bold),
                luabind::value("Italic", sf::String::Italic),
                luabind::value("Underlined", sf::String::Underlined)
            ]
            .def(luabind::constructor<>())
            .def(luabind::constructor<const sf::Unicode::Text& >())
            .def(luabind::constructor<const sf::Unicode::Text&, const sf::Font&>())
            .def(luabind::constructor<const sf::Unicode::Text&, const sf::Font&, float>())
            .def("GetCharacterPos", &sf::String::GetCharacterPos)
            .def("GetFont", &sf::String::GetFont)
            .def("GetSize", &sf::String::GetSize)
            .def("GetStyle", &sf::String::GetStyle)
            .def("GetText", &sf::String::GetText)
            .def("SetFont", &sf::String::SetFont)
            .def("SetSize", &sf::String::SetSize)
            .def("SetStyle", &sf::String::SetStyle)
            .def("SetText", &sf::String::SetText)
            .def("GetRect", &sf::String::GetRect)
    ];
}

}
