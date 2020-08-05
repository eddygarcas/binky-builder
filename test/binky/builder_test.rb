require "test_helper"

class MyAccessorBuilder
  include Binky::Builder
  attr_accessor :id, :text
end

class MyObjectBuilder
  include Binky::Builder
end

class ChangelogJson
  include Binky::Helper

  def as_json
    return {:id => 123}
  end
end

class Binky::BuilderTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::Binky::Builder::VERSION
  end

  def test_it_does_something_useful
    @obj = Object.new
    class << @obj
      include Binky::Helper
    end
    elem = @obj.build_by_keys({"id" => 123, text: "gathering"}, ["id", :text])
    assert_equal elem.to_h[:id], 123
    assert_equal elem.to_h[:text], "gathering"
    assert_equal elem.id, 123
    assert_equal elem.text, "gathering"
  end


  def test_accessor_builder
    element = MyAccessorBuilder.new({"id" => 123, text: "gathering"}, MyAccessorBuilder.instance_methods(false))
    assert_equal element.id, 123
    assert_equal element.text, "gathering"
  end

  def test_empty_json_on_a_builder_instance
    foo = MyObjectBuilder.new
    foo.id = 123
    foo.text = "gathering"
    assert_equal foo.id, 123
    assert_equal foo.text, "gathering"
    foo_dos = MyObjectBuilder.new
    foo_dos.id = 321
    foo_dos.text = "split"
    foo_dos.goog = 23
    assert_equal foo_dos.id, 321
    assert_equal foo_dos.text, "split"
    assert_equal foo_dos.goog, 23
  end

end
