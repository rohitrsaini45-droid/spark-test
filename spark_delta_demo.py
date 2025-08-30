from pyspark.sql import SparkSession
from delta import configure_spark_with_delta_pip

builder = SparkSession.builder \
    .appName("DeltaDemo") \
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")

spark = configure_spark_with_delta_pip(builder).getOrCreate()

# Read JSON
df = spark.read.json("/workspace/data/input.json")
df.show()

# Write as Delta
df.write.format("delta").mode("overwrite").save("/workspace/data/delta/people")

# Read back
delta_df = spark.read.format("delta").load("/workspace/data/delta/people")
delta_df.show()

spark.stop()
