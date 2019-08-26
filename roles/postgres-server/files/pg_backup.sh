#! /bin/bash

# backup-postgresql.sh
# by Craig Sanders &lt;cas@taz.net.au&gt;
# This script is public domain.  feel free to use or modify
# as you like.

DUMPALL='/usr/bin/pg_dumpall'
PGDUMP='/usr/bin/pg_dump'
PSQL='/usr/bin/psql'

# directory to save backups in, must be rwx by postgres user
DIR='/var/lib/pgsql/backup'
mkdir -p "$DIR"
cd "$DIR"

# get list of databases in system , exclude the tempate dbs
DBS=$($PSQL -l -t | egrep -v 'template[01]' | awk '{print $1}' | egrep -v '^\|' | egrep -v '^$')

# first dump entire postgres database, including pg_shadow etc.
$DUMPALL --column-inserts | gzip -9 > "$DIR/everything.gz"

# next dump globals (roles and tablespaces) only
$DUMPALL --globals-only | gzip -9 > "$DIR/globals.gz"

# now loop through each individual database and backup the
# schema and data separately
for database in ${DBS[@]} ; do
    SCHEMA="$DIR/$database.schema.gz"
    DATA="$DIR/$database.data.gz"
    INSERTS="$DIR/$database.inserts.gz"
    FULL="$DIR/$database.full.gz"

    # export data from postgres databases to plain text:

    # dump schema
    echo "Creating schema dump of $database"
    $PGDUMP --create --clean --schema-only "$database" |
        gzip -9 > "$SCHEMA"

    # dump data
    echo "Creating data-only dump of $database"
    $PGDUMP --disable-triggers --data-only "$database" |
        gzip -9 > "$DATA"

    # dump data as column inserts for a last resort backup
    echo "Creating column-insert dump of $database"
    $PGDUMP --disable-triggers --data-only --column-inserts \
        "$database" | gzip -9 > "$INSERTS"

    echo "Creating full dump of $database"
    $PGDUMP "$database" | gzip -9 > "$FULL"

done
