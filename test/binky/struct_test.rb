require "test_helper"

class MyStruct
  include Binky::Struct
end

class Binky::StructTest < Minitest::Test
  def setup
    @simple_struct = {
        "id" => "5357608",
        "author" => "hocus.pocus",
        "key" => "hocus.pocus",
        "emailAddress" => "hocus.pocus@binky-builder.com",
        "displayName" => "Hocus Pocus",
        "active" => true,
        "timeZone" => "Europe/Madrid"
    }
  end

  def teardown
    @simple_struct = nil
  end

  def test_struct_getting_as_json
    el = MyStruct.new(@simple_struct)
    assert_equal el.to_h["id"],el.id
    assert_equal el.to_h["author"],el.author
  end

  def test_using_builder_sym_keys
    elements = MyStruct.new.build_by_keys({"id" => 123, text: "gathering"}, ["id", :text])
    obj_builder = MyStruct.new(elements.to_h)
    assert_equal obj_builder.id, 123
    assert_equal obj_builder.text, "gathering"
  end

  def test_if_struct_is_nil
    str = MyStruct.new
    str.id = 123
    assert_equal str.id, 123
  end

  def test_using_builder_text_keys
    elements = MyStruct.new.build_by_keys({"id" => 123, text: "gathering"}, ["id", :text])
    obj_builder = MyStruct.new(elements.to_h)
    assert_equal obj_builder.id, 123
    assert_equal obj_builder.text, "gathering"
  end

  def test_builder_directly
    element = MyStruct.new({"id" => 123, text: "gathering"})
    assert_equal element.id, 123
    assert_equal element.text, "gathering"
  end
end