# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/eo/site"
require_relative "../lib/eo/registry"
require_relative "../lib/eo/config"
require_relative "../lib/eo/opener"
require_relative "../lib/eo/cli"

class CLITest < Minitest::Test
  def setup
    @saved_sites = Eo::Registry.instance_variable_get(:@sites).dup
    @saved_aliases = Eo::Registry.instance_variable_get(:@aliases).dup
    Eo::Registry.instance_variable_set(:@sites, {})
    Eo::Registry.instance_variable_set(:@aliases, {})

    Eo::Registry.register("ex", Eo::Site.new(
      description: "Example",
      default_url: "https://example.com"
    ) { |s|
      s.route "dash", url: "https://example.com/dash", description: "Dashboard"
    })

    @opened_urls = []
    test_urls = @opened_urls
    Eo::Opener.define_singleton_method(:open) { |url| test_urls << url }

    @orig_accounts = Eo::Config.method(:accounts)
    Eo::Config.define_singleton_method(:accounts) { |_| {} }
  end

  def teardown
    Eo::Registry.instance_variable_set(:@sites, @saved_sites)
    Eo::Registry.instance_variable_set(:@aliases, @saved_aliases)
    Eo::Opener.define_singleton_method(:open) { |url| system("open", "-a", "Safari", url) }
    Eo::Config.define_singleton_method(:accounts, @orig_accounts)
  end

  def test_opens_default_url
    Eo::CLI.run(["ex"])
    assert_equal "https://example.com", @opened_urls.last
  end

  def test_opens_subcommand_url
    Eo::CLI.run(["ex", "dash"])
    assert_equal "https://example.com/dash", @opened_urls.last
  end

  def test_unknown_site_exits
    assert_raises(SystemExit) do
      capture_io { Eo::CLI.run(["bogus"]) }
    end
  end

  def test_unknown_subcommand_exits
    assert_raises(SystemExit) do
      capture_io { Eo::CLI.run(["ex", "nope"]) }
    end
  end

  def test_no_args_exits
    assert_raises(SystemExit) do
      capture_io { Eo::CLI.run([]) }
    end
  end

  def test_opens_account_url
    Eo::Config.define_singleton_method(:accounts) { |_| { "staging" => "https://staging.example.com" } }
    Eo::CLI.run(["-a", "staging", "ex"])
    assert_equal "https://staging.example.com", @opened_urls.last
  end

  def test_account_with_subcommand_uses_site_route
    Eo::Config.define_singleton_method(:accounts) { |_| { "staging" => "https://staging.example.com" } }
    Eo::CLI.run(["-a", "staging", "ex", "dash"])
    assert_equal "https://example.com/dash", @opened_urls.last
  end

  def test_unknown_account_exits
    assert_raises(SystemExit) do
      capture_io { Eo::CLI.run(["-a", "nope", "ex"]) }
    end
  end

  def test_default_account_used_when_no_flag
    Eo::Config.define_singleton_method(:accounts) { |_|
      { "default" => "prod", "prod" => "https://prod.example.com" }
    }
    Eo::CLI.run(["ex"])
    assert_equal "https://prod.example.com", @opened_urls.last
  end

  def test_explicit_account_overrides_default
    Eo::Config.define_singleton_method(:accounts) { |_|
      { "default" => "prod", "prod" => "https://prod.example.com", "staging" => "https://staging.example.com" }
    }
    Eo::CLI.run(["-a", "staging", "ex"])
    assert_equal "https://staging.example.com", @opened_urls.last
  end
end
