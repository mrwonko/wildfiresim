#include "jar/LuabindSFML.h"
#include <lua.hpp>
#include <luabind/class.hpp>
#include <luabind/operator.hpp>
#include <SFML/Graphics/Text.hpp>
#include <SFML/System/String.hpp>

namespace jar
{

sf::Font& GetDefaultFont()
{
	static sf::Font font;
	static bool loaded = false;
	if(!loaded)
	{
		loaded = true;
	}
	return font;
}

class TextHelper : public sf::Text
{
public:
	TextHelper() {}
	TextHelper(const std::string& text, unsigned int characterSize = 15) : sf::Text(sf::String(text), GetDefaultFont(), characterSize) {}
	void setString(const std::string& text)
	{
		sf::Text::setString(text);
	}
	const std::string getString()
	{
		return sf::Text::getString().toAnsiString();
	}
};

void LuabindSFMLString(lua_State* L)
{
    luabind::module(L, "sf")
    [

		luabind::class_<TextHelper, luabind::bases<sf::Drawable, sf::Transformable> >("String")
            .enum_("Style")
            [
                luabind::value("Regular", sf::Text::Regular),
                luabind::value("Bold", sf::Text::Bold),
                luabind::value("Italic", sf::Text::Italic),
                luabind::value("Underlined", sf::Text::Underlined)
            ]
            .def(luabind::constructor<>())
            .def(luabind::constructor<const sf::String& >())
            .def(luabind::constructor<const sf::String&, unsigned int>())
            .def("GetStyle", &sf::Text::getStyle)
            .def("GetText", &TextHelper::getString)
			.def("SetScale", (void(sf::Text::*)(const sf::Vector2f&))&sf::Text::setScale)
            .def("SetStyle", &sf::Text::setStyle)
            .def("SetText", &TextHelper::setString)
            .def("GetRect", &sf::Text::getGlobalBounds)
            .def("SetColor", &sf::Text::setColor)
            .def("GetColor", &sf::Text::getColor)
    ];
}

}
