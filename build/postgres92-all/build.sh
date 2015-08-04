if [ -z $1 ]; then
    echo "Usage: $0 <pg92 minor version number>"
    exit 1
fi

MINOR=$1

VER="9.2.$MINOR"
PGVER="92$MINOR"

echo "Building postgresql-$PGVER and all extensions..."

VER=$VER ../postgres92/build.sh
VER=$VER ../pg92-dblink/build.sh
VER=$VER ../pg92-pg_stat_statements/build.sh
PGVER=$PGVER ../pg92-pg_query_statsd/build.sh
PGVER=$PGVER ../pg92-mimeo/build.sh
PGVER=$PGVER ../pg92-pg_jobmon/build.sh
PGVER=$PGVER ../pg92-pg_partman/build.sh
VER=$VER ../pg92-plperl/build.sh -d 5.20
VER=$VER ../pg92-pgcrypto/build.sh
VER=$VER ../pg92-fuzzystrmatch/build.sh
VER=$VER ../pg92-hstore/build.sh
VER=$VER ../pg92-btree_gist/build.sh
VER=$VER ../pg92-pg_buffercache/build.sh
VER=$VER ../pg92-pg_upgrade/build.sh
PGVER=$PGVER ../pg92-pg_repack/build.sh
#VER=$VER ../pg92-tablefunc/build.sh