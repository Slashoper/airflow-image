FROM apache/airflow:2.2.4-python3.8
USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         openjdk-11-jre-headless curl procps\
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir /opt/beeline \
	&& curl -SL https://archive.apache.org/dist/hadoop/core/hadoop-3.0.0/hadoop-3.0.0.tar.gz \
	| tar -xzC /opt/beeline \
	&& curl -SL https://archive.apache.org/dist/hive/hive-2.1.1/apache-hive-2.1.1-bin.tar.gz \
	| tar -xzC /opt/beeline \
	&& curl -SL https://repo1.maven.org/maven2/io/trino/trino-cli/400/trino-cli-400-executable.jar --output /opt/beeline/trino \
	&& chmod +x /opt/beeline/trino
ENV HADOOP_HOME /opt/beeline/hadoop-3.0.0
ENV HIVE_HOME /opt/beeline/apache-hive-2.1.1-bin
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH $PATH:$HIVE_HOME/bin
USER airflow
RUN pip install --no-cache-dir apache-airflow-providers-apache-spark==2.1.0 \
	&& pip install --no-cache-dir apache-airflow-providers-apache-sqoop==2.1.0 \
	&& pip install trino \
	&& pip install trino[sqlalchemy]
