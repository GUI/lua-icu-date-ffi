describe("set_millis", function()
  local icu_date = require "icu-date"
  local attributes = icu_date.attributes
  local date = icu_date.new()
  local format = date:pattern_format("YYYY-MM-dd'T'HH:mm:ss.SSSZZZZZ")

  before_each(function()
    date = icu_date.new()
    date:set_millis(1507836727123)
    assert.equal("2017-10-12T19:32:07.123Z", date:format(format))
  end)

  it("sets milliseconds", function()
    assert.equal(1507836727123, date:get_millis())
    date:set_millis(1000)
    assert.equal(1000, date:get_millis())
    assert.equal("1970-01-01T00:00:01.000Z", date:format(format))
  end)
end)
