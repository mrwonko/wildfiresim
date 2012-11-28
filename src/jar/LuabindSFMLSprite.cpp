#include "jar/LuabindSFML.h"
#include <lua.hpp>
#include <luabind/class.hpp>
#include <SFML/Graphics/Image.hpp>
#include <SFML/Graphics/Sprite.hpp>
#include <SFML/Graphics/Texture.hpp>

namespace jar
{

void SpriteResize(sf::Sprite& spr, sf::Vector2f size)
{
	const sf::Texture* tex = spr.getTexture();
	assert(tex && "Sprite::Resize called on a sprite with no texture!");
	sf::Vector2u texSize = tex->getSize();
	spr.setScale(size.x / texSize.x, size.y / texSize.y);
}

class SpriteHelper : public sf::Sprite
{
public:
	SpriteHelper() {}
	SpriteHelper(const sf::Texture& tex) : sf::Sprite(tex) {}
	SpriteHelper(const sf::Texture& tex, const sf::Vector2f& size) : sf::Sprite(tex) { SpriteResize(*this, size); }
};

void LuabindSFMLSprite(lua_State* L)
{
    luabind::module(L, "sf")
    [
        luabind::class_<SpriteHelper, luabind::bases<sf::Drawable, sf::Transformable> >("Sprite")
            .def(luabind::constructor<>())
            .def(luabind::constructor<const sf::Texture&>())
            .def(luabind::constructor<const sf::Texture&, const sf::Vector2f&>())
            .def("SetImage", &sf::Sprite::setTexture)
            .def("SetSubRect", &sf::Sprite::setTextureRect)
            .def("Resize", &SpriteResize)
            .def("GetImage", &sf::Sprite::getTexture)
            .def("GetSubRect", &sf::Sprite::setTextureRect)
            .def("SetColor", &sf::Sprite::setColor)
            .def("GetColor", &sf::Sprite::getColor)
    ];
}

}
