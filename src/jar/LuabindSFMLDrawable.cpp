#include "jar/LuabindSFML.h"
#include <lua.hpp>
#include <luabind/class.hpp>
#include <SFML/Graphics/Drawable.hpp>
#include <SFML/Graphics/Transformable.hpp>

namespace jar
{

	void TransformableSetX(sf::Transformable& t, float x)
	{
		sf::Vector2f pos = t.getPosition();
		pos.x = x;
		t.setPosition( pos );
	}

	void TransformableSetY(sf::Transformable& t, float y)
	{
		sf::Vector2f pos = t.getPosition();
		pos.y = y;
		t.setPosition( pos );
	}

	void TransformableSetScaleX(sf::Transformable& t, float x)
	{
		sf::Vector2f scale = t.getScale();
		scale.x = x;
		t.setScale( scale );
	}

	void TransformableSetScaleY(sf::Transformable& t, float y)
	{
		sf::Vector2f scale = t.getScale();
		scale.y = y;
		t.setScale( scale );
	}

void LuabindSFMLDrawable(lua_State* L)
{
    luabind::module(L, "sf")
    [
		luabind::class_<sf::Transformable>("Transformable")
            .def("SetPosition", (void(sf::Transformable::*)(float, float))&sf::Transformable::setPosition)
            .def("SetPosition", (void(sf::Transformable::*)(const sf::Vector2f&))&sf::Transformable::setPosition)
            .def("SetX", &TransformableSetX)
            .def("SetY", &TransformableSetY)
            .def("SetScale", (void(sf::Transformable::*)(float, float))&sf::Transformable::setScale)
            .def("SetScale", (void(sf::Transformable::*)(const sf::Vector2f&))&sf::Transformable::setScale)
            .def("SetCenter", (void(sf::Transformable::*)(float, float))&sf::Transformable::setOrigin)
            .def("SetCenter", (void(sf::Transformable::*)(const sf::Vector2f&))&sf::Transformable::setOrigin)
            .def("SetScaleX", &TransformableSetScaleX)
            .def("SetScaleY", &TransformableSetScaleY)
            .def("SetRotation", &sf::Transformable::setRotation)
            .def("GetPosition", &sf::Transformable::getPosition)
            .def("GetScale", &sf::Transformable::getScale)
            .def("GetCenter", &sf::Transformable::getOrigin)
            .def("GetRotation", &sf::Transformable::getRotation)
            .def("Move", (void(sf::Transformable::*)(float, float))&sf::Transformable::move)
            .def("Move", (void(sf::Transformable::*)(const sf::Vector2f&))&sf::Transformable::move)
            .def("Scale", (void(sf::Transformable::*)(float, float))&sf::Transformable::scale)
            .def("Scale", (void(sf::Transformable::*)(const sf::Vector2f&))&sf::Transformable::scale)
            .def("Rotate", &sf::Transformable::rotate),
        luabind::class_<sf::Drawable>("Drawable")
    ];
}

}
