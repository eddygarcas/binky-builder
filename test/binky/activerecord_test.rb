require "test_helper"

class Binky::ActiveRecordTest < Minitest::Test
  def setup
    @change_log = {"id" => "5357608",
                   "author" =>
                       {"self" => "http://test.jira.com/rest/api/2/user?username=hocus.pocus",
                        "name" => "hocus.pocus",
                        "key" => "hocus.pocus",
                        "emailAddress" => "hocus.pocus@binky-builder.com",
                        "avatarUrls" => {
                            "48x48" => "http://test.jira.com/secure/useravatar?ownerId=hocus.pocus&avatarId=12221",
                            "24x24" => "http://test.jira.com/secure/useravatar?size=small&ownerId=ahocus.pocus&avatarId=12221",
                            "16x16" => "http://test.jira.com/secure/useravatar?size=xsmall&ownerId=hocus.pocus&avatarId=12221",
                            "32x32" => "http://test.jira.com/secure/useravatar?size=medium&ownerId=hocus.pocus&avatarId=12221"},
                        "displayName" => "Hocus Pocus",
                        "active" => true,
                        "timeZone" => "Europe/Madrid"
                       },
                   "created" => "2020-03-17T21:00:57.000+0100",
                   "items" => [
                       {"field" => "status", "fieldtype" => "jira", "from" => "10682", "fromString" => "Ready for Production", "to" => "10011", "toString" => "Production"}
                   ]}
  end

  def teardown
    @change_log = nil
  end

  def test_mocked_activerecord_instance
    e = ChangelogJson.new.build_by_keys(@change_log)
    assert_equal ChangelogJson.method_defined?(:as_json), true
    assert_equal e.as_json, {id: 123}
    assert_nil e.instance_variable_get(:@to_h)
  end

end