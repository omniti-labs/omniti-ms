if [ -z $1 ]; then
    echo "Usage: $0 <pg95 minor version number>"
    exit 1
fi

MINOR=$1

VER="9.5.$MINOR"
PGVER="95$MINOR"

echo "Building postgresql-$PGVER and all extensions..."

VER=$VER ../postgres95/build.sh
sudo pkg install -g file:///export/home/vagrant/omniti-ms/tmp.repo postgresql-$PGVER
VER=$VER ../pg95-dblink/build.sh
VER=$VER ../pg95-pg_stat_statements/build.sh
PGVER=$PGVER ../pg95-pg_query_statsd/build.sh
PGVER=$PGVER ../pg95-mimeo/build.sh
PGVER=$PGVER ../pg95-pg_jobmon/build.sh
PGVER=$PGVER ../pg95-pg_partman/build.sh
VER=$VER ../pg95-plperl/build.sh -d 5.20
VER=$VER ../pg95-pgcrypto/build.sh
VER=$VER ../pg95-fuzzystrmatch/build.sh
VER=$VER ../pg95-hstore/build.sh
VER=$VER ../pg95-btree_gist/build.sh
VER=$VER ../pg95-pg_buffercache/build.sh
PGVER=$PGVER ../pg95-pg_repack/build.sh
VER=$VER ../pg95-tablefunc/build.sh
