FROM amazoncorretto:8 as pyspark

MAINTAINER "DirksCGM"

RUN yum clean all && \
    rm -rf /var/cache/yum/* && \
    yum install -y python3 tar git wget zip procps maven && \
    yum install -y python3-devel && \
    pip3 install pandas boto3 pynt pyspark pyarrow && \
    pip3 install --upgrade pip

RUN mkdir glue
WORKDIR ./glue

RUN git clone -b glue-1.0 https://github.com/awslabs/aws-glue-libs.git && \
    echo 'export SPARK_HOME="$(ls -d /root/*spark*)"; export MAVEN_HOME="$(ls -d /root/*maven*)"; export PATH="$PATH:$MAVEN_HOME/bin:$SPARK_HOME/bin:/glue/bin"' >> ~/.bashrc

ENV PYSPARK_PYTHON=/usr/bin/python3
ENV MAVEN_HOME=/glue/apache-maven-3.6.0
ENV GLUE_HOME=/glue/aws-glue-libs
ENV PATH=$PATH:$MAVEN_HOME/bin:/opt/spark/bin:/usr/lib/jvm/java-1.8.0-amazon-corretto/bin:$GLUE_HOME/bin

WORKDIR aws-glue-libs
RUN bash -l -c 'bash bin/glue-setup.sh'

COPY scripts/* scripts/


