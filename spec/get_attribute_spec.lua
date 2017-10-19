describe("get_attribute", function()
  local icu_date = require "icu-date"
  local attributes = icu_date.attributes
  local date = icu_date.new()
  local format = icu_date.pattern_format("YYYY-MM-dd'T'HH:mm:ss.SSSZZZZZ")

  before_each(function()
    date = icu_date.new()
    date:set_millis(1507836727123)
    assert.equal("2017-10-12T19:32:07.123Z", date:format(format))
  end)

  it("gets lenient", function()
    assert.equal(1, date:get_attribute(attributes.LENIENT))
  end)

  it("gets first day of week", function()
    assert.equal(1, date:get_attribute(attributes.FIRST_DAY_OF_WEEK))
  end)

  it("gets minimal days in first week", function()
    assert.equal(1, date:get_attribute(attributes.MINIMAL_DAYS_IN_FIRST_WEEK))
  end)

  it("gets repeated wall time", function()
    assert.equal(0, date:get_attribute(attributes.REPEATED_WALL_TIME))
  end)

  it("gets skipped wall time", function()
    assert.equal(0, date:get_attribute(attributes.SKIPPED_WALL_TIME))
  end)
end)
