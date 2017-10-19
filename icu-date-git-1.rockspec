package = "icu-date"
version = "git-1"
source = {
  url = "git://github.com/GUI/lua-icu-date.git",
}
description = {
  summary = "",
  detailed = "",
  homepage = "https://github.com/GUI/lua-icu-date",
  license = "MIT",
}
external_dependencies = {
  ICU = {
    library = "icui18n",
  },
}
build = {
  type = "builtin",
  modules = {
    ["icu-date"] = "lib/icu-date.lua",
    ["icu-date.detect_icu_version_suffix"] = "lib/icu-date/detect_icu_version_suffix.lua",
    ["icu-date.ffi_cdef"] = "lib/icu-date/ffi_cdef.lua",
  },
}
