# Easy Open

A simple app that opens third-party web tools from the CLI.

```
$ eo dd          # opens Datadog
$ eo dd metrics  # opens Datadog Metrics Explorer
$ eo aws use1    # opens AWS US-East-1 console
$ eo pagerduty   # long names work too
```

Run `eo` with no arguments to see all available sites and `eo <site>` with an
unknown subcommand to see its available subcommands.

## Installation

Symlink the `eo` script and shell completions into `~/.local`:

```bash
ln -sf "$PWD/bin/eo" ~/.local/bin/eo

# Zsh
mkdir -p ~/.local/share/zsh/site-functions
ln -sf "$PWD/completions/_eo" ~/.local/share/zsh/site-functions/_eo

# Bash
mkdir -p ~/.local/share/bash-completion/completions
ln -sf "$PWD/completions/eo.bash" ~/.local/share/bash-completion/completions/eo
```

For Zsh, ensure `~/.local/share/zsh/site-functions` is on your `fpath` before
`compinit` in `~/.zshrc`:

```zsh
fpath=(~/.local/share/zsh/site-functions $fpath)
```

### Configuration

Create `~/.eorc` to customize behaviour:

```yaml
browser: Google Chrome

accounts:
  dd:
    production: https://app.datadoghq.com
    staging: https://app.datadoghq.eu
  aws:
    root: https://123456789012.signin.aws.amazon.com/console
    iam: https://567890123456.signin.aws.amazon.com/console
```

Use `-a` to select an account:

```
$ eo -a staging dd          # opens Datadog staging
$ eo -a staging dd metrics  # opens Datadog staging, then metrics subcommand
$ eo -a root aws            # opens AWS root account console
```

Tab completion includes account names after `-a`.


## Adding a new site

Drop a Ruby file in `sites/` — see `sites/example.rb` for a template:

```ruby
# sites/myservice.rb
require_relative "../lib/eo/site"

Eo::Registry.register "ms", "myservice", Eo::Site.new(
  description: "My Service",
  default_url: "https://myservice.com"
) { |s|
  s.route "dash", url: "https://myservice.com/dashboard", description: "Dashboard"
}
```

The first name is the short alias, additional names are long aliases. Both
`eo ms` and `eo myservice` will work. Routes are optional.

## Running tests

```
ruby test/site_test.rb test/registry_test.rb test/cli_test.rb
```
