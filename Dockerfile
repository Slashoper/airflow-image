FROM apache/airflow:2.2.4
USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         openjdk-11-jre-headless build-essential libsasl2-dev libkrb5-dev krb5-kdc curl\
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir /opt/beeline \
	&& curl -SL https://archive.apache.org/dist/hadoop/core/hadoop-3.0.0/hadoop-3.0.0.tar.gz \
	| tar -xzC /opt/beeline \
	&& curl -SL https://archive.apache.org/dist/hive/hive-2.1.1/apache-hive-2.1.1-bin.tar.gz \
	| tar -xzC /opt/beeline
ENV HADOOP_HOME /opt/beeline/hadoop-3.0.0
ENV HIVE_HOME /opt/beeline/apache-hive-2.1.1-bin
ENV PATH $PATH:$HIVE_HOME/bin
USER airflow
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
RUN pip install --no-cache-dir apache-airflow-providers-apache-spark==2.1.0
