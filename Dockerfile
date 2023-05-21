FROM apache/nifi:latest

COPY ./lib/mssql-jdbc-12.2.0.jre11.jar /opt/nifi/nifi-current/lib/
COPY ./lib/snowflake-jdbc-3.13.9.jar /opt/nifi/nifi-current/lib/
