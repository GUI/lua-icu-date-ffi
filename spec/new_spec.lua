describe("new", function()
  local icu_date = require "icu-date"
  local format = icu_date.pattern_format("YYYY-MM-dd'T'HH:mm:ss.SSSZZZZZ")

  it("creates new instance", function()
    local date = icu_date.new()
    assert(date)
  end)

  it("accepts zone_id", function()
    local date = icu_date.new({ zone_id = "America/Denver" })
    date:set_millis(1507836727123)
    assert.equal("2017-10-12T13:32:07.123-06:00", date:format(format))
  end)
end)
