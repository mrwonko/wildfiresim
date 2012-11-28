#include "jar/LuabindSFML.h"
#include <lua.hpp>
#include <luabind/class.hpp>
#include <SFML/Graphics/Shape.hpp>
#include <SFML/Graphics/CircleShape.hpp>
#include <SFML/Graphics/RectangleShape.hpp>

namespace jar
{

sf::CircleShape CircleFunction (const sf::Vector2f& position, float radius, const sf::Color& outlineColor, float outlineThickness, const sf::Color& fillColor)
{
	sf::CircleShape shape = sf::CircleShape(radius);
	shape.setPosition(position);
	shape.setFillColor(fillColor);
	shape.setOutlineColor(outlineColor);
	shape.setOutlineThickness(outlineThickness);
	return shape;
}

class LineShape : public sf::Shape
{
public:
	LineShape(const sf::Vector2f& pos1, const sf::Vector2f& pos2, float thickness, const sf::Color& color) :
		mPos1(pos1),
		mPos2(pos2),
		mThickness(thickness)
	{
		setFillColor(color);
	}
    virtual unsigned int getPointCount() const
	{
		return 4;
	}
    virtual sf::Vector2f getPoint(unsigned int index) const
	{
		// TODO
		return sf::Vector2f(0, 0);
	}
private:
	const sf::Vector2f mPos1, mPos2;
	const float mThickness;
};

LineShape LineFunction (const sf::Vector2f& pos1, const sf::Vector2f& pos2, float thickness, const sf::Color& color)
{
	return LineShape(pos1, pos2, thickness, color);
}

sf::RectangleShape RectangleFunction(const sf::Vector2f& position, const sf::Vector2f& size, const sf::Color& fillColor, float outlineThickness, const sf::Color& outlineColor)
{
	sf::RectangleShape shape(size);
	shape.setPosition(position);
	shape.setFillColor(fillColor);
	shape.setOutlineThickness(outlineThickness);
	shape.setOutlineColor(outlineColor);
	return shape;
}

void LuabindSFMLShape(lua_State* L)
{

    luabind::module(L, "sf")
    [
        luabind::class_<sf::Shape, luabind::bases<sf::Drawable, sf::Transformable> >("Shape")
            .scope
            [
                luabind::def("Circle", &CircleFunction),
                luabind::def("Line", &LineFunction),
                luabind::def("Rectangle", &RectangleFunction)
            ]
            .def("SetColor", &sf::Shape::setFillColor)
            .def("GetColor", &sf::Shape::getFillColor),
		luabind::class_<sf::CircleShape, sf::Shape>("CircleShape"),
		luabind::class_<sf::RectangleShape, sf::Shape>("RectangleShape"),
		luabind::class_<LineShape, sf::Shape>("LineShape")
    ];
}

}
