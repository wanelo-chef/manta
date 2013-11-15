Manta
=====

## Description

Installs keys and client for Manta.

## Requirements

* SmartOS

## Usage

This cookbook creates a configuration file in the home directory of the user connecting to Manta.
For scripts that require an ssh-agent, `$HOME` should be set before `.manta_config` is
loaded to ensure that an ssh-agent is initialized. The config file will attempt to start an ssh-agent
for the user if one is not already running. If `$USER` is set, it will use that, otherwise it will try
to discover `$USER` using `whoami`.

## Attributes

* `manta.user` -- used by `manta::keys` recipe to install private keys into correct path
* `manta.authentication_user` -- used by `manta::client` recipe to configure user's bashrc. This should match the
  identifier for the public_key added in the Manta configuration interface (otherwise known as Mark Cavage).

## Data bags and items

The `manta::keys` recipe expects a data bag item `manta::keys` with the following format:

```json
{
  "id": "keys",
  "name": "manta_key",
  "private_key": "content\nof\nprivate key",
  "public_key": "content\of\public\nkey
}
```

The `name` will be used as the file name of the key (ie `~/user/.ssh/manta_key`, `~/user/.ssh/manta_key.pub`). Note
that line feeds have been replaced by \n characters, to make the key compatible with JSON.
In the strange case where there is a \ character in the private key, ensure that it is escaped (ie \\).

Public keys should be added as well as private keys, as they are used to generate a footprint that gets added to all
API requests.

## Recipes

* `manta::keys` -- install private keys into `node.manta.user`'s home directory.
* `manta::client` -- install node client libraries

`manta::keys` can be run by itself, if for instance the host will only connect to Manta via alternative client libraries
such as a ruby gem or a python thing (whatever python things are called). `manta::client` will also run `manta::keys` to
generate correct environment configurations.

## Installed configurations

The `manta::keys` cookbook will install its public and private key into the `~user/.ssh` directory. The `manta::client`
cookbook will install its client configuration in the `~user/.manta_config` file.
