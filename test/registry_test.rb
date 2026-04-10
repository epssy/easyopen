# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/eo/site"
require_relative "../lib/eo/registry"

class RegistryTest < Minitest::Test
  def setup
    # Save and clear global state
    @saved_sites = Eo::Registry.instance_variable_get(:@sites).dup
    @saved_aliases = Eo::Registry.instance_variable_get(:@aliases).dup
    Eo::Registry.instance_variable_set(:@sites, {})
    Eo::Registry.instance_variable_set(:@aliases, {})
  end

  def teardown
    Eo::Registry.instance_variable_set(:@sites, @saved_sites)
    Eo::Registry.instance_variable_set(:@aliases, @saved_aliases)
  end

  def test_register_and_fetch
    site = Eo::Site.new(description: "Test", default_url: "https://test.com")
    Eo::Registry.register("test", site)

    assert_equal site, Eo::Registry.fetch("test")
  end

  def test_fetch_unknown_returns_nil
    assert_nil Eo::Registry.fetch("nonexistent")
  end

  def test_fetch_by_alias
    site = Eo::Site.new(description: "Test", default_url: "https://test.com")
    Eo::Registry.register("t", "test", site)

    assert_equal site, Eo::Registry.fetch("t")
    assert_equal site, Eo::Registry.fetch("test")
  end

  def test_each_yields_sorted
    a = Eo::Site.new(description: "A", default_url: "https://a.com")
    b = Eo::Site.new(description: "B", default_url: "https://b.com")
    Eo::Registry.register("zz", a)
    Eo::Registry.register("aa", b)

    names = []
    Eo::Registry.each { |name, _| names << name }
    assert_equal ["aa", "zz"], names
  end
end
