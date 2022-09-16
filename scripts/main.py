from awsglue.context import GlueContext
from pyspark.sql import SparkSession, DataFrame
from pyspark.sql import functions as f
from pyspark.sql import types as t


def main():
    spark: SparkSession = SparkSession.builder.appName("glue").getOrCreate()
    glue: GlueContext = GlueContext(spark)

    # consume data
    data_frame1: DataFrame = spark.read.json("data/dataset1.json")
    data_frame2: DataFrame = spark.read.json("data/dataset2.json")

    # clean up data
    data_frame_union: DataFrame = data_frame1.union(data_frame2)
    data_frame_union = data_frame_union.withColumn(
        "bounce", f.col("bounce").cast(t.IntegerType())
    ).withColumn(
        "session", f.col("session").cast(t.IntegerType())
    ).withColumn(
        "page_depth", f.col("page_depth").cast(t.IntegerType())
    ).withColumn(
        "date_time", f.date_format(f.col("date").cast(t.TimestampType()), "%y-%M-%d %h:%m:%s")
    ).withColumnRenamed("date", "user_session_time")

    # write data
    data_frame_union.write.partitionBy("user_session_time") \
        .mode("overwrite") \
        .parquet("user_sessions")


if __name__ == '__main__':
    main()
