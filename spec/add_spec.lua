describe("add", function()
  local icu_date = require "icu-date"
  local fields = icu_date.fields
  local date = icu_date.new()
  local format = icu_date.pattern_format("YYYY-MM-dd'T'HH:mm:ss.SSSZZZZZ")

  before_each(function()
    date:set_millis(1507836727123)
    assert.equal("2017-10-12T19:32:07.123Z", date:format(format))
  end)

  it("adds different fields", function()
    date:add(fields.YEAR, 1)
    assert.equal("2018-10-12T19:32:07.123Z", date:format(format))

    date:add(fields.MONTH, 1)
    assert.equal("2018-11-12T19:32:07.123Z", date:format(format))
  end)

  it("subtracts negative values", function()
    date:add(fields.YEAR, -1)
    assert.equal("2016-10-12T19:32:07.123Z", date:format(format))

    date:add(fields.MONTH, -1)
    assert.equal("2016-09-12T19:32:07.123Z", date:format(format))
  end)

  it("wraps values", function()
    date:add(fields.MONTH, 3)
    assert.equal("2018-01-12T19:32:07.123Z", date:format(format))
  end)
end)
