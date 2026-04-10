# frozen_string_literal: true

module Eo
  module CLI
    def self.run(args)
      if args.first == "--completions"
        args.shift
        print_completions(args.first)
        exit
      end

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

    def self.print_completions(site_name)
      if site_name.nil?
        puts Registry.all_names
      else
        site = Registry.fetch(site_name)
        site&.subcommands&.each { |name, _| puts name }
      end
    end
  end
end
