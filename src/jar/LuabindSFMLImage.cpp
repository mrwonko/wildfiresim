#include "jar/LuabindSFML.h"
#include <lua.hpp>
#include <luabind/class.hpp>
#include <luabind/operator.hpp>
#include <SFML/Graphics/Image.hpp>
#include <SFML/Graphics/RenderWindow.hpp>

namespace jar
{

void LuabindSFMLImage(lua_State* L)
{
    luabind::module(L, "sf")
    [
        luabind::class_<sf::Image>("Image")
            .def(luabind::constructor<>())
            .def(luabind::constructor<const sf::Image&>())
            .def(luabind::constructor<unsigned int, unsigned int>())
            .def(luabind::constructor<unsigned int, unsigned int, const sf::Color&>())
            .def(luabind::constructor<unsigned int, unsigned int, const sf::Uint8*>())
            .def("LoadFromFile", &sf::Image::LoadFromFile)
            .def("LoadFromMemory", &sf::Image::LoadFromMemory)
            .def("LoadFromPixels", &sf::Image::LoadFromPixels)
            //.def("SaveToFile", &sf::Image::SaveToFile)
            .def("Create", &sf::Image::Create)
            .def("CreateMaskFrom", &sf::Image::CreateMaskFromColor)
            .def("Copy", &sf::Image::Copy)
            .def("CopyScreen", &sf::Image::CopyScreen)
            .def("SetPixel", &sf::Image::SetPixel)
            .def("GetPixel", &sf::Image::GetPixel)
            .def("GetPixelsPtr", &sf::Image::GetPixelsPtr)
            .def("Bind", &sf::Image::Bind)
            .def("SetSmooth", &sf::Image::SetSmooth)
            .def("GetWidth", &sf::Image::GetWidth)
            .def("GetHeight", &sf::Image::GetHeight)
            .def("IsSmooth", &sf::Image::IsSmooth)
            .def("GetTexCoords", &sf::Image::GetTexCoords)
    ];
}

}
