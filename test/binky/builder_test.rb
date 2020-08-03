require "test_helper"

class MyBuilder
  include Binky::Struct
end

class MyAccessorBuilder
  include Binky::Builder
  attr_accessor :id,:text
end

class Changelog
  include Binky::Helper
end

class Binky::BuilderTest < Minitest::Test

  def setup
    @change_log = {"id"=>"5357608",
                   "author"=>
                       {"self"=>"http://jira.privalia.pin/rest/api/2/user?username=albert.agusti",
                        "name"=>"albert.agusti",
                        "key"=>"albert.agusti",
                        "emailAddress"=>"albert.agusti@veepee.com",
                        "avatarUrls"=>{
                            "48x48"=>"http://jira.privalia.pin/secure/useravatar?ownerId=albert.agusti&avatarId=12221",
                            "24x24"=>"http://jira.privalia.pin/secure/useravatar?size=small&ownerId=albert.agusti&avatarId=12221",
                            "16x16"=>"http://jira.privalia.pin/secure/useravatar?size=xsmall&ownerId=albert.agusti&avatarId=12221",
                            "32x32"=>"http://jira.privalia.pin/secure/useravatar?size=medium&ownerId=albert.agusti&avatarId=12221"},
                        "displayName"=>"Albert Agusti Costa",
                        "active"=>true,
                        "timeZone"=>"Europe/Madrid"
                       },
                   "created"=>"2020-03-17T21:00:57.000+0100",
                   "items"=>[{"field"=>"status","fieldtype"=>"jira","from"=>"10682","fromString"=>"Ready for Production","to"=>"10011","toString"=>"Production"}]}

  end

  def test_that_it_has_a_version_number
    refute_nil ::Binky::Builder::VERSION
  end

  def test_it_does_something_useful
    @obj = Object.new
    class << @obj
      include Binky::Helper
    end
      elem = @obj.build_by_keys({"id" => 123,text: "gathering"},["id",:text])
      assert_equal elem.to_hash[:id],123
      assert_equal elem.to_hash[:text],"gathering"
  end

  def test_using_builder_sym_keys
    elements = MyBuilder.new.build_by_keys({"id" => 123,text: "gathering"},["id",:text])
    obj_builder = MyBuilder.new(elements.to_hash)
    assert_equal obj_builder.id,123
    assert_equal obj_builder.text,"gathering"
  end

  def test_using_builder_text_keys
    elements = MyBuilder.new.build_by_keys({"id" => 123,text: "gathering"},["id",:text])
    obj_builder = MyBuilder.new(elements.to_hash)
    assert_equal obj_builder.id,123
    assert_equal obj_builder.text,"gathering"
  end

  def test_builder_directly
    element = MyBuilder.new({"id" => 123,text: "gathering"})
    assert_equal element.id,123
    assert_equal element.text,"gathering"
  end

  def test_accessor_builder
    element = MyAccessorBuilder.new({"id" => 123,text: "gathering"},MyAccessorBuilder.instance_methods(false))
    assert_equal element.id,123
    assert_equal element.text,"gathering"
  end

  def test_builder_with_real_data
    e = Changelog.new.build_by_keys(@change_log,["id","fromString","toString","fieldtype","avatar"])
    assert_equal e.to_hash[:toString],"Production"
    assert_equal e.to_hash[:fromString],"Ready for Production"
  end

  def test_builder_without_keys
    e = Changelog.new.build_by_keys(@change_log)
    assert_equal e.to_hash[:items][0]["toString"],"Production"
    assert_equal e.to_hash[:items][0]["fromString"],"Ready for Production"

  end

end
