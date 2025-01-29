defmodule Core.Utils.FloatUtilsTest do
  use Core.DataCase

  alias Campus.FloatUtils

  @float 1.1e4
  describe "float_to_binary" do
    test "convert float to readable number" do
      assert FloatUtils.float_to_binary(@float) == "11000.0"
    end

    test "convert float to readable number with custom decimal points" do
      assert FloatUtils.float_to_binary(@float, 2) == "11000.00"
    end
  end
end
