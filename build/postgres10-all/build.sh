if [ -z $1 ]; then
    echo "Usage: $0 <pg10 minor version number>"
    exit 1
fi

MINOR=$1

VER="10.$MINOR"
PGVER="10$MINOR"

echo "Building postgresql-$PGVER and all extensions..."

VER=$VER ../postgres10/build.sh -b
sudo pkg install -g file:///export/home/vagrant/omniti-ms/tmp.repo postgresql-$PGVER postgresql-$PGVER/contrib
PGVER=$PGVER ../pg10-pg_query_statsd/build.sh -b
PGVER=$PGVER ../pg10-mimeo/build.sh -b
PGVER=$PGVER ../pg10-pg_jobmon/build.sh -b
PGVER=$PGVER ../pg10-pg_partman/build.sh -b
VER=$VER ../pg10-plperl/build.sh -d 5.20 -b
PGVER=$PGVER ../pg10-pg_repack/build.sh -b
VER=$VER ../pg10-pg_stat_statements/build.sh -b
