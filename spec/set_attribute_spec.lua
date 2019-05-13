describe("set_attribute", function()
  local icu_date = require "icu-date-ffi"
  local attributes = icu_date.attributes
  local date = icu_date.new()
  local format = icu_date.formats.iso8601()

  before_each(function()
    date = icu_date.new()
    date:set_millis(1507836727123)
    assert.equal("2017-10-12T19:32:07.123Z", date:format(format))
  end)

  it("sets lenient", function()
    assert.equal(1, date:get_attribute(attributes.LENIENT))
    date:set_attribute(attributes.LENIENT, 0)
    assert.equal(0, date:get_attribute(attributes.LENIENT))
    assert.equal("2017-10-12T19:32:07.123Z", date:format(format))
  end)

  it("sets first day of week", function()
    assert.equal(1, date:get_attribute(attributes.FIRST_DAY_OF_WEEK))
    date:set_attribute(attributes.FIRST_DAY_OF_WEEK, 2)
    assert.equal(2, date:get_attribute(attributes.FIRST_DAY_OF_WEEK))
    assert.equal("2017-10-12T19:32:07.123Z", date:format(format))
  end)

  it("sets minimal days in first week", function()
    assert.equal(1, date:get_attribute(attributes.MINIMAL_DAYS_IN_FIRST_WEEK))
    date:set_attribute(attributes.MINIMAL_DAYS_IN_FIRST_WEEK, 2)
    assert.equal(2, date:get_attribute(attributes.MINIMAL_DAYS_IN_FIRST_WEEK))
    assert.equal("2017-10-12T19:32:07.123Z", date:format(format))
  end)

  it("sets repeated wall time", function()
    assert.equal(0, date:get_attribute(attributes.REPEATED_WALL_TIME))
    date:set_attribute(attributes.REPEATED_WALL_TIME, 1)
    assert.equal(1, date:get_attribute(attributes.REPEATED_WALL_TIME))
    assert.equal("2017-10-12T19:32:07.123Z", date:format(format))
  end)

  it("sets skipped wall time", function()
    assert.equal(0, date:get_attribute(attributes.SKIPPED_WALL_TIME))
    date:set_attribute(attributes.SKIPPED_WALL_TIME, 2)
    assert.equal(2, date:get_attribute(attributes.SKIPPED_WALL_TIME))
    assert.equal("2017-10-12T19:32:07.123Z", date:format(format))
  end)
end)
