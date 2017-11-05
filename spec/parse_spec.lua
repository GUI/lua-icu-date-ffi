describe("parse", function()
  local icu_date = require "icu-date"
  local date

  before_each(function()
    date = icu_date.new()
  end)

  it("parses iso8601 date and time", function()
    local format = icu_date.formats.iso8601()
    date:parse(format, "2016-10-12T19:32:07.123Z")
    assert.equal("2016-10-12T19:32:07.123Z", date:format(format))
    assert.equal(1476300727123, date:get_millis())
  end)

  it("parses iso8601 date", function()
    local format = icu_date.formats.pattern("YYYY-MM-dd")
    date:parse(format, "2016-10-12")
    assert.equal("2016-10-12", date:format(format))
    assert.equal(1476230400000, date:get_millis())
  end)

  it("parses time zone aware", function()
    local date = icu_date.new({ zone_id = "America/Denver" })
    local format = icu_date.formats.pattern("YYYY-MM-dd'T'HH")
    date:parse(format, "2016-10-12T19")
    assert.equal("2016-10-12T19", date:format(format))
    assert.equal(1476320400000, date:get_millis())
  end)

  it("defaults to clearing date", function()
    date:set_millis(1507836727123)
    assert.equal("2017-10-12T19:32:07.123Z", date:format(icu_date.formats.iso8601()))

    local format = icu_date.formats.pattern("YYYY-MM-dd")
    date:parse(format, "2016-09-18")
    assert.equal("2016-09-18T00:00:00.000Z", date:format(icu_date.formats.iso8601()))
  end)

  it("can disable clearing date", function()
    date:set_millis(1507836727123)
    assert.equal("2017-10-12T19:32:07.123Z", date:format(icu_date.formats.iso8601()))

    local format = icu_date.formats.pattern("YYYY-MM-dd")
    date:parse(format, "2016-09-18", { clear = false })
    assert.equal("2016-09-18T19:32:07.123Z", date:format(icu_date.formats.iso8601()))
  end)
end)
