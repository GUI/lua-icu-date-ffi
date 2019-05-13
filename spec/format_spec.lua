describe("format", function()
  local icu_date = require "icu-date-ffi"
  local date = icu_date.new()

  before_each(function()
    date:set_millis(1507836727123)
  end)

  it("formats iso8601", function()
    local format = icu_date.formats.iso8601()
    assert.equal("2017-10-12T19:32:07.123Z", date:format(format))
  end)

  it("custom pattern format", function()
    local format = icu_date.formats.pattern("yyyy-MM-dd")
    assert.equal("2017-10-12", date:format(format))
  end)
end)
