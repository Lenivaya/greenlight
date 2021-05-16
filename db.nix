{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  buildInputs = [
    # Postgresql
    glibcLocales
    (pkgs.postgresql.withPackages (p: [ p.postgis ]))
    sqitchPg
    pgcli
  ];

  # Postgresql activation
  shellHook = ''
    export PGDATA="$PWD/db"
    export SOCKET_DIRECTORIES="$PGDATA/sockets"
    export PGHOST="$SOCKET_DIRECTORIES"
    if ! [ -d $PGDATA ]; then
      initdb -D $PGDATA
      mkdir $SOCKET_DIRECTORIES
      echo "unix_socket_directories = '$SOCKET_DIRECTORIES'" >> $PGDATA/postgresql.conf
    fi
    pg_ctl -l $PGDATA/logfile start
    if ! [ -d $PGDATA ]; then
      createuser postgres --createdb -h localhost
    fi

    function end {
      echo "Shutting down the database..."
      pg_ctl stop
      # echo "Removing directories..."
      # rm -rf $PGDATA $SOCKET_DIRECTORIES
    }
    trap end EXIT
  '';
}
