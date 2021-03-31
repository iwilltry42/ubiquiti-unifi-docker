#!/bin/bash
set -e

mongo <<EOF
  use ${MONGO_INITDB_DATABASE};
  db.createUser(
    {
      user: "${MONGO_INITDB_USER}",
      pwd: "${MONGO_INITDB_PASS}",
      roles: [
        { role: "dbOwner", db: "${MONGO_INITDB_DATABASE}"},
        { role: "dbOwner", db: "${MONGO_INITDB_DATABASE}_stat"},
        { role: "read", db: "admin"}
      ]
    }
  );

  use ${MONGO_INITDB_DATABASE}_stat;
  db.createUser(
    {
      user: "${MONGO_INITDB_USER}",
      pwd: "${MONGO_INITDB_PASS}",
      roles: [
        { role: "dbOwner", db: "${MONGO_INITDB_DATABASE}_stat"}
      ]
    }
  );
EOF