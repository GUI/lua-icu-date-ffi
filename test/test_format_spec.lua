#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("format")
test:plan(2)

local function date_test(test, func)
    test:plan(2)
    local fields = icu_date.fields
    local date = icu_date.new()
    local format = icu_date.formats.iso8601()

    date:set_millis(1507836727123)
    test:ok("2017-10-12T19:32:07.123Z" == date:format(format))

    test:test("", func, date, fields, format)
end

test:test("formats iso8601", date_test,
          function(test, date, fields, format)
              test:plan(1)
              local format = icu_date.formats.iso8601()
              test:ok("2017-10-12T19:32:07.123Z" == date:format(format))
end)

test:test("custom pattern format", date_test,
          function(test, date, fields, format)
              test:plan(1)
              local format = icu_date.formats.pattern("yyyy-MM-dd")
              test:ok("2017-10-12" == date:format(format))
end)


return test:check()
