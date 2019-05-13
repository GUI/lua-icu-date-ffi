package = "icu-date-ffi"
version = "git-1"
source = {
  url = "git://github.com/GUI/lua-icu-date-ffi.git",
}
description = {
  summary = "",
  detailed = "",
  homepage = "https://github.com/GUI/lua-icu-date-ffi",
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
    ["icu-date-ffi"] = "lib/icu-date-ffi.lua",
    ["icu-date-ffi.detect_icu_version_suffix"] = "lib/icu-date-ffi/detect_icu_version_suffix.lua",
    ["icu-date-ffi.ffi_cdef"] = "lib/icu-date-ffi/ffi_cdef.lua",
  },
}
