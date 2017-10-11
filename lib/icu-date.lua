local ffi = require("ffi")

-- libicu appends its function names with a version suffix in some
-- environments. Try to detect it.
--
-- This solution isn't particularly ideal, but we basically check for various
-- different method names on load to try and detect what version the method
-- names are using.
--
-- See https://github.com/fantasticfears/ffi-icu/blob/v0.1.10/lib/ffi-icu/lib.rb#L84
local function detect_icu_version_suffix()
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

local icu_version_suffix = detect_icu_version_suffix()

ffi.cdef([[
void* malloc(size_t size);
void free(void* ptr);

typedef uint16_t UChar;
typedef void* UCalendar;
typedef double UDate;
typedef void* UDateFormat;
typedef enum UErrorCode {
  U_USING_FALLBACK_WARNING = -128,
  U_ERROR_WARNING_START = -128,
  U_USING_DEFAULT_WARNING = -127,
  U_SAFECLONE_ALLOCATED_WARNING = -126,
  U_STATE_OLD_WARNING = -125,
  U_STRING_NOT_TERMINATED_WARNING = -124,
  U_SORT_KEY_TOO_SHORT_WARNING = -123,
  U_AMBIGUOUS_ALIAS_WARNING = -122,
  U_DIFFERENT_UCA_VERSION = -121,
  U_PLUGIN_CHANGED_LEVEL_WARNING = -120,
  U_ERROR_WARNING_LIMIT,
  U_ZERO_ERROR =  0,
  U_ILLEGAL_ARGUMENT_ERROR =  1,
  U_MISSING_RESOURCE_ERROR =  2,
  U_INVALID_FORMAT_ERROR =  3,
  U_FILE_ACCESS_ERROR =  4,
  U_INTERNAL_PROGRAM_ERROR =  5,
  U_MESSAGE_PARSE_ERROR =  6,
  U_MEMORY_ALLOCATION_ERROR =  7,
  U_INDEX_OUTOFBOUNDS_ERROR =  8,
  U_PARSE_ERROR =  9,
  U_INVALID_CHAR_FOUND = 10,
  U_TRUNCATED_CHAR_FOUND = 11,
  U_ILLEGAL_CHAR_FOUND = 12,
  U_INVALID_TABLE_FORMAT = 13,
  U_INVALID_TABLE_FILE = 14,
  U_BUFFER_OVERFLOW_ERROR = 15,
  U_UNSUPPORTED_ERROR = 16,
  U_RESOURCE_TYPE_MISMATCH = 17,
  U_ILLEGAL_ESCAPE_SEQUENCE = 18,
  U_UNSUPPORTED_ESCAPE_SEQUENCE = 19,
  U_NO_SPACE_AVAILABLE = 20,
  U_CE_NOT_FOUND_ERROR = 21,
  U_PRIMARY_TOO_LONG_ERROR = 22,
  U_STATE_TOO_OLD_ERROR = 23,
  U_TOO_MANY_ALIASES_ERROR = 24,
  U_ENUM_OUT_OF_SYNC_ERROR = 25,
  U_INVARIANT_CONVERSION_ERROR = 26,
  U_INVALID_STATE_ERROR = 27,
  U_COLLATOR_VERSION_MISMATCH = 28,
  U_USELESS_COLLATOR_ERROR = 29,
  U_NO_WRITE_PERMISSION = 30,
  U_STANDARD_ERROR_LIMIT,
  U_BAD_VARIABLE_DEFINITION=0x10000,
  U_PARSE_ERROR_START = 0x10000,
  U_MALFORMED_RULE,
  U_MALFORMED_SET,
  U_MALFORMED_SYMBOL_REFERENCE,
  U_MALFORMED_UNICODE_ESCAPE,
  U_MALFORMED_VARIABLE_DEFINITION,
  U_MALFORMED_VARIABLE_REFERENCE,
  U_MISMATCHED_SEGMENT_DELIMITERS,
  U_MISPLACED_ANCHOR_START,
  U_MISPLACED_CURSOR_OFFSET,
  U_MISPLACED_QUANTIFIER,
  U_MISSING_OPERATOR,
  U_MISSING_SEGMENT_CLOSE,
  U_MULTIPLE_ANTE_CONTEXTS,
  U_MULTIPLE_CURSORS,
  U_MULTIPLE_POST_CONTEXTS,
  U_TRAILING_BACKSLASH,
  U_UNDEFINED_SEGMENT_REFERENCE,
  U_UNDEFINED_VARIABLE,
  U_UNQUOTED_SPECIAL,
  U_UNTERMINATED_QUOTE,
  U_RULE_MASK_ERROR,
  U_MISPLACED_COMPOUND_FILTER,
  U_MULTIPLE_COMPOUND_FILTERS,
  U_INVALID_RBT_SYNTAX,
  U_INVALID_PROPERTY_PATTERN,
  U_MALFORMED_PRAGMA,
  U_UNCLOSED_SEGMENT,
  U_ILLEGAL_CHAR_IN_SEGMENT,
  U_VARIABLE_RANGE_EXHAUSTED,
  U_VARIABLE_RANGE_OVERLAP,
  U_ILLEGAL_CHARACTER,
  U_INTERNAL_TRANSLITERATOR_ERROR,
  U_INVALID_ID,
  U_INVALID_FUNCTION,
  U_PARSE_ERROR_LIMIT,
  U_UNEXPECTED_TOKEN=0x10100,
  U_FMT_PARSE_ERROR_START=0x10100,
  U_MULTIPLE_DECIMAL_SEPARATORS,
  U_MULTIPLE_DECIMAL_SEPERATORS = U_MULTIPLE_DECIMAL_SEPARATORS,
  U_MULTIPLE_EXPONENTIAL_SYMBOLS,
  U_MALFORMED_EXPONENTIAL_PATTERN,
  U_MULTIPLE_PERCENT_SYMBOLS,
  U_MULTIPLE_PERMILL_SYMBOLS,
  U_MULTIPLE_PAD_SPECIFIERS,
  U_PATTERN_SYNTAX_ERROR,
  U_ILLEGAL_PAD_POSITION,
  U_UNMATCHED_BRACES,
  U_UNSUPPORTED_PROPERTY,
  U_UNSUPPORTED_ATTRIBUTE,
  U_ARGUMENT_TYPE_MISMATCH,
  U_DUPLICATE_KEYWORD,
  U_UNDEFINED_KEYWORD,
  U_DEFAULT_KEYWORD_MISSING,
  U_DECIMAL_NUMBER_SYNTAX_ERROR,
  U_FORMAT_INEXACT_ERROR,
  U_FMT_PARSE_ERROR_LIMIT,
  U_BRK_INTERNAL_ERROR=0x10200,
  U_BRK_ERROR_START=0x10200,
  U_BRK_HEX_DIGITS_EXPECTED,
  U_BRK_SEMICOLON_EXPECTED,
  U_BRK_RULE_SYNTAX,
  U_BRK_UNCLOSED_SET,
  U_BRK_ASSIGN_ERROR,
  U_BRK_VARIABLE_REDFINITION,
  U_BRK_MISMATCHED_PAREN,
  U_BRK_NEW_LINE_IN_QUOTED_STRING,
  U_BRK_UNDEFINED_VARIABLE,
  U_BRK_INIT_ERROR,
  U_BRK_RULE_EMPTY_SET,
  U_BRK_UNRECOGNIZED_OPTION,
  U_BRK_MALFORMED_RULE_TAG,
  U_BRK_ERROR_LIMIT,
  U_REGEX_INTERNAL_ERROR=0x10300,
  U_REGEX_ERROR_START=0x10300,
  U_REGEX_RULE_SYNTAX,
  U_REGEX_INVALID_STATE,
  U_REGEX_BAD_ESCAPE_SEQUENCE,
  U_REGEX_PROPERTY_SYNTAX,
  U_REGEX_UNIMPLEMENTED,
  U_REGEX_MISMATCHED_PAREN,
  U_REGEX_NUMBER_TOO_BIG,
  U_REGEX_BAD_INTERVAL,
  U_REGEX_MAX_LT_MIN,
  U_REGEX_INVALID_BACK_REF,
  U_REGEX_INVALID_FLAG,
  U_REGEX_LOOK_BEHIND_LIMIT,
  U_REGEX_SET_CONTAINS_STRING,
  U_REGEX_OCTAL_TOO_BIG,
  U_REGEX_MISSING_CLOSE_BRACKET=U_REGEX_SET_CONTAINS_STRING+2,
  U_REGEX_INVALID_RANGE,
  U_REGEX_STACK_OVERFLOW,
  U_REGEX_TIME_OUT,
  U_REGEX_STOPPED_BY_CALLER,
  U_REGEX_PATTERN_TOO_BIG,
  U_REGEX_INVALID_CAPTURE_GROUP_NAME,
  U_REGEX_ERROR_LIMIT=U_REGEX_STOPPED_BY_CALLER+3,
  U_IDNA_PROHIBITED_ERROR=0x10400,
  U_IDNA_ERROR_START=0x10400,
  U_IDNA_UNASSIGNED_ERROR,
  U_IDNA_CHECK_BIDI_ERROR,
  U_IDNA_STD3_ASCII_RULES_ERROR,
  U_IDNA_ACE_PREFIX_ERROR,
  U_IDNA_VERIFICATION_ERROR,
  U_IDNA_LABEL_TOO_LONG_ERROR,
  U_IDNA_ZERO_LENGTH_LABEL_ERROR,
  U_IDNA_DOMAIN_NAME_TOO_LONG_ERROR,
  U_IDNA_ERROR_LIMIT,
  U_STRINGPREP_PROHIBITED_ERROR = U_IDNA_PROHIBITED_ERROR,
  U_STRINGPREP_UNASSIGNED_ERROR = U_IDNA_UNASSIGNED_ERROR,
  U_STRINGPREP_CHECK_BIDI_ERROR = U_IDNA_CHECK_BIDI_ERROR,
  U_PLUGIN_ERROR_START=0x10500,
  U_PLUGIN_TOO_HIGH=0x10500,
  U_PLUGIN_DIDNT_SET_LEVEL,
  U_PLUGIN_ERROR_LIMIT,
  U_ERROR_LIMIT=U_PLUGIN_ERROR_LIMIT
} UErrorCode;
typedef enum UDateFormatStyle {
  UDAT_FULL,
  UDAT_LONG,
  UDAT_MEDIUM,
  UDAT_SHORT,
  UDAT_DEFAULT = UDAT_MEDIUM,
  UDAT_RELATIVE = (1 << 7),
  UDAT_FULL_RELATIVE = UDAT_FULL | UDAT_RELATIVE,
  UDAT_LONG_RELATIVE = UDAT_LONG | UDAT_RELATIVE,
  UDAT_MEDIUM_RELATIVE = UDAT_MEDIUM | UDAT_RELATIVE,
  UDAT_SHORT_RELATIVE = UDAT_SHORT | UDAT_RELATIVE,
  UDAT_NONE = -1,
  UDAT_PATTERN = -2,
} UDateFormatStyle;
typedef enum UCalendarType {
  UCAL_TRADITIONAL,
  UCAL_DEFAULT = UCAL_TRADITIONAL,
  UCAL_GREGORIAN
} UCalendarType;
typedef struct UFieldPosition {
  int32_t field;
  int32_t beginIndex;
  int32_t endIndex;
} UFieldPosition;
typedef enum UCalendarDateFields {
  UCAL_ERA,
  UCAL_YEAR,
  UCAL_MONTH,
  UCAL_WEEK_OF_YEAR,
  UCAL_WEEK_OF_MONTH,
  UCAL_DATE,
  UCAL_DAY_OF_YEAR,
  UCAL_DAY_OF_WEEK,
  UCAL_DAY_OF_WEEK_IN_MONTH,
  UCAL_AM_PM,
  UCAL_HOUR,
  UCAL_HOUR_OF_DAY,
  UCAL_MINUTE,
  UCAL_SECOND,
  UCAL_MILLISECOND,
  UCAL_ZONE_OFFSET,
  UCAL_DST_OFFSET,
  UCAL_YEAR_WOY,
  UCAL_DOW_LOCAL,
  UCAL_EXTENDED_YEAR,
  UCAL_JULIAN_DAY,
  UCAL_MILLISECONDS_IN_DAY,
  UCAL_IS_LEAP_MONTH,
  UCAL_FIELD_COUNT,
  UCAL_DAY_OF_MONTH=UCAL_DATE
} UCalendarDateFields;
typedef enum UCalendarAttribute {
  UCAL_LENIENT,
  UCAL_FIRST_DAY_OF_WEEK,
  UCAL_MINIMAL_DAYS_IN_FIRST_WEEK,
  UCAL_REPEATED_WALL_TIME,
  UCAL_SKIPPED_WALL_TIME
} UCalendarAttribute;

int32_t u_strlen]] .. icu_version_suffix .. [[(const UChar* s);
UChar* u_uastrcpy]] .. icu_version_suffix .. [[(UChar* dst, const char* src);
char* u_austrcpy]] .. icu_version_suffix .. [[(char* dst, const UChar* src);

const char* u_errorName]] .. icu_version_suffix .. [[(UErrorCode code);

UDateFormat* udat_open]] .. icu_version_suffix .. [[(UDateFormatStyle timeStyle, UDateFormatStyle dateStyle, const char* locale, const UChar* tzID, int32_t tzIDLength, const UChar* pattern, int32_t patternLength, UErrorCode* status);
void udat_close]] .. icu_version_suffix .. [[(UDateFormat* format);
void udat_parseCalendar]] .. icu_version_suffix .. [[(const UDateFormat* format, UCalendar* calendar, const UChar* text, int32_t textLength, int32_t* parsePos, UErrorCode* status);
int32_t udat_formatCalendar]] .. icu_version_suffix .. [[(const UDateFormat* format, UCalendar* calendar, UChar* result, int32_t capacity, UFieldPosition* position, UErrorCode* status);

UCalendar* ucal_open]] .. icu_version_suffix .. [[(const UChar* zoneID, int32_t len, const char* locale, UCalendarType type, UErrorCode* status);
void ucal_close]] .. icu_version_suffix .. [[(UCalendar* cal);
int32_t ucal_get]] .. icu_version_suffix .. [[(const UCalendar* cal, UCalendarDateFields field, UErrorCode* status);
void ucal_set]] .. icu_version_suffix .. [[(UCalendar* cal, UCalendarDateFields field, int32_t value);
void ucal_add]] .. icu_version_suffix .. [[(UCalendar* cal, UCalendarDateFields field, int32_t amount, UErrorCode* status);
UDate ucal_getMillis]] .. icu_version_suffix .. [[(const UCalendar* cal, UErrorCode* status);
void ucal_setMillis]] .. icu_version_suffix .. [[(UCalendar* cal, UDate dateTime, UErrorCode* status);
int32_t ucal_getAttribute]] .. icu_version_suffix .. [[(const UCalendar* cal, UCalendarAttribute attr) ;
void ucal_setAttribute]] .. icu_version_suffix .. [[(UCalendar* cal, UCalendarAttribute attr, int32_t newValue);
]])

