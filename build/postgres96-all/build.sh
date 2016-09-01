if [ -z $1 ]; then
    echo "Usage: $0 <pg96 minor version number>"
    exit 1
fi

MINOR=$1

VER="9.6.$MINOR"
PGVER="96$MINOR"

echo "Building postgresql-$PGVER and all extensions..."

VER=$VER ../postgres96/build.sh -b
sudo pkg install -g file:///export/home/vagrant/omniti-ms/tmp.repo postgresql-$PGVER postgresql-$PGVER/contrib
PGVER=$PGVER ../pg96-pg_query_statsd/build.sh -b
PGVER=$PGVER ../pg96-mimeo/build.sh -b
PGVER=$PGVER ../pg96-pg_jobmon/build.sh -b
PGVER=$PGVER ../pg96-pg_partman/build.sh -b
VER=$VER ../pg96-plperl/build.sh -d 5.20 -b
PGVER=$PGVER ../pg96-pg_repack/build.sh -b
