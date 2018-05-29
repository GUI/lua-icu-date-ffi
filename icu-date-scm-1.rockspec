package = "icu-date"
version = "scm-1"

source = {
    url = "git@github.com:tarantool/lua-icu-date.git",
    branch = 'master',
}

description = {
    summary = "LuaJIT FFI bindings to ICU date/time",
    detailed = [[
        Module provides a robust date and time library
      that correctly and efficiently handles
      complexities of dealing with dates and times:
        - date and time formatting
        - date and time parsing
        - date and time arithmetic (adding and subtracting)
        - time zones
        - daylight saving time
        - leap years
        - ISO 8601 formatting and parsing
    ]],
    homepage = "https://github.com/tarantool/lua-icu-date",
    license = "MIT",
}

dependencies = {
    'lua == 5.1',
}

build = {
    type = "builtin",
    modules = {
        ["icu-date"] = "icu-date.lua",
        ["utils.detect_icu_version_suffix"] = "utils/detect_icu_version_suffix.lua",
        ["utils.ffi_cdef"] = "utils/ffi_cdef.lua",
    },
}
