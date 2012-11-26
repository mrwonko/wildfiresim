#include "jar/LuabindSFML.h"
#include <lua.hpp>
#include <luabind/class.hpp>
#include <SFML/Graphics/Drawable.hpp>

namespace jar
{

void LuabindSFMLDrawable(lua_State* L)
{
    luabind::module(L, "sf")
    [
        luabind::class_<sf::Drawable>("Drawable")
            .def("SetPosition", (void(sf::Drawable::*)(float, float))&sf::Drawable::SetPosition)
            .def("SetPosition", (void(sf::Drawable::*)(const sf::Vector2f&))&sf::Drawable::SetPosition)
            .def("SetX", &sf::Drawable::SetX)
            .def("SetY", &sf::Drawable::SetY)
            .def("SetScale", (void(sf::Drawable::*)(float, float))&sf::Drawable::SetScale)
            .def("SetScale", (void(sf::Drawable::*)(const sf::Vector2f&))&sf::Drawable::SetScale)
            .def("SetCenter", (void(sf::Drawable::*)(float, float))&sf::Drawable::SetCenter)
            .def("SetCenter", (void(sf::Drawable::*)(const sf::Vector2f&))&sf::Drawable::SetCenter)
            .def("SetScaleX", &sf::Drawable::SetScaleX)
            .def("SetScaleY", &sf::Drawable::SetScaleY)
            .def("SetRotation", &sf::Drawable::SetRotation)
            .def("SetColor", &sf::Drawable::SetColor)
            .def("SetBlendMode", &sf::Drawable::SetBlendMode)
            .def("GetPosition", &sf::Drawable::GetPosition)
            .def("GetScale", &sf::Drawable::GetScale)
            .def("GetCenter", &sf::Drawable::GetCenter)
            .def("GetRotation", &sf::Drawable::GetRotation)
            .def("GetColor", &sf::Drawable::GetColor)
            .def("GetBlendMode", &sf::Drawable::GetBlendMode)
            .def("Move", (void(sf::Drawable::*)(float, float))&sf::Drawable::Move)
            .def("Move", (void(sf::Drawable::*)(const sf::Vector2f&))&sf::Drawable::Move)
            .def("Scale", (void(sf::Drawable::*)(float, float))&sf::Drawable::Scale)
            .def("Scale", (void(sf::Drawable::*)(const sf::Vector2f&))&sf::Drawable::Scale)
            .def("Rotate", &sf::Drawable::Rotate)
            .def("TransformToLocal", &sf::Drawable::TransformToLocal)
            .def("TransformToGlobal", &sf::Drawable::TransformToGlobal)
    ];
}

}