local icu = ffi.load("icui18n")

local uerrorcode_type = ffi.typeof("UErrorCode[1]")
local uchar_size = ffi.sizeof("UChar")
local char_size = ffi.sizeof("char")

local _M = {}
_M.__index = _M

local function call_fn(name, ...)
  return icu[name .. icu_version_suffix](...)
end

local function call_fn_status(name, ...)
  local length = select("#", ...)
  local status_ptr = select(length, ...)
  status_ptr[0] = icu.U_ZERO_ERROR

  local result = call_fn(name, ...)
  return tonumber(status_ptr[0]), result
end

local function check_status(status, result)
  if status == icu.U_ZERO_ERROR then
    return result
  else
    local error_name = ffi.string(call_fn("u_errorName", status))
    if status >= icu.U_ERROR_WARNING_START and status < icu.U_ERROR_WARNING_LIMIT then
      -- print("WARNING: " .. error_name)
      return result
    else
      error("Invalid status: " .. error_name .. ": " .. result)
    end
  end
end

local function call_fn_check_status(name, ...)
  local status, result = call_fn_status(name, ...)
  return check_status(status, result)
end

function _M:get(field)
  assert(field)
  return call_fn_check_status("ucal_get", self.cal, field, self.status_ptr)
end

function _M:set(field, value)
  assert(field)
  return call_fn("ucal_set", self.cal, field, value)
