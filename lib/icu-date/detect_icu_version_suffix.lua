local ffi = require "ffi"

if ffi.os == 'OSX' then
  ffi.cdef[[
    uint32_t _dyld_image_count();
    const char* _dyld_get_image_name(uint32_t image_index);
  ]]
elseif ffi.os == 'Linux' or ffi.os == 'BSD' then
  ffi.cdef[[
    struct dl_phdr_info {
      void*             dlpi_addr;  /* Base address of object */
      const char       *dlpi_name;  /* (Null-terminated) name of object */
    };
    typedef int (*enum_callback) (struct dl_phdr_info *info, size_t size, void *data);
    int dl_iterate_phdr(enum_callback callback, void *data);
  ]]
end



-- libicu appends its function names with a version suffix in some
-- environments. Try to detect it.
--
-- This solution isn't particularly ideal, but we basically check for various
-- different method names on load to try and detect what version the method
-- names are using.
--
-- See https://github.com/fantasticfears/ffi-icu/blob/v0.1.10/lib/ffi-icu/lib.rb#L84
return function()
  -- Allow environment variable override.
  local detected_suffix = os.getenv("ICU_VERSION_SUFFIX")
  if detected_suffix then
    return detected_suffix
  end

  if ffi.os == 'OSX' then
      for i = 0, ffi.C._dyld_image_count()-1 do
          local path = ffi.C._dyld_get_image_name(i)

          if path ~= nil then
              local _, _, prefix = ffi.string(path):find('^.*libicui18n%.(%d%d)%.dylib')
              if prefix ~= nil then
                  return '_'..prefix, ffi.string(path)
              end
          end
      end
  elseif ffi.os == 'Linux' or ffi.os == 'BSD' then
      local found, found_path
      local cb = ffi.cast('enum_callback', function(info, size, data)
                              if info ~= nil and info['dlpi_name'] ~= nil then
                                  local path = ffi.string(info['dlpi_name'])
                                  local _, _, prefix = path:find('^.*libicui18n%.so%.(%d%d)')
                                  if prefix ~= nil then
                                      found = '_'..prefix
                                      found_path = path
                                      return 1
                                  end
                              end
                              return 0
      end)
      local _ = ffi.C.dl_iterate_phdr(cb, nil)
      cb:free()

      if found ~= nil and found_path ~= nil then
          return found, found_path
      end
  end


  -- Some systems, like OS X don't have a suffix.
  local possible_suffixes = {""}

  -- Generate possible version suffixes for versions 30 - 99.
  --
  -- This obviously won't work forever, but hopefully there will be a better
  -- solution some day. For reference, CentOS 5, uses v3.6, and the current
  -- version as of 2017-10 is v59 (they got rid of the dots after v4.8).
  for i = 30, 99 do
    -- "u_strlen_44" style.
    table.insert(possible_suffixes, "_" .. i)

    -- "u_strlen_3_6" style.
    local str = tostring(i)
    table.insert(possible_suffixes, "_" .. string.sub(str, 1, 1) .. "_" .. string.sub(str, 2, 2))
  end

  -- Load the FFI library with a list of all the possible suffixed function
  -- names for the "u_strlen" function.
  local cdef = "typedef uint16_t UChar;"
  for _, suffix in ipairs(possible_suffixes) do
    cdef = cdef .. "\nint32_t u_strlen" .. suffix .. "(const UChar* s);"
  end
  ffi.cdef(cdef)
  local icu_version = ffi.load("icui18n")

  -- Check each function name to see if it exists.
  local function check_suffix(suffix)
    assert(icu_version["u_strlen" .. suffix])
  end
  for _, suffix in ipairs(possible_suffixes) do
    local exists = pcall(check_suffix, suffix)
    if exists then
      detected_suffix = suffix
      break
    end
  end

  -- Allow continuing without a known suffix, but it probably won't work.
  if not detected_suffix then
    print "WARNING: Could not determine ICU library suffix."
    detected_suffix = ""
  end

  return detected_suffix
end
