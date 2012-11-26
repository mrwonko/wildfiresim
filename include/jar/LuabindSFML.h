#ifndef JAR_LUABIND_SFML_H
#define JAR_LUABIND_SFML_H

struct lua_State;

namespace jar
{

/** \brief Binds sf::Vector2f to Lua via luabind. **/
void LuabindSFMLMath(lua_State* L);

/** \brief Binds a lot of window stuff to Lua using luabind. Requires LuabindSFMLMath().

    For sf.RenderWindow.Capture you also need LuabindSFMLImage().
    For sf.RenderWindow.Draw you also need LuabindSFMLDrawable().

    Contains: sf::Event (+the Events), sf::WindowSettings, sf::Window, sf::View, sf::RenderTarget and sf::RenderWindow **/
void LuabindSFMLWindowStuff(lua_State* L);

/** \brief Binds sf::Drawable to Lua via luabind. Requires LuabindSFMLMath(). **/
void LuabindSFMLDrawable(lua_State* L);

/** \brief Binds sf::String to Lua via luabind. Requires LuabindSFMLDrawable(). **/
void LuabindSFMLString(lua_State* L);

/** \brief Binds sf::Image to Lua via luabind. Requires LuabindSFMLMath(). **/
void LuabindSFMLImage(lua_State* L);

/** \brief Binds sf::Sprite to Lua via luabind. Requires LuabindSFMLDrawable() **/
void LuabindSFMLSprite(lua_State* L);


/** \brief binds sf::Shape to Lua via luabind. Requires LuabindSFMLDrawable() **/
void LuabindSFMLShape(lua_State* L);

} //namespace jar

#endif //JAR_LUABIND_SFML_H