end

function _M:add(field, amount)
  assert(field)
  return call_fn_check_status("ucal_add", self.cal, field, amount, self.status_ptr)
end

function _M:get_millis()
  return call_fn_check_status("ucal_getMillis", self.cal, self.status_ptr)
end

function _M:set_millis(value)
  call_fn_check_status("ucal_setMillis", self.cal, value, self.status_ptr)
end

function _M:get_attribute(attribute)
  assert(attribute)
  return call_fn("ucal_getAttribute", self.cal, attribute)
end

function _M:set_attribute(attribute, value)
  assert(attribute)
  return call_fn("ucal_setAttribute", self.cal, attribute, value)
end

local function string_to_uchar(str)
  local length = string.len(str) + 1
  local size = length * uchar_size
  local uchar = ffi.gc(ffi.C.malloc(size), ffi.C.free)
  call_fn("u_uastrcpy", uchar, str)
  return uchar
end

local function uchar_to_string(uchar)
  local length = call_fn("u_strlen", uchar) + 1
  local size = length * char_size
  local str = ffi.gc(ffi.C.malloc(size), ffi.C.free)
  call_fn("u_austrcpy", str, uchar)
  return ffi.string(str)
end

local function close_date_format(format)
  call_fn("udat_close", format)
end

function _M:pattern_format(pattern)
  local pattern_uchar = string_to_uchar(pattern)
  local format = call_fn_check_status("udat_open", icu.UDAT_PATTERN, icu.UDAT_PATTERN, "en_US", nil, 0, pattern_uchar, -1, self.status_ptr)
  ffi.gc(format, close_date_format)

  return format
