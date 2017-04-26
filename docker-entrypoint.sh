#!/bin/bash

echo SQL_SERVER_HOST=$SQL_SERVER_HOST
echo SQL_SERVER_PORT=$SQL_SERVER_PORT
echo SQL_SERVER_USERNAME=$SQL_SERVER_USERNAME
echo SQL_SERVER_PASSWORD=$SQL_SERVER_PASSWORD

SQL_SERVER_CONN=$SQL_SERVER_HOST

if [[ $SQL_SERVER_PORT = "1433" ]]
then
  echo Default port
else
  SQL_SERVER_CONN+=','
  SQL_SERVER_CONN+=$SQL_SERVER_PORT
  echo $SQL_SERVER_CONN
fi

export SQL_SERVER_DB_STR="Server=$SQL_SERVER_CONN;Database=SimplCommerce;uid=$SQL_SERVER_USERNAME;pwd=$SQL_SERVER_PASSWORD;MultipleActiveResultSets=true"
echo SQL_SERVER_DB_STR=$SQL_SERVER_DB_STR

cd /app/src && dotnet restore && dotnet build **/**/project.json
cd /app/src/SimplCommerce.WebHost && npm install && npm install --global gulp-cli && gulp copy-modules


/opt/mssql-tools/bin/sqlcmd -S $SQL_SERVER_CONN -U $SQL_SERVER_USERNAME -P $SQL_SERVER_PASSWORD -i /app/src/Database/Clear_SQL_Server.sql
cd /app/src/SimplCommerce.WebHost && dotnet ef database update

/opt/mssql-tools/bin/sqlcmd -S $SQL_SERVER_CONN -U $SQL_SERVER_USERNAME -P $SQL_SERVER_PASSWORD -i /app/src/Database/StaticData.sql
/opt/mssql-tools/bin/sqlcmd -S $SQL_SERVER_CONN -U $SQL_SERVER_USERNAME -P $SQL_SERVER_PASSWORD -i /app/src/Database/StaticData2.sql
/opt/mssql-tools/bin/sqlcmd -S $SQL_SERVER_CONN -U $SQL_SERVER_USERNAME -P $SQL_SERVER_PASSWORD -i /app/src/Database/StaticData3.sql
/opt/mssql-tools/bin/sqlcmd -S $SQL_SERVER_CONN -U $SQL_SERVER_USERNAME -P $SQL_SERVER_PASSWORD -i /app/src/Database/StaticData4.sql

cd /app/src/SimplCommerce.WebHost && dotnet watch run
