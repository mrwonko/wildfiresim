#include "jar/LuabindSFML.h"
#include <lua.hpp>
#include <luabind/class.hpp>
#include <SFML/Graphics/Shape.hpp>

namespace jar
{

void LuabindSFMLShape(lua_State* L)
{
    typedef sf::Shape (*CircleFunction) (const sf::Vector2f&, float, const sf::Color&, float, const sf::Color&);
    typedef sf::Shape (*LineFunction) (const sf::Vector2f&, const sf::Vector2f&, float, const sf::Color&, float, const sf::Color&);
    typedef sf::Shape (*RectangleFunction) (const sf::Vector2f&, const sf::Vector2f&, const sf::Color&, float, const sf::Color&);

    luabind::module(L, "sf")
    [
        luabind::class_<sf::Shape, sf::Drawable>("Shape")
            .scope
            [
                luabind::def("Circle", (CircleFunction) &sf::Shape::Circle),
                luabind::def("Line", (LineFunction) &sf::Shape::Line),
                luabind::def("Rectangle", (RectangleFunction) &sf::Shape::Rectangle)
            ]
    ];
}

}