end

function _M:format(pattern)
  local format = pattern
  local result_length = 64
  local result = ffi.gc(ffi.C.malloc(result_length * uchar_size), ffi.C.free)

  local status, needed_length = call_fn_status("udat_formatCalendar", format, self.cal, result, result_length, nil, self.status_ptr)
  if status == icu.U_BUFFER_OVERFLOW_ERROR then
    result_length = needed_length + 1
    result = ffi.gc(ffi.C.malloc(result_length * uchar_size), ffi.C.free)
    call_fn_check_status("udat_formatCalendar", format, self.cal, result, result_length, nil, self.status_ptr)
  else
    check_status(status)
  end

  return uchar_to_string(result)
end

function _M:_parse(pattern, text)
  local format = pattern_format(self, pattern)
  local text_uchar = string_to_uchar(text)
  local position_ptr = ffi.new("int32_t[1]")
  call_fn_check_status("udat_parseCalendar", format, self.cal, text_uchar, -1, position_ptr, self.status_ptr)
end

local function close_cal(cal)
  call_fn("ucal_close", cal)
end

function _M.new(options)
  local zone_id
  local locale
  local calendar_type
  if options then
    zone_id = options["zone_id"]
    locale = options["locale"]
    calendar_type = options["calendar_type"]
  end

  if not locale then
    locale = "en_US"
  end

  if not calendar_type then
    calendar_type = icu.UCAL_GREGORIAN
  end

  local zone_id = string_to_uchar("America/Denver")
  -- local zone_id = string_to_uchar("UTC")

  local status_ptr = ffi.new(uerrorcode_type)
  local cal = call_fn_check_status("ucal_open", zone_id, -1, locale, calendar_type, status_ptr)
  ffi.gc(cal, close_cal)

  local self = {
    cal = cal,
    status_ptr = status_ptr,
  }

  return setmetatable(self, _M)
