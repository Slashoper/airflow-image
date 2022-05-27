FROM apache/airflow:2.2.4
USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         openjdk-11-jre-headless build-essential libsasl2-dev\
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER airflow
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
RUN pip install --no-cache-dir apache-airflow-providers-apache-spark==2.1.0 \
  && pip install --no-cache-dir apache-airflow-providers-apache-hive=2.2.0 \
  && pip install --no-cache-dir apache-airflow-providers-apache-sqoop=2.1.0 \
  && pip install --no-cache-dir apache-airflow-providers-mongo=2.3.0 \
  && pip install --no-cache-dir apache-airflow-providers-mysql=2.2.0 \
  && pip install --no-cache-dir apache-airflow-providers-jdbc=2.1.0 \
  && pip install --no-cache-dir apache-airflow-providers-apache-hdfs=2.2.0
