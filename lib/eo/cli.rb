# frozen_string_literal: true

module Eo
  module CLI
    def self.run(args)
      site_name = args.shift
      subcommand = args.shift

      if site_name.nil?
        puts "Usage: eo <site> [subcommand]"
        puts
        puts "Available sites:"
        Registry.each { |name, site| puts "  %-12s %s" % [name, site.description] }
        exit
      end

      site = Registry.fetch(site_name)
      if site.nil?
        $stderr.puts "Unknown site: #{site_name}"
        $stderr.puts "Run `eo` to see available sites."
        exit 1
      end

      url = site.url_for(subcommand)
      if url.nil?
        $stderr.puts "Unknown subcommand '#{subcommand}' for #{site_name}"
        $stderr.puts
        $stderr.puts "Available subcommands:"
        site.subcommands.each { |name, desc| $stderr.puts "  %-12s %s" % [name, desc] }
        exit 1
      end

      Opener.open(url)
    end
  end
end
