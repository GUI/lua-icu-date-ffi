describe("get_millis", function()
  local icu_date = require "icu-date"
  local attributes = icu_date.attributes
  local date = icu_date.new()
  local format = icu_date.formats.iso8601()

  before_each(function()
    date = icu_date.new()
    date:set_millis(1507836727123)
    assert.equal("2017-10-12T19:32:07.123Z", date:format(format))
  end)

  it("gets milliseconds", function()
    assert.equal(1507836727123, date:get_millis())
  end)
end)
