Description
===========
This cookbook installs and configures [rsnapshot][rsnapshot] servers and
clients.  Rsnapshot is a tool for taking rotating snapshot backups of
files over ssh and rsyc using mostly GNU standard commands and a little
bit of Perl.

Requirements
============
This cookbook requires the cron, openssh, rsync, and sudo cookbooks, all
from the community site.

It also relies on `node['authorization']['sudo']['include_sudoers_d']`
being  set to `true` on clients.

Attributes
==========
General
-------
* `node['rsnapshot']['server_role']` - Role name that the server will
  have.  Clients search for this to see which servers will be allowed to
  log in to back them up.  The default is "rsnapshot_server"
* `node['rsnapshot']['client_role']` - Role name that a client will
  have.  The server searches for this to see what targets to add.  The
  default is "rsnapshot_client"

Clients
-------
* `node['rsnapshot']['client']['username']` - The user that will log into
  a client to perform backups.  This user will have some limited sudo
  permissions on the client. The default is "rsnapshot"
* `node['rsnapshot']['client']['paths']` - An array of paths that you
  want to back up on the client. The default is an empty array.

Server
------
* `node['rsnapshot']['server']['config_file']` - The rsnapshot
  configuration file. The default is  "/etc/rsnapshot.conf"
* `node['rsnapshot']['server']['snapshot_root']` Where on the server to
  store the backups. The default is "/backup"
* `node['rsnapshot']['server']['ssh_key']` - The RSA public key of root
  on the server.  This "defaults" to `nil`, but is set by the recipe
  from the public key file on the chef run.  Don't set this manualy.
* `node['rsnapshot']['server']['clients']` - This is a hash of clients
  that _don't_ have the client role on them.  This might be good if you -
  for some reason - have some clients that aren't running chef.  The
  format is `{"fqdn" => ["/array/of/", "/some/paths"]}` and the default
  is an empty hash.

The `node['rsnapshot']['server']['retain']` key holds the interval types
that the server will run and the number of each to keep. e.g. for the
default values listed below, we will keep seven versions of the 'daily'
interval.  If a value is set to `nil` or `false`, it won't run.

Of note, the 'hourly' key also controlls how often we run the 'hourly'
snapshot.  For the defaults below, the 'hourly' snapshot actually runs
two times per day, not hourly.  Setting this to a value greater-than 24
is no good.

These are the defaults:
* `node['rsnapshot']['server']['retain']['hourly']` = 2
* `node['rsnapshot']['server']['retain']['daily']` = 7
* `node['rsnapshot']['server']['retain']['weekly']` = 2
* `node['rsnapshot']['server']['retain']['monthly']` = nil

Recipes
=======
This cookbook contains the recipes `rsnapshot::server` and
`rsnapshot::client`.  There is no default recipe.

[rsnapshot]: http://www.rsnapshot.org/
