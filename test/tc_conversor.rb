require_relative "../src/converter"
require "test/unit"

class TestConverter < Test::Unit::TestCase
	def test_simple
		assert_equal(4, 4)
		assert_equal(6, 6)
	end
end
