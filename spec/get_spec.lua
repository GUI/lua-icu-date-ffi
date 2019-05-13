describe("get", function()
  local icu_date = require "icu-date-ffi"
  local fields = icu_date.fields
  local date = icu_date.new()
  local format = date.formats.iso8601()

  before_each(function()
    date = icu_date.new()
    date:set_millis(1507836727123)
    assert.equal("2017-10-12T19:32:07.123Z", date:format(format))
  end)

  it("gets era", function()
    assert.equal(1, date:get(fields.ERA))
  end)

  it("gets year", function()
    assert.equal(2017, date:get(fields.YEAR))
  end)

  it("gets month", function()
    assert.equal(9, date:get(fields.MONTH))
  end)

  it("gets week of year", function()
    assert.equal(41, date:get(fields.WEEK_OF_YEAR))
  end)

  it("gets week of month", function()
    assert.equal(2, date:get(fields.WEEK_OF_MONTH))
  end)

  it("gets date", function()
    assert.equal(12, date:get(fields.DATE))
  end)

  it("gets day of year", function()
    assert.equal(285, date:get(fields.DAY_OF_YEAR))
  end)

  it("gets day of week", function()
    assert.equal(5, date:get(fields.DAY_OF_WEEK))
  end)

  it("gets day of week in month", function()
    assert.equal(2, date:get(fields.DAY_OF_WEEK_IN_MONTH))
  end)

  it("gets am/pm", function()
    assert.equal(1, date:get(fields.AM_PM))
  end)

  it("gets hour", function()
    assert.equal(7, date:get(fields.HOUR))
  end)

  it("gets hour of day", function()
    assert.equal(19, date:get(fields.HOUR_OF_DAY))
  end)

  it("gets minute", function()
    assert.equal(32, date:get(fields.MINUTE))
  end)

  it("gets second", function()
    assert.equal(7, date:get(fields.SECOND))
  end)

  it("gets millisecond", function()
    assert.equal(123, date:get(fields.MILLISECOND))
  end)

  it("gets zone offset", function()
    assert.equal(0, date:get(fields.ZONE_OFFSET))
  end)

  it("gets dst offset", function()
    assert.equal(0, date:get(fields.DST_OFFSET))
  end)

  it("gets year woy", function()
    assert.equal(2017, date:get(fields.YEAR_WOY))
  end)

  it("gets dow local", function()
    assert.equal(5, date:get(fields.DOW_LOCAL))
  end)

  it("gets extended year", function()
    assert.equal(2017, date:get(fields.EXTENDED_YEAR))
  end)

  it("gets julian day", function()
    assert.equal(2458039, date:get(fields.JULIAN_DAY))
  end)

  it("gets milliseconds in day", function()
    assert.equal(70327123, date:get(fields.MILLISECONDS_IN_DAY))
  end)

  it("gets is leap month", function()
    assert.equal(0, date:get(fields.IS_LEAP_MONTH))
  end)

  it("gets day of month", function()
    assert.equal(12, date:get(fields.DAY_OF_MONTH))
  end)
end)
