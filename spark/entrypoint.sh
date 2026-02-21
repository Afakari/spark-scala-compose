#!/bin/bash
set -e


if [ "$SPARK_MODE" == "master" ]; then
    echo "Starting Spark Master..."
    export SPARK_MASTER_HOST=`hostname`
    exec /opt/spark/bin/spark-class org.apache.spark.deploy.master.Master

elif [ "$SPARK_MODE" == "worker" ]; then
    echo "Starting Spark Worker..."
    if [ -z "$SPARK_MASTER_URL" ]; then
      echo "Error: SPARK_MASTER_URL is not set"
      exit 1
    fi
    exec /opt/spark/bin/spark-class org.apache.spark.deploy.worker.Worker $SPARK_MASTER_URL

else
    exec "$@"
fi
