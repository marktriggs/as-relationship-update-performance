Performance Fixes
=================

ArchivesSpace plugin to add some performance fixes to ArchivesSpace
database queries.

## Installing it

To install, just activate the plugin in your config/config.rb file by
including an entry such as:

     # If you have other plugins loaded, just add
     # 'as-relationship-update-performance' to the list
     AppConfig[:plugins] = ['local', 'other_plugins', 'as-relationship-update-performance']

And then clone the `container_management` repository into your
ArchivesSpace plugins directory.  For example:

     cd /path/to/your/archivesspace/plugins
     git clone https://github.com/hudmol/as-relationship-update-performance.git container_management

Finally, run the database setup script to update all tables to the latest version:

     cd /path/to/archivesspace
     scripts/setup-database.sh
