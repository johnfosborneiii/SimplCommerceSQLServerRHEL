#!/bin/bash
set -e

cd /app/src/SimplCommerce.WebHost && dotnet ef database update

#psql --username postgres -d simplcommerce -a -f /app/src/Database/StaticData_Postgres.sql

locale-gen en_US en_US.UTF-8
sqlcmd -S 192.168.124.49 -U sa -P 'redhat1!' -i /app/src/Database/StaticData.sql
sqlcmd -S 192.168.124.49 -U sa -P 'redhat1!' -i /app/src/Database/StaticData2.sql
sqlcmd -S 192.168.124.49 -U sa -P 'redhat1!' -i /app/src/Database/StaticData3.sql 
sqlcmd -S 192.168.124.49 -U sa -P 'redhat1!' -i /app/src/Database/StaticData4.sql

cd /app/src/SimplCommerce.WebHost && dotnet watch run
