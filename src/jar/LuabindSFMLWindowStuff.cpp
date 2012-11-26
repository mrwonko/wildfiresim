#include "jar/LuabindSFML.h"
#include <lua.hpp>
#include <luabind/class.hpp>
#include <luabind/operator.hpp>
#include <SFML/Window/Event.hpp>
#include <SFML/Window/WindowSettings.hpp>
#include <SFML/Window/Window.hpp>
#include <SFML/Window/Input.hpp>
#include <SFML/Graphics/View.hpp>
#include <SFML/Window/VideoMode.hpp>
#include <SFML/Graphics/RenderTarget.hpp>
#include <SFML/Graphics/RenderWindow.hpp>
#include <SFML/Graphics/Drawable.hpp>

namespace jar
{

class luabind_dummy_style{};
class luabind_dummy_mouse{};
class luabind_dummy_joy{};
class luabind_dummy_key{};
class luabind_dummy_blend{};

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
                luabind::value("Alpha", (unsigned long)sf::Blend::Alpha),
                luabind::value("Add", (unsigned long)sf::Blend::Add),
                luabind::value("Multiply", (unsigned long)sf::Blend::Multiply),
                luabind::value("None", (unsigned long)sf::Blend::None)
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
                luabind::value("AxisX", (unsigned long)sf::Joy::AxisX),
                luabind::value("AxisY", (unsigned long)sf::Joy::AxisY),
                luabind::value("AxisZ", (unsigned long)sf::Joy::AxisZ),
                luabind::value("AxisR", (unsigned long)sf::Joy::AxisR),
                luabind::value("AxisU", (unsigned long)sf::Joy::AxisU),
                luabind::value("AxisV", (unsigned long)sf::Joy::AxisV),
                luabind::value("AxisPOV", (unsigned long)sf::Joy::AxisPOV)
            ]
            .enum_("noname")
            [
                luabind::value("Count", (unsigned long)sf::Joy::Count),
                luabind::value("ButtonCount", (unsigned long)sf::Joy::ButtonCount)
            ],

        luabind::class_<luabind_dummy_key>("Key")
            .enum_("Code")
            [
                luabind::value("A", sf::Key::A),
                luabind::value("B", sf::Key::B),
                luabind::value("C", sf::Key::C),
                luabind::value("D", sf::Key::D),
                luabind::value("E", sf::Key::E),
                luabind::value("F", sf::Key::F),
                luabind::value("G", sf::Key::G),
                luabind::value("H", sf::Key::H),
                luabind::value("I", sf::Key::I),
                luabind::value("J", sf::Key::J),
                luabind::value("K", sf::Key::K),
                luabind::value("L", sf::Key::L),
                luabind::value("M", sf::Key::M),
                luabind::value("N", sf::Key::N),
                luabind::value("O", sf::Key::O),
                luabind::value("P", sf::Key::P),
                luabind::value("Q", sf::Key::Q),
                luabind::value("R", sf::Key::R),
                luabind::value("S", sf::Key::S),
                luabind::value("T", sf::Key::T),
                luabind::value("U", sf::Key::U),
                luabind::value("V", sf::Key::V),
                luabind::value("W", sf::Key::W),
                luabind::value("X", sf::Key::X),
                luabind::value("Y", sf::Key::Y),
                luabind::value("Z", sf::Key::Z),
                luabind::value("Num0", sf::Key::Num0),
                luabind::value("Num1", sf::Key::Num1),
                luabind::value("Num2", sf::Key::Num2),
                luabind::value("Num3", sf::Key::Num3),
                luabind::value("Num4", sf::Key::Num4),
                luabind::value("Num5", sf::Key::Num5),
                luabind::value("Num6", sf::Key::Num6),
                luabind::value("Num7", sf::Key::Num7),
                luabind::value("Num8", sf::Key::Num8),
                luabind::value("Num9", sf::Key::Num9),
                luabind::value("Escape", sf::Key::Escape),
                luabind::value("LControl", sf::Key::LControl),
                luabind::value("LShift", sf::Key::LShift),
                luabind::value("LAlt", sf::Key::LAlt),
                luabind::value("LSystem", sf::Key::LSystem),
                luabind::value("RControl", sf::Key::RControl),
                luabind::value("RShift", sf::Key::RShift),
                luabind::value("RAlt", sf::Key::RAlt),
                luabind::value("RSystem", sf::Key::RSystem),
                luabind::value("Menu", sf::Key::Menu),
                luabind::value("LBracket", sf::Key::LBracket),
                luabind::value("RBracket", sf::Key::RBracket),
                luabind::value("SemiColon", sf::Key::SemiColon),
                luabind::value("Comma", sf::Key::Comma),
                luabind::value("Period", sf::Key::Period),
                luabind::value("Quote", sf::Key::Quote),
                luabind::value("Slash", sf::Key::Slash),
                luabind::value("BackSlash", sf::Key::BackSlash),
                luabind::value("Tilde", sf::Key::Tilde),
                luabind::value("Equal", sf::Key::Equal),
                luabind::value("Dash", sf::Key::Dash),
                luabind::value("Space", sf::Key::Space),
                luabind::value("Return", sf::Key::Return),
                luabind::value("Back", sf::Key::Back),
                luabind::value("Tab", sf::Key::Tab),
                luabind::value("PageUp", sf::Key::PageUp),
                luabind::value("PageDown", sf::Key::PageDown),
                luabind::value("End", sf::Key::End),
                luabind::value("Home", sf::Key::Home),
                luabind::value("Insert", sf::Key::Insert),
                luabind::value("Delete", sf::Key::Delete),
                luabind::value("Add", sf::Key::Add),
                luabind::value("Subtract", sf::Key::Subtract),
                luabind::value("Multiply", sf::Key::Multiply),
                luabind::value("Divide", sf::Key::Divide),
                luabind::value("Left", sf::Key::Left),
                luabind::value("Right", sf::Key::Right),
                luabind::value("Up", sf::Key::Up),
                luabind::value("Down", sf::Key::Down),
                luabind::value("Numpad0", sf::Key::Numpad0),
                luabind::value("Numpad1", sf::Key::Numpad1),
                luabind::value("Numpad2", sf::Key::Numpad2),
                luabind::value("Numpad3", sf::Key::Numpad3),
                luabind::value("Numpad4", sf::Key::Numpad4),
                luabind::value("Numpad5", sf::Key::Numpad5),
                luabind::value("Numpad6", sf::Key::Numpad6),
                luabind::value("Numpad7", sf::Key::Numpad7),
                luabind::value("Numpad8", sf::Key::Numpad8),
                luabind::value("Numpad9", sf::Key::Numpad9),
                luabind::value("F1", sf::Key::F1),
                luabind::value("F2", sf::Key::F2),
                luabind::value("F3", sf::Key::F3),
                luabind::value("F4", sf::Key::F4),
                luabind::value("F5", sf::Key::F5),
                luabind::value("F6", sf::Key::F6),
                luabind::value("F7", sf::Key::F7),
                luabind::value("F8", sf::Key::F8),
                luabind::value("F9", sf::Key::F9),
                luabind::value("F10", sf::Key::F10),
                luabind::value("F11", sf::Key::F11),
                luabind::value("F12", sf::Key::F12),
                luabind::value("F13", sf::Key::F13),
                luabind::value("F14", sf::Key::F14),
                luabind::value("F15", sf::Key::F15),
                luabind::value("Pause", sf::Key::Pause)
            ],

        luabind::class_<sf::Event>("Event")
            .def(luabind::constructor<>())
            .def_readonly("Type", &sf::Event::Type)
            //the event union - depends on Type.
            .def_readonly("Text", &sf::Event::Text)
            .def_readonly("Size", &sf::Event::Size)
            .def_readonly("MouseWheel", &sf::Event::MouseWheel)
            .def_readonly("MouseMove", &sf::Event::MouseMove)
            .def_readonly("MouseButton", &sf::Event::MouseButton)
            .def_readonly("JoyMove", &sf::Event::JoyMove)
            .def_readonly("JoyButton", &sf::Event::JoyButton)
            .def_readonly("Key", &sf::Event::Key)
            //nested classes
            .scope
            [
                luabind::class_<sf::Event::JoyButtonEvent>("JoyButtonEvent")
                    .def_readonly("Button", &sf::Event::JoyButtonEvent::Button)
                    .def_readonly("JoystickId", &sf::Event::JoyButtonEvent::JoystickId),

                luabind::class_<sf::Event::JoyMoveEvent>("JoyMoveEvent")
                    .def_readonly("Axis", &sf::Event::JoyMoveEvent::Axis)
                    .def_readonly("Position", &sf::Event::JoyMoveEvent::Position)
                    .def_readonly("JoystickId", &sf::Event::JoyMoveEvent::JoystickId),

                luabind::class_<sf::Event::KeyEvent>("KeyEvent")
                    .def_readonly("Alt", &sf::Event::KeyEvent::Alt)
                    .def_readonly("Code", &sf::Event::KeyEvent::Code)
                    .def_readonly("Control", &sf::Event::KeyEvent::Control)
                    .def_readonly("Shift", &sf::Event::KeyEvent::Shift),

                luabind::class_<sf::Event::MouseButtonEvent>("MouseButtonEvent")
                    .def_readonly("Button", &sf::Event::MouseButtonEvent::Button)
                    .def_readonly("X", &sf::Event::MouseButtonEvent::X)
                    .def_readonly("Y", &sf::Event::MouseButtonEvent::Y),

                luabind::class_<sf::Event::MouseMoveEvent>("MouseMoveEvent")
                    .def_readonly("X", &sf::Event::MouseMoveEvent::X)
                    .def_readonly("Y", &sf::Event::MouseMoveEvent::Y),

                luabind::class_<sf::Event::MouseWheelEvent>("MouseWheelEvent")
                    .def_readonly("Delta", &sf::Event::MouseWheelEvent::Delta),

                luabind::class_<sf::Event::SizeEvent>("SizeEvent")
                    .def_readonly("Height", &sf::Event::SizeEvent::Height)
                    .def_readonly("Width", &sf::Event::SizeEvent::Width),

                luabind::class_<sf::Event::TextEvent>("TextEvent")
                    .def_readonly("Unicode", &sf::Event::TextEvent::Unicode)
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
                luabind::value("JoyButtonPressed", (unsigned long)sf::Event::JoyButtonPressed),
                luabind::value("JoyButtonReleased", (unsigned long)sf::Event::JoyButtonReleased),
                luabind::value("JoyMoved", (unsigned long)sf::Event::JoyMoved)
            ],

        luabind::class_<sf::WindowSettings>("WindowSettings")
            .def(luabind::constructor<>())
            .def(luabind::constructor<unsigned int>())
            .def(luabind::constructor<unsigned int, unsigned int>())
            .def(luabind::constructor<unsigned int, unsigned int, unsigned int>())
            .def_readwrite("DepthBits", &sf::WindowSettings::DepthBits)
            .def_readwrite("StencilBits", &sf::WindowSettings::StencilBits)
            .def_readwrite("AntialiasingLevel", &sf::WindowSettings::AntialiasingLevel),

        luabind::class_<sf::Input>("Input")
            .def("IsKeyDown", &sf::Input::IsKeyDown)
            .def("GetMouseX", &sf::Input::GetMouseX)
            .def("GetMouseY", &sf::Input::GetMouseY)
            .def("IsMouseButtonDown", &sf::Input::IsMouseButtonDown),

        luabind::class_<sf::Window>("Window")
            .def("Close", &sf::Window::Close)
            .def("Display", &sf::Window::Display)
            .def("EnableKeyRepeat", &sf::Window::EnableKeyRepeat)
            .def("GetEvent", &sf::Window::GetEvent)
            .def("GetFrameTime", &sf::Window::GetFrameTime)
            .def("GetHeight", &sf::Window::GetHeight)
            //.def("GetInput", &sf::Window::GetInput)
            .def("GetSettings", &sf::Window::GetSettings)
            .def("GetWidth", &sf::Window::GetWidth)
            .def("IsOpened", &sf::Window::IsOpened)
            .def("SetActive", &sf::Window::SetActive)
            .def("SetCursorPosition", &sf::Window::SetCursorPosition)
            .def("SetFramerateLimit", &sf::Window::SetFramerateLimit)
            .def("SetIcon", &sf::Window::SetIcon)
            .def("SetJoystickThreshold", &sf::Window::SetJoystickThreshold)
            .def("SetPosition", &sf::Window::SetPosition)
            .def("SetSize", &sf::Window::SetSize)
            .def("Show", &sf::Window::Show)
            .def("ShowMouseCursor", &sf::Window::ShowMouseCursor)
            .def("UseVerticalSync", &sf::Window::UseVerticalSync)
            .def("GetInput", &sf::Window::GetInput),

        luabind::class_<sf::View>("View")
            .def(luabind::constructor<>())
            .def(luabind::constructor<const sf::FloatRect&>())
            .def(luabind::constructor<const sf::Vector2f&, const sf::Vector2f&>())
            //overloaded function
            .def("SetCenter", (void(sf::View::*)(const sf::Vector2f&))&sf::View::SetCenter)
            .def("SetCenter", (void(sf::View::*)(float, float))&sf::View::SetCenter)
            .def("SetHalfSize", (void(sf::View::*)(const sf::Vector2f&))&sf::View::SetHalfSize)
            .def("SetHalfSize", (void(sf::View::*)(float, float))&sf::View::SetHalfSize)
            .def("Move", (void(sf::View::*)(const sf::Vector2f&))&sf::View::Move)
            .def("Move", (void(sf::View::*)(float, float))&sf::View::Move)
            .def("SetFromRect", &sf::View::SetFromRect)
            .def("GetCenter", &sf::View::GetCenter)
            .def("GetHalfSize", &sf::View::GetHalfSize)
            .def("GetRect", &sf::View::GetRect)
            .def("Zoom", &sf::View::Zoom),

        luabind::class_<sf::VideoMode>("VideoMode")
            .def(luabind::constructor<>())
            .def(luabind::constructor<unsigned int, unsigned int>())
            .def(luabind::constructor<unsigned int, unsigned int, unsigned int>())
            .def("IsValid", &sf::VideoMode::IsValid),

        luabind::class_<sf::RenderTarget>("RenderTarget")
            .def("Clear", &sf::RenderTarget::Clear)
            .def("Draw", &sf::RenderTarget::Draw)
            .def("GetHeight", &sf::RenderTarget::GetHeight)
            .def("SetView", &sf::RenderTarget::SetView)
            .def("GetView", &sf::RenderTarget::GetView)
            .def("GetDefaultView", &sf::RenderTarget::GetDefaultView)
            .def("PreserveOpenGLStates", &sf::RenderTarget::PreserveOpenGLStates),

        luabind::class_<sf::RenderWindow, luabind::bases<sf::Window, sf::RenderTarget> >("RenderWindow")
            .def(luabind::constructor<>())
            .def(luabind::constructor<sf::VideoMode, const std::string&>())
            .def(luabind::constructor<sf::VideoMode, const std::string&, unsigned long>())
            .def(luabind::constructor<sf::VideoMode, const std::string&, unsigned long, const sf::WindowSettings&>())
            .def("Capture", &sf::RenderWindow::Capture)
            .def("ConvertCoords", &sf::RenderWindow::ConvertCoords)
    ];
}

} //namespace jar

