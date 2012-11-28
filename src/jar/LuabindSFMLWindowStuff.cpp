#include "jar/LuabindSFML.h"
#include <lua.hpp>
#include <luabind/class.hpp>
#include <luabind/operator.hpp>
#include <SFML/Window/Event.hpp>
#include <SFML/Window/Window.hpp>
#include <SFML/Graphics/View.hpp>
#include <SFML/Window/VideoMode.hpp>
#include <SFML/Graphics/RenderTarget.hpp>
#include <SFML/Graphics/RenderWindow.hpp>
#include <SFML/Graphics/Drawable.hpp>
#include <map>

namespace jar
{

void RenderTargetDrawDefault(sf::RenderTarget& target, const sf::Drawable& drawable)
{
	target.draw(drawable);
}

void RenderTargetDrawAdditive(sf::RenderTarget& target, const sf::Drawable& drawable)
{
	sf::RenderStates states;
	states.blendMode = sf::BlendAdd;
	target.draw(drawable, states);
}

void RenderTargetDrawAlpha(sf::RenderTarget& target, const sf::Drawable& drawable)
{
	sf::RenderStates states;
	states.blendMode = sf::BlendAlpha;
	target.draw(drawable, states);
}

class luabind_dummy_style{};
class luabind_dummy_mouse{};
class luabind_dummy_joy{};
class luabind_dummy_key{};
class luabind_dummy_blend{};

class Input
{
public:
	Input(const sf::Window& window) : mWindow(window) {}
    bool IsKeyDown(sf::Keyboard::Key key)
	{
		return sf::Keyboard::isKeyPressed(key);
	}
    int GetMouseX()
	{
		return sf::Mouse::getPosition(mWindow).x;
	}
    int GetMouseY()
	{
		return sf::Mouse::getPosition(mWindow).y;
	}
    bool IsMouseButtonDown(sf::Mouse::Button button)
	{
		return sf::Mouse::isButtonPressed(button);
	}
private:
	const sf::Window& mWindow;
};

Input WindowGetInput(const sf::Window& window)
{
	return Input(window);
};

void WindowSetCursorPosition(const sf::Window& window, int posX, int posY)
{
	sf::Mouse::setPosition(sf::Vector2i(posX, posY), window);
}

void ViewSetHalfSize(sf::View& view, const sf::Vector2f& halfSize)
{
	view.setSize(halfSize * 2.f);
}

void ViewSetHalfSize(sf::View& view, const float halfSizeX, const float halfSizeY)
{
	view.setSize(halfSizeX * 2.f, halfSizeY * 2.f);
}

sf::Vector2f ViewGetHalfSize(const sf::View& view)
{
	return view.getSize() / 2.f;
}

typedef std::map<const sf::Window*, sf::Clock> WindowClocks;
WindowClocks& GetWindowClocks()
{
	static WindowClocks s_windowClocks;
	return s_windowClocks;
}

float WindowGetFrameTime(const sf::Window& window)
{
	if( GetWindowClocks().find(&window) == GetWindowClocks().end() )
	{
		return 0.f;
	}
	else
	{
		return GetWindowClocks()[&window].getElapsedTime().asSeconds();
	}
}

void WindowShow(sf::Window& window)
{
	window.display();
	GetWindowClocks()[&window] = sf::Clock();
}

void LuabindSFMLWindowStuff(lua_State* L)
{
    luabind::module(L, "sf")
    [
        luabind::class_<luabind_dummy_style>("Style")
            .enum_("noname")
            [
                luabind::value("None", (unsigned long)sf::Style::None),
                luabind::value("Titlebar", (unsigned long)sf::Style::Titlebar),
                luabind::value("Resize", (unsigned long)sf::Style::Resize),
                luabind::value("Close", (unsigned long)sf::Style::Close),
                luabind::value("Fullscreen", (unsigned long)sf::Style::Fullscreen)
            ],

        luabind::class_<luabind_dummy_blend>("Blend")
            .enum_("Mode")
            [
                luabind::value("Alpha", (unsigned long)sf::BlendAlpha),
                luabind::value("Add", (unsigned long)sf::BlendAdd),
                luabind::value("Multiply", (unsigned long)sf::BlendMultiply),
                luabind::value("None", (unsigned long)sf::BlendNone)
            ],

        luabind::class_<luabind_dummy_mouse>("Mouse")
            .enum_("Button")
            [
                luabind::value("Left", (unsigned long)sf::Mouse::Left),
                luabind::value("Right", (unsigned long)sf::Mouse::Right),
                luabind::value("Middle", (unsigned long)sf::Mouse::Middle),
                luabind::value("XButton1", (unsigned long)sf::Mouse::XButton1),
                luabind::value("XButton2", (unsigned long)sf::Mouse::XButton2)
            ],

        luabind::class_<luabind_dummy_joy>("Joy")
            .enum_("Axis")
            [
				luabind::value("AxisX", (unsigned long)sf::Joystick::Axis::X),
                luabind::value("AxisY", (unsigned long)sf::Joystick::Axis::Y),
                luabind::value("AxisZ", (unsigned long)sf::Joystick::Axis::Z),
                luabind::value("AxisR", (unsigned long)sf::Joystick::Axis::R),
                luabind::value("AxisU", (unsigned long)sf::Joystick::Axis::U),
                luabind::value("AxisV", (unsigned long)sf::Joystick::Axis::V),
				luabind::value("AxisPovX", (unsigned long)sf::Joystick::Axis::PovX),
				luabind::value("AxisPovY", (unsigned long)sf::Joystick::Axis::PovY)
            ]
            .enum_("noname")
            [
                luabind::value("Count", (unsigned long)sf::Joystick::Count),
                luabind::value("ButtonCount", (unsigned long)sf::Joystick::ButtonCount)
            ],

        luabind::class_<luabind_dummy_key>("Key")
            .enum_("Code")
            [
                luabind::value("A", sf::Keyboard::A),
                luabind::value("B", sf::Keyboard::B),
                luabind::value("C", sf::Keyboard::C),
                luabind::value("D", sf::Keyboard::D),
                luabind::value("E", sf::Keyboard::E),
                luabind::value("F", sf::Keyboard::F),
                luabind::value("G", sf::Keyboard::G),
                luabind::value("H", sf::Keyboard::H),
                luabind::value("I", sf::Keyboard::I),
                luabind::value("J", sf::Keyboard::J),
                luabind::value("K", sf::Keyboard::K),
                luabind::value("L", sf::Keyboard::L),
                luabind::value("M", sf::Keyboard::M),
                luabind::value("N", sf::Keyboard::N),
                luabind::value("O", sf::Keyboard::O),
                luabind::value("P", sf::Keyboard::P),
                luabind::value("Q", sf::Keyboard::Q),
                luabind::value("R", sf::Keyboard::R),
                luabind::value("S", sf::Keyboard::S),
                luabind::value("T", sf::Keyboard::T),
                luabind::value("U", sf::Keyboard::U),
                luabind::value("V", sf::Keyboard::V),
                luabind::value("W", sf::Keyboard::W),
                luabind::value("X", sf::Keyboard::X),
                luabind::value("Y", sf::Keyboard::Y),
                luabind::value("Z", sf::Keyboard::Z),
                luabind::value("Num0", sf::Keyboard::Num0),
                luabind::value("Num1", sf::Keyboard::Num1),
                luabind::value("Num2", sf::Keyboard::Num2),
                luabind::value("Num3", sf::Keyboard::Num3),
                luabind::value("Num4", sf::Keyboard::Num4),
                luabind::value("Num5", sf::Keyboard::Num5),
                luabind::value("Num6", sf::Keyboard::Num6),
                luabind::value("Num7", sf::Keyboard::Num7),
                luabind::value("Num8", sf::Keyboard::Num8),
                luabind::value("Num9", sf::Keyboard::Num9),
                luabind::value("Escape", sf::Keyboard::Escape),
                luabind::value("LControl", sf::Keyboard::LControl),
                luabind::value("LShift", sf::Keyboard::LShift),
                luabind::value("LAlt", sf::Keyboard::LAlt),
                luabind::value("LSystem", sf::Keyboard::LSystem),
                luabind::value("RControl", sf::Keyboard::RControl),
                luabind::value("RShift", sf::Keyboard::RShift),
                luabind::value("RAlt", sf::Keyboard::RAlt),
                luabind::value("RSystem", sf::Keyboard::RSystem),
                luabind::value("Menu", sf::Keyboard::Menu),
                luabind::value("LBracket", sf::Keyboard::LBracket),
                luabind::value("RBracket", sf::Keyboard::RBracket),
                luabind::value("SemiColon", sf::Keyboard::SemiColon),
                luabind::value("Comma", sf::Keyboard::Comma),
                luabind::value("Period", sf::Keyboard::Period),
                luabind::value("Quote", sf::Keyboard::Quote),
                luabind::value("Slash", sf::Keyboard::Slash),
                luabind::value("BackSlash", sf::Keyboard::BackSlash),
                luabind::value("Tilde", sf::Keyboard::Tilde),
                luabind::value("Equal", sf::Keyboard::Equal),
                luabind::value("Dash", sf::Keyboard::Dash),
                luabind::value("Space", sf::Keyboard::Space),
                luabind::value("Return", sf::Keyboard::Return),
                luabind::value("Back", sf::Keyboard::BackSpace),
                luabind::value("Tab", sf::Keyboard::Tab),
                luabind::value("PageUp", sf::Keyboard::PageUp),
                luabind::value("PageDown", sf::Keyboard::PageDown),
                luabind::value("End", sf::Keyboard::End),
                luabind::value("Home", sf::Keyboard::Home),
                luabind::value("Insert", sf::Keyboard::Insert),
                luabind::value("Delete", sf::Keyboard::Delete),
                luabind::value("Add", sf::Keyboard::Add),
                luabind::value("Subtract", sf::Keyboard::Subtract),
                luabind::value("Multiply", sf::Keyboard::Multiply),
                luabind::value("Divide", sf::Keyboard::Divide),
                luabind::value("Left", sf::Keyboard::Left),
                luabind::value("Right", sf::Keyboard::Right),
                luabind::value("Up", sf::Keyboard::Up),
                luabind::value("Down", sf::Keyboard::Down),
                luabind::value("Numpad0", sf::Keyboard::Numpad0),
                luabind::value("Numpad1", sf::Keyboard::Numpad1),
                luabind::value("Numpad2", sf::Keyboard::Numpad2),
                luabind::value("Numpad3", sf::Keyboard::Numpad3),
                luabind::value("Numpad4", sf::Keyboard::Numpad4),
                luabind::value("Numpad5", sf::Keyboard::Numpad5),
                luabind::value("Numpad6", sf::Keyboard::Numpad6),
                luabind::value("Numpad7", sf::Keyboard::Numpad7),
                luabind::value("Numpad8", sf::Keyboard::Numpad8),
                luabind::value("Numpad9", sf::Keyboard::Numpad9),
                luabind::value("F1", sf::Keyboard::F1),
                luabind::value("F2", sf::Keyboard::F2),
                luabind::value("F3", sf::Keyboard::F3),
                luabind::value("F4", sf::Keyboard::F4),
                luabind::value("F5", sf::Keyboard::F5),
                luabind::value("F6", sf::Keyboard::F6),
                luabind::value("F7", sf::Keyboard::F7),
                luabind::value("F8", sf::Keyboard::F8),
                luabind::value("F9", sf::Keyboard::F9),
                luabind::value("F10", sf::Keyboard::F10),
                luabind::value("F11", sf::Keyboard::F11),
                luabind::value("F12", sf::Keyboard::F12),
                luabind::value("F13", sf::Keyboard::F13),
                luabind::value("F14", sf::Keyboard::F14),
                luabind::value("F15", sf::Keyboard::F15),
                luabind::value("Pause", sf::Keyboard::Pause)
            ],

        luabind::class_<sf::Event>("Event")
            .def(luabind::constructor<>())
            .def_readonly("Type", &sf::Event::type)
            //the event union - depends on Type.
            .def_readonly("Text", &sf::Event::text)
            .def_readonly("Size", &sf::Event::size)
            .def_readonly("MouseWheel", &sf::Event::mouseWheel)
            .def_readonly("MouseMove", &sf::Event::mouseMove)
            .def_readonly("MouseButton", &sf::Event::mouseButton)
            .def_readonly("JoyMove", &sf::Event::joystickMove)
			.def_readonly("JoyButton", &sf::Event::joystickButton)
            .def_readonly("Key", &sf::Event::key)
            //nested classes
            .scope
            [
                luabind::class_<sf::Event::JoystickButtonEvent>("JoyButtonEvent")
                    .def_readonly("Button", &sf::Event::JoystickButtonEvent::button)
                    .def_readonly("JoystickId", &sf::Event::JoystickButtonEvent::joystickId),

                luabind::class_<sf::Event::JoystickMoveEvent>("JoyMoveEvent")
                    .def_readonly("Axis", &sf::Event::JoystickMoveEvent::axis)
                    .def_readonly("Position", &sf::Event::JoystickMoveEvent::position)
                    .def_readonly("JoystickId", &sf::Event::JoystickMoveEvent::joystickId),

                luabind::class_<sf::Event::KeyEvent>("KeyEvent")
                    .def_readonly("Alt", &sf::Event::KeyEvent::alt)
                    .def_readonly("Code", &sf::Event::KeyEvent::code)
                    .def_readonly("Control", &sf::Event::KeyEvent::control)
                    .def_readonly("Shift", &sf::Event::KeyEvent::shift),

                luabind::class_<sf::Event::MouseButtonEvent>("MouseButtonEvent")
                    .def_readonly("Button", &sf::Event::MouseButtonEvent::button)
                    .def_readonly("X", &sf::Event::MouseButtonEvent::x)
                    .def_readonly("Y", &sf::Event::MouseButtonEvent::y),

                luabind::class_<sf::Event::MouseMoveEvent>("MouseMoveEvent")
                    .def_readonly("X", &sf::Event::MouseMoveEvent::x)
                    .def_readonly("Y", &sf::Event::MouseMoveEvent::y),

                luabind::class_<sf::Event::MouseWheelEvent>("MouseWheelEvent")
                    .def_readonly("Delta", &sf::Event::MouseWheelEvent::delta),

                luabind::class_<sf::Event::SizeEvent>("SizeEvent")
                    .def_readonly("Height", &sf::Event::SizeEvent::height)
                    .def_readonly("Width", &sf::Event::SizeEvent::width),

                luabind::class_<sf::Event::TextEvent>("TextEvent")
                    .def_readonly("Unicode", &sf::Event::TextEvent::unicode)
            ]
            .enum_("EventType")
            [
                luabind::value("Closed", (unsigned long)sf::Event::Closed),
                luabind::value("Resized", (unsigned long)sf::Event::Resized),
                luabind::value("LostFocus", (unsigned long)sf::Event::LostFocus),
                luabind::value("GainedFocus", (unsigned long)sf::Event::GainedFocus),
                luabind::value("TextEntered", (unsigned long)sf::Event::TextEntered),
                luabind::value("KeyPressed", (unsigned long)sf::Event::KeyPressed),
                luabind::value("KeyReleased", (unsigned long)sf::Event::KeyReleased),
                luabind::value("MouseWheelMoved", (unsigned long)sf::Event::MouseWheelMoved),
                luabind::value("MouseButtonPressed", (unsigned long)sf::Event::MouseButtonPressed),
                luabind::value("MouseButtonReleased", (unsigned long)sf::Event::MouseButtonReleased),
                luabind::value("MouseMoved", (unsigned long)sf::Event::MouseMoved),
                luabind::value("MouseEntered", (unsigned long)sf::Event::MouseEntered),
                luabind::value("MouseLeft", (unsigned long)sf::Event::MouseLeft),
                luabind::value("JoyButtonPressed", (unsigned long)sf::Event::JoystickButtonPressed),
                luabind::value("JoyButtonReleased", (unsigned long)sf::Event::JoystickButtonReleased),
                luabind::value("JoyMoved", (unsigned long)sf::Event::JoystickMoved)
            ],

        luabind::class_<Input>("Input")
            .def("IsKeyDown", &Input::IsKeyDown)
            .def("GetMouseX", &Input::GetMouseX)
            .def("GetMouseY", &Input::GetMouseY)
            .def("IsMouseButtonDown", &Input::IsMouseButtonDown),

        luabind::class_<sf::Window>("Window")
            .def("Close", &sf::Window::close)
            .def("Display", &sf::Window::display)
            .def("EnableKeyRepeat", &sf::Window::setKeyRepeatEnabled)
            .def("GetEvent", &sf::Window::pollEvent)
            .def("GetFrameTime", &WindowGetFrameTime)
            .def("GetSize", &sf::Window::getSize)
            .def("GetInput", &WindowGetInput)
            .def("GetSettings", &sf::Window::getSettings)
            .def("IsOpened", &sf::Window::isOpen)
            .def("SetActive", &sf::Window::setActive)
            .def("SetCursorPosition", &WindowSetCursorPosition)
            .def("SetFramerateLimit", &sf::Window::setFramerateLimit)
            .def("SetIcon", &sf::Window::setIcon)
            .def("SetJoystickThreshold", &sf::Window::setJoystickThreshold)
            .def("SetPosition", &sf::Window::setPosition)
            .def("SetSize", &sf::Window::setSize)
            .def("Show", &WindowShow)
            .def("ShowMouseCursor", &sf::Window::setMouseCursorVisible)
            .def("GetInput", &WindowGetInput),

        luabind::class_<sf::View>("View")
            .def(luabind::constructor<>())
            .def(luabind::constructor<const sf::FloatRect&>())
            .def(luabind::constructor<const sf::Vector2f&, const sf::Vector2f&>())
            //overloaded function
            .def("SetCenter", (void(sf::View::*)(const sf::Vector2f&))&sf::View::setCenter)
            .def("SetCenter", (void(sf::View::*)(float, float))&sf::View::setCenter)
            .def("SetHalfSize", (void(*)(sf::View&, const sf::Vector2f&))&ViewSetHalfSize)
            .def("SetHalfSize", (void(*)(sf::View&, float, float))&ViewSetHalfSize)
            .def("Move", (void(sf::View::*)(const sf::Vector2f&))&sf::View::move)
            .def("Move", (void(sf::View::*)(float, float))&sf::View::move)
            .def("SetFromRect", &sf::View::setViewport)
            .def("GetCenter", &sf::View::getCenter)
            .def("GetHalfSize", &ViewGetHalfSize)
			.def("GetRect", &sf::View::getViewport)
            .def("Zoom", &sf::View::zoom),

        luabind::class_<sf::VideoMode>("VideoMode")
            .def(luabind::constructor<>())
            .def(luabind::constructor<unsigned int, unsigned int>())
            .def(luabind::constructor<unsigned int, unsigned int, unsigned int>())
            .def("IsValid", &sf::VideoMode::isValid),

        luabind::class_<sf::RenderTarget>("RenderTarget")
            .def("Clear", &sf::RenderTarget::clear)
            .def("Draw", &RenderTargetDrawDefault)
            .def("DrawAdditive", &RenderTargetDrawAdditive)
			.def("DrawAlpha", &RenderTargetDrawAlpha)
            .def("GetSize", &sf::RenderTarget::getSize)
            .def("SetView", &sf::RenderTarget::setView)
            .def("GetView", &sf::RenderTarget::getView)
            .def("GetDefaultView", &sf::RenderTarget::getDefaultView),

        luabind::class_<sf::RenderWindow, luabind::bases<sf::Window, sf::RenderTarget> >("RenderWindow")
            .def(luabind::constructor<>())
            .def(luabind::constructor<sf::VideoMode, const std::string&>())
            .def(luabind::constructor<sf::VideoMode, const std::string&, unsigned long>())
            .def("Capture", &sf::RenderWindow::capture)
            .def("ConvertCoords", (const sf::Vector2f (sf::RenderTarget::*)(const sf::Vector2i&) const) &sf::RenderWindow::convertCoords)
    ];
}

} //namespace jar

