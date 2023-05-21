# NiFi POC 
## Connecting a SQL Server to Snowflake

*"I love deadlines. I love the whooshing noise they make as they go by." - Douglas Adams*

1. Create the docker image:
```bash
docker build -t nifi-image .
```
2. Create the container based on the image
```bash
docker-compose up
```
## Logging into NiFi

Access to NiFi can be gained by navigating to the following URL in a browser:


https://localhost:8443/nifi

The default username and password are both generated and can be collected by running the following command once the container is running:
```bash
docker logs nifi-container | grep "Generated"
```

## Set up 
### Configure Control Service for SQL Server:
| Parameter | Value |
| --- | --- |
|Database connection URL | jdbc:sqlserver://\<ip address>:1433databaseName=test_onprem |
|Database Driver location(s) | /opt/nifi/nifi-current/lib/mssql-jdbc-12.2.0.jre11.jar |
|Database Driver Class Name | com.microsoft.sqlserver.jdbc.SQLServerDriver
| Database User | \<user name> |
| Database Password | \<your password>|

<em> N.B. I had an issue with encryption when connecting to SQL Edge, so I needed to add **;encrypt=false** to the connection URL</em>

<em>N.N.B. Remember that Docker runs in its own sandbox so can't use **localhost** in the URL</em>

### Configure Control Service for Snowflake:

| Parameter | Value |
| --- | --- |
|Database connection URL | jdbc\:snowflake://\<account>.snowflakecomputing.com/?db=test&warehouse=test&schema=public |
|Database Driver location(s) | /opt/nifi/nifi-current/lib/snowflake-jdbc-3.12.5.jar |
|Database Driver Class Name | net.snowflake.client.jdbc.SnowflakeDriver |
| Database User | \<user name> |
| Database Password | \<your password>|


### Configure the ExecuteSQL processor for SQL Server:

| Parameter | Value |
| --- | --- |
|Database Connection Pooling Service | SQL Server Connection Pooling Service |
|SQL select query | SELECT * FROM dbo.test_table |
| Max Rows Per Flow File | 1000 |
| Max Wait Time | 1 min |
| Max Wait Time Unit | MINUTES |
| Fetch Size | 1000 |
| Max Number of Statements | 1 |
| Stop Processing on Failure | false |

the above processor configurations should allow a flow to be created that will read from SQL Server and write to Snowflake.

![Pipline to Snowflake](./images/pipeline%20to%20Snowflake.png)
