#ifndef JAR_LUA_H
#define JAR_LUA_H

#include <string>

//forward declarations
struct lua_State;

namespace jar
{

/** \brief Wrapper class for commonly used Lua functions **/
class Lua
{
    public:
        Lua();
        /** \brief Destructor. Starts deinitialization, if necessary. **/
        virtual ~Lua();

        /** \brief returns the lua_State so you can do specific stuff.
            \note In Debug mode asserts that initialization has been done.
        **/
        lua_State* GetState() const
        {
#ifdef _DEBUG
            assert(mState);
#endif
            return mState;
        }

        /** \brief Returns the last error. **/
        const std::string& GetLastError() const {return mLastError;}

        /** \brief Initializes Lua and luabind
            \note Only initializes luabind if this is the first Lua thread. **/
        const bool Init();

        /** \brief Opens all the default Lua libraries. **/
        const bool OpenLibaries();

        /** \brief Opens the basic library. **/
        const bool OpenBaseLibrary();

        /** \brief Opens the package library. **/
        const bool OpenPackageLibrary();

        /** \brief Opens the string library. **/
        const bool OpenStringLibrary();

        /** \brief Opens the table library. **/
        const bool OpenTableLibrary();

        /** \brief Opens the math library. **/
        const bool OpenMathLibrary();

        /** \brief Opens the I/O library. **/
        const bool OpenIOLibrary();

        /** \brief Opens the Operating System library. **/
        const bool OpenOSLibrary();

        /** \brief Opens the debug library. **/
        const bool OpenDebugLibrary();

        /** \brief Deinitializes Lua.
            \note Automatically done in destructor, if necessary. **/
        void Deinit();

        /** \brief Executes a given string
            \param str the string
            \param chunkname what name to give this string (i.e. chunk), e.g. used in tracebacks. (note: @ at the beginning indicates a filename) **/
        const bool ExecuteString(const std::string& str, const std::string& chunkname);

        /** \brief Executes a given file
            \param filename name of the file to execute **/
        const bool ExecuteFile(const std::string& filename);

        /** \brief Whether this is the main Lua thread.

            Only the main Lua thread may use luabind. So you might want to check this before doing luabind stuff. **/
        const bool IsMainThread() {return mIsMainThread; }

    private:
        /** \brief The Lua State. Access via GetState(), if necessary. **/
        lua_State* mState;
        /** \brief The last error encountered. Acces via GetLastError().**/
        std::string mLastError;
        /** \brief Whether this is the main Lua thread. Only the main thread may use luabind. **/
        bool mIsMainThread;
};

} // namespace jar

#endif // JAR_LUA_H
