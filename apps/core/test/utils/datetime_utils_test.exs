defmodule Core.Utils.DateTimeUtilsTest do
  use Core.DataCase

  alias Campus.DateTimeUtils

  describe "testing datetime util methods" do
    test "return previous day of week when current day provided and current day is first day of week" do
      assert "sunday" == DateTimeUtils.week_previous_day("monday")
    end

    test "return previous day of week when current day provided and current day is not first day of week" do
      assert "thursday" == DateTimeUtils.week_previous_day("friday")
    end

    test "return next day of week when current day provided and current day is last day of week" do
      assert "monday" == DateTimeUtils.week_next_day("sunday")
    end

    test "return next day of week when current day provided and current day is not last day of week" do
      assert "thursday" == DateTimeUtils.week_next_day("wednesday")
    end

    test "returns `true` when the given string contains datetime" do
      assert true == DateTimeUtils.contains_date_and_time?("2023-01-01T01:01:01Z")
    end

    test "returns `fale` when the given string contains datetime" do
      assert false == DateTimeUtils.contains_date_and_time?("Wednesday")
    end
  end
end
