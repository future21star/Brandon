require 'test_helper'

POSITIVE_DECIMAL_VALUES = [1.9, 1.54, 0.25, 3500.01, 10324, ".25"]
NEGATIVE_DECIMAL_VALUES = ["test", "1s", "0.ad2"]
POSITIVE_NUMERIC_VALUES= [1, -1, 10, 100, -100, "2"]
NEGATIVE_NUMERIC_VALUES = [0.1, ".2", "asda"]
PASSWORD = "password"

STRING_255 ="0"*255
STRING_256 = STRING_255 + "C"

class BaseModelTest < ActiveSupport::TestCase

  def new
    raise "Model tests MUST implement the new method"
  end

  def dynamic_get(instance, symbol)
   return  instance.send(symbol)
  end

  def dynamic_set(instance, symbol, value)
    instance.send("#{symbol}=",value)
  end

  def not_has_key(instance, lookup)
    instance.valid?
    value = "(value: #{instance.send(lookup)})" rescue ""
    assert_equal 0, instance.errors.keys.select {|key| key == lookup}.length, "found #{lookup} #{value} when it wasn't supposed to be present. Errors: " + instance.errors.full_messages.to_s
  end

  def has_key(instance, lookup)
    assert_not_same true, instance.valid?
    value = "(value: #{instance.send(lookup)})" rescue ""
    assert_equal 1, instance.errors.keys.select {|key| key == lookup}.length, "failed to find #{lookup}. Value: #{value} Errors: " + instance.errors.full_messages.to_s
  end

  def run_array_tests(symbol, array, positive=true)
    instance = new
    array.each {|v|
      dynamic_set instance, symbol, v
      if positive
        not_has_key instance, symbol
      else
        has_key instance, symbol
      end
    }
  end

  def run_positive_decimal_tests(symbol)
    run_array_tests symbol, POSITIVE_DECIMAL_VALUES
  end

  def run_negative_decimal_tests(symbol)
    run_array_tests symbol, NEGATIVE_DECIMAL_VALUES, false
  end

  def run_decimal_tests(symbol)
    run_positive_decimal_tests symbol
    run_negative_decimal_tests symbol
  end

  def run_positive_numeric_tests(symbol)
    run_array_tests symbol, POSITIVE_NUMERIC_VALUES
  end

  def run_negative_numeric_tests(symbol)
    run_array_tests symbol, NEGATIVE_NUMERIC_VALUES, false
  end

  def run_numeric_tests(symbol)
    run_positive_numeric_tests symbol
    run_negative_numeric_tests symbol
  end

  def run_required_if_set_tests(symbol)
      instance = new
      test_cases = [nil, "", " "]
      test_cases.each { |test_case|
        dynamic_set instance, symbol, test_case
        not_has_key instance, symbol
      }
  end

  def output_errors(instance)
    puts "keys: "
    puts instance.errors.keys
    instance.errors.keys.each {|key|
      puts key + " specific errors: "
      puts instance.errors[key]
    }
  end

  def validate_bounds(instance, field_symbol, test_cases, expectations, randomizer=nil)
    test_cases.each_index { |i|
      dynamic_set instance, field_symbol, test_cases[i]
      if randomizer
        instance = randomizer.call(instance)
      end
      if expectations[i]
        not_has_key instance, field_symbol
        unless instance.save
          fail "failed to save...errors: #{instance.errors.keys}"
        end
      else
        has_key instance, field_symbol
      end
    }
  end
end
