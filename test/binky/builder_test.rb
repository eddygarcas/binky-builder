require "test_helper"

class MyBuilder
  include Binky::Builder
end

class MyAccessorBuilder
  include Binky::AccessorBuilder
  attr_accessor :id,:text
end
class Binky::BuilderTest < Minitest::Test

  def setup
    @obj = Object.new
    class << @obj
      include Binky::BuilderHelper
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::Binky::Builder::VERSION
  end

  def test_it_does_something_useful
      elem = @obj.build_by_keys({id: 123,text: "gathering"},[:id,:text],&:to_hash)
      assert_equal elem[:id],123
      assert_equal elem[:text],"gathering"
  end

  def test_using_builder_sym_keys
    elements = MyBuilder.new.build_by_keys({id: 123,text: "gathering"},[:id,:text],&:to_hash)
    obj_builder = MyBuilder.new(elements)
    assert_equal obj_builder.id,123
    assert_equal obj_builder.text,"gathering"
  end

  def test_using_builder_text_keys
    elements = MyBuilder.new.build_by_keys({id: 123,text: "gathering"},["id","text"],&:to_hash)
    obj_builder = MyBuilder.new(elements)
    assert_equal obj_builder.id,123
    assert_equal obj_builder.text,"gathering"
  end

  def test_builder_directly
    element = MyBuilder.new({"id" => 123,text: "gathering"})
    assert_equal element.id,123
    assert_equal element.text,"gathering"
  end

  def test_accessor_builder
    element = MyAccessorBuilder.new({id: 123,text: "gathering"},MyAccessorBuilder.instance_methods(false))
    assert_equal element.id,123
    assert_equal element.text,"gathering"
  end

end
