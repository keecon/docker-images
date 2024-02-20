#!/bin/bash

# Start the script to create the DB and user
/usr/local/mssql/bin/configure-db.sh &

# Start SQL Server
/opt/mssql/bin/sqlservr

