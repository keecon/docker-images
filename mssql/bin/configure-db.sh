#!/bin/bash

# Wait 120 seconds for SQL Server to start up by ensuring that
# calling SQLCMD does not return an error code, which will ensure that sqlcmd is accessible
# and that system and user databases return "0" which means all databases are in an "online" state
# https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-databases-transact-sql?view=sql-server-2017

declare -i DBSTATUS=1
declare -i ERRCODE=1
declare -i TIME=0

echo "starting configure-db.sh ..."

while [[ $DBSTATUS -ne 0 ]] && [[ $TIME -lt 120 ]]; do
	DBSTATUS=$(/opt/mssql-tools/bin/sqlcmd -S localhost -h -1 -t 1 -U sa -P $MSSQL_SA_PASSWORD -i /usr/local/mssql/init.d/check-init.sql)
	ERRCODE=$?
	echo "DBSTATUS: $DBSTATUS, ERRCODE: $ERRCODE, TIME: $TIME"

	TIME=${TIME+5}
	if [ $ERRCODE -ne 0 ]; then
		DBSTATUS=$ERRCODE
	fi

	sleep 5
done

if [ $DBSTATUS -ne 0 ] || [ $ERRCODE -ne 0 ]; then
	echo "SQL Server took more than 120 seconds to start up or one or more databases are not in an ONLINE state"
	exit 1
fi

echo "starting sqlcmd user setup script ..."

# Run the setup script to create the DB and the schema in the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $MSSQL_SA_PASSWORD -d master -i /usr/local/mssql/init.d/setup.sql
ERRCODE=$?
if [ $ERRCODE -ne 0 ]; then
	exit 1
fi

echo "setup success. shutdown server ..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $MSSQL_SA_PASSWORD -d master -Q "SHUTDOWN WITH NOWAIT"
