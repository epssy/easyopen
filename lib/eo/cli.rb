# frozen_string_literal: true

module Eo
  module CLI
    def self.run(args)
      if args.first == "--completions"
        args.shift
        print_completions(args)
        exit
      end

      account = extract_flag(args, "-a", "--account")
      site_name = args.shift
      subcommand = args.shift

      if site_name.nil?
        puts "Usage: eo [-a <account>] <site> [subcommand]"
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

      accounts = Config.accounts(site_name)
      account ||= accounts["default"]

      if account
        account_url = accounts[account]
        if account_url.nil?
          $stderr.puts "Unknown account '#{account}' for #{site_name}"
          available = accounts.keys - ["default"]
          if available.any?
            $stderr.puts
            $stderr.puts "Available accounts:"
            available.each { |name| $stderr.puts "  #{name}" }
          end
          exit 1
        end
        url = subcommand ? site.url_for(subcommand) : account_url
      else
        url = site.url_for(subcommand)
      end

      if url.nil?
        $stderr.puts "Unknown subcommand '#{subcommand}' for #{site_name}"
        $stderr.puts
        $stderr.puts "Available subcommands:"
        site.subcommands.each { |name, desc| $stderr.puts "  %-12s %s" % [name, desc] }
        exit 1
      end

      puts site.note if site.note
      Opener.open(url)
    end

    def self.extract_flag(args, *flags)
      flags.each do |flag|
        idx = args.index(flag)
        next unless idx

        args.delete_at(idx)
        return args.delete_at(idx)
      end
      nil
    end

    def self.print_completions(args)
      kind = args.shift
      if kind == "accounts"
        site_name = args.shift
        if site_name
          Config.accounts(site_name).each_key { |name| puts name unless name == "default" }
        end
      elsif kind.nil?
        puts Registry.all_names
      else
        site = Registry.fetch(kind)
        site&.subcommands&.each { |name, _| puts name }
      end
    end
  end
end