end

_M._icu = icu

_M.fields = {
  ERA = icu.UCAL_ERA,
  YEAR = icu.UCAL_YEAR,
  MONTH = icu.UCAL_MONTH,
  WEEK_OF_YEAR = icu.UCAL_WEEK_OF_YEAR,
  WEEK_OF_MONTH = icu.UCAL_WEEK_OF_MONTH,
  DATE = icu.UCAL_DATE,
  DAY_OF_YEAR = icu.UCAL_DAY_OF_YEAR,
  DAY_OF_WEEK = icu.UCAL_DAY_OF_WEEK,
  DAY_OF_WEEK_IN_MONTH = icu.UCAL_DAY_OF_WEEK_IN_MONTH,
  AM_PM = icu.UCAL_AM_PM,
  HOUR = icu.UCAL_HOUR,
  HOUR_OF_DAY = icu.UCAL_HOUR_OF_DAY,
  MINUTE = icu.UCAL_MINUTE,
  SECOND = icu.UCAL_SECOND,
  MILLISECOND = icu.UCAL_MILLISECOND,
  ZONE_OFFSET = icu.UCAL_ZONE_OFFSET,
  DST_OFFSET = icu.UCAL_DST_OFFSET,
  YEAR_WOY = icu.UCAL_YEAR_WOY,
  DOW_LOCAL = icu.UCAL_DOW_LOCAL,
  EXTENDED_YEAR = icu.UCAL_EXTENDED_YEAR,
  JULIAN_DAY = icu.UCAL_JULIAN_DAY,
  MILLISECONDS_IN_DAY = icu.UCAL_MILLISECONDS_IN_DAY,
  IS_LEAP_MONTH = icu.UCAL_IS_LEAP_MONTH,
  DAY_OF_MONTH = icu.UCAL_DAY_OF_MONTH,
}

_M.attributes = {
  LENIENT = icu.UCAL_LENIENT,
  FIRST_DAY_OF_WEEK = icu.UCAL_FIRST_DAY_OF_WEEK,
  MINIMAL_DAYS_IN_FIRST_WEEK = icu.UCAL_MINIMAL_DAYS_IN_FIRST_WEEK,
  REPEATED_WALL_TIME = icu.UCAL_REPEATED_WALL_TIME,
  SKIPPED_WALL_TIME = icu.UCAL_SKIPPED_WALL_TIME,
}

function _M.parse(format, text, options)
  local instance = _M.new(options)
  instance:_parse(format, text)
  return instance
end

return _M
