if [ -z $1 ]; then
    echo "Usage: $0 <pg92 minor version number>"
    exit 1
fi

MINOR=$1

VER="9.2.$MINOR"
PGVER="92$MINOR"

echo "Building postgresql-$PGVER and all extensions..."

VER=$VER ../postgres92/build.sh -b
sudo pkg install -g file:///export/home/vagrant/omniti-ms/tmp.repo postgresql-$PGVER postgresql-$PGVER/contrib
PGVER=$PGVER ../pg92-pg_query_statsd/build.sh -b
PGVER=$PGVER ../pg92-mimeo/build.sh -b
PGVER=$PGVER ../pg92-pg_jobmon/build.sh -b
PGVER=$PGVER ../pg92-pg_partman/build.sh -b
VER=$VER ../pg92-plperl/build.sh -d 5.20 -b
#VER=$VER ../pg92-pg_upgrade/build.sh -b
PGVER=$PGVER ../pg92-pg_repack/build.sh -b
