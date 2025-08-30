FROM openjdk:11-slim

# Spark & Hadoop versions
ENV SPARK_VERSION=3.5.0 \
    HADOOP_VERSION=3 \
    DELTA_VERSION=3.2.0

# Install curl, python
RUN apt-get update && apt-get install -y curl python3 python3-pip && rm -rf /var/lib/apt/lists/*

# Install Spark
RUN curl -L https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    | tar xvz -C /opt/ && \
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark

ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH

# Install pyspark + delta
RUN pip3 install pyspark==${SPARK_VERSION} delta-spark==${DELTA_VERSION}

WORKDIR /workspace
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN apt-get update && apt-get install -y curl python3 python3-pip procps && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/entrypoint.sh"]