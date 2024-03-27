defmodule BexioApiClient.Accounting.CurrencyTest do
  use ExUnit.Case, async: true

  doctest BexioApiClient.Accounting.Currency

  alias BexioApiClient.Accounting.Currency

  describe "should handle nil number" do
    test "and return nil" do
      assert Currency.round(nil, chf(0.01)) == nil
    end
  end

  describe "should handle float numbers" do
    test "should round a number to 0.01" do
      assert Currency.round(13.441, chf(0.01)) == 13.44
      assert Currency.round(13.449, chf(0.01)) == 13.45
    end

    test "should round a number to 0.05" do
      assert Currency.round(13.421, chf(0.05)) == 13.40
      assert Currency.round(13.443, chf(0.05)) == 13.45
    end

    test "should round a number to 0.1" do
      assert Currency.round(13.441, chf(0.1)) == 13.4
      assert Currency.round(13.459, chf(0.1)) == 13.5
    end

    test "should round a number to 1" do
      assert Currency.round(13.441, chf(1.0)) == 13.0
      assert Currency.round(13.559, chf(1.0)) == 14.0
    end
  end

  describe "should handle decimal numbers" do
    test "should round a number to 0.01" do
      assert Decimal.equal?(
               Currency.round(Decimal.new("13.441"), chf(0.01)),
               Decimal.from_float(13.44)
             )

      assert Decimal.equal?(
               Currency.round(Decimal.new("13.449"), chf(0.01)),
               Decimal.from_float(13.45)
             )
    end

    test "should round a number to 0.05" do
      assert Decimal.equal?(
               Currency.round(Decimal.new("13.421"), chf(0.05)),
               Decimal.from_float(13.40)
             )

      assert Decimal.equal?(
               Currency.round(Decimal.new("13.443"), chf(0.05)),
               Decimal.from_float(13.45)
             )
    end

    test "should round a number to 0.1" do
      assert Decimal.equal?(
               Currency.round(Decimal.new("13.441"), chf(0.1)),
               Decimal.from_float(13.4)
             )

      assert Decimal.equal?(
               Currency.round(Decimal.new("13.459"), chf(0.1)),
               Decimal.from_float(13.5)
             )
    end

    test "should round a number to 1" do
      assert Decimal.equal?(
               Currency.round(Decimal.new("13.441"), chf(1.0)),
               Decimal.from_float(13.0)
             )

      assert Decimal.equal?(
               Currency.round(Decimal.new("13.559"), chf(1.0)),
               Decimal.from_float(14.0)
             )
    end
  end

  defp chf(round_factor), do: %Currency{id: 1, name: "CHF", round_factor: round_factor}
end
