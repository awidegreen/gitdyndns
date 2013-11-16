# Gitdyndns

The idea is to use a git repository as DDNS provider. 

## Scenario - OpenVPN

Use `gitdyndns.push` on your server (e.g. VPN server in your LAN at home).
For example define a `cron` job that will update the git repo (and push) 
every 12h.

Use `gitdyndns.pull` on your laptop to fetch the latest commits (changes) from
your git repo - which has been updated by the server. Use the output of 
`gitdyndns.pull` as an input for the openvpn command. 

## Installation

    $ gem install gitdyndns

## Usage

* create a remote git repo (e.g. bitbucket or gist)
* clone it to your server and laptop
* make sure that the server can commit to the repo (SSH key)
* set your configuration
* set your cron job

### Configuration for `push` and `pull`

gitdyndns configuration can either be done in a config file or via environment 
variables (in that order).

**Configuration file.**
Put a config file `.gitdyndns.yaml` in your home, e.g. `~/.gitdyndns.yaml`.
The file expects two values:
    
    lan_name: my_network
    repo_path: /home/username/my_gitddns_repo

**Configuration environment variable**
Instead of using the config file, export two env vars in your login shell.

    epxort GITDYNDNS_LAN_NAME="my_network"
    export GITDYNDNS_REPO_PATH="/home/username/my_gitddns_repo"


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
