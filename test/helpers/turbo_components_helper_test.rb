# frozen_string_literal: true

require "test_helper"

class TurboComponentsHelperTest < ActionView::TestCase
  def parse_params(turbo_frame)
    src = turbo_frame["src"]
    Rack::Utils.parse_nested_query(URI(src).query)
  end

  test "async turbo_component with defaults" do
    output = turbo_component(:greetings, async: true)
    turbo_frame = Nokogiri::XML.fragment(output).at("turbo-frame")

    assert_equal turbo_frame["id"], "greetings"
    assert_not_nil turbo_frame["src"]

    params = parse_params(turbo_frame)
    assert_equal params["_turbo_id"], "greetings"
  end

  test "async turbo_component with params" do
    output = turbo_component(:greetings, turbo_id: :custom_turbo_id, async: true,
                                         loading: :async, permanent: true, target: :_top)

    turbo_frame = Nokogiri::XML.fragment(output).at("turbo-frame")

    assert_equal turbo_frame["id"], "custom_turbo_id"
    assert_equal turbo_frame["loading"], "async"
    assert_equal turbo_frame["target"], "_top"
    assert_equal turbo_frame["data-turbo-permanent"], "true"
    assert_not_nil turbo_frame["src"]

    params = parse_params(turbo_frame)
    assert_equal params["_turbo_id"], "custom_turbo_id"
  end

  test "async turbo_compoment empty locals" do
    output = turbo_component(:greetings, async: true)
    turbo_frame = Nokogiri::XML.fragment(output).at("turbo-frame")

    params = parse_params(turbo_frame)

    decoded = TurboComponent::Encryptor.decode(params["_encoded"], purpose: params["_turbo_id"])
    assert_equal decoded, []

    deserialized = ActiveJob::Arguments.deserialize(decoded)
    assert_equal deserialized, []
  end

  test "async turbo_compoment locals with complex data" do
    author = authors(:one)
    locals = { foo: "bar", "bar": "foo", hash: { foo: :bar }, array: ["foo", "bar", 1, 2, 3], author: author }
    output = turbo_component(:greetings, async: true, locals: locals)
    turbo_frame = Nokogiri::XML.fragment(output).at("turbo-frame")

    params = parse_params(turbo_frame)

    decoded = TurboComponent::Encryptor.decode(params["_encoded"], purpose: params["_turbo_id"])

    deserialized = ActiveJob::Arguments.deserialize(decoded).to_h
    assert_equal deserialized, locals
  end

  test "async turbo_component with block" do
    output = turbo_component(:greetings, async: true) { "loading" }
    turbo_frame = Nokogiri::XML.fragment(output).at("turbo-frame")
    assert_equal turbo_frame.content, "loading"
  end

  test "async turbo_component locals with no serializable objects" do
    skip("pending")
  end

  test "inline turbo_component with locals" do
    controller.params = ActionController::Parameters.new({})
    author = authors(:one)
    output = turbo_component(:greetings, async: false, locals: { author: author })
    turbo_frame = Nokogiri::XML.fragment(output).at("turbo-frame")

    assert_equal turbo_frame["id"], "greetings"
    assert_nil turbo_frame["src"]

    assert turbo_frame.content.present?
  end
end
