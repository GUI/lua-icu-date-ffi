local ffi = require "ffi"

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

  -- Check each function name to see if it exists.
  local function check_suffix(suffix)
    assert(ffi.C["u_strlen" .. suffix])
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
