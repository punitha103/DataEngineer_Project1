#sales transformation
from pyspark.sql import SparkSession
#import functions
from pyspark.sql.functions import *
from pyspark.sql.types import *
spark=SparkSession.builder.appName("SalesData").getOrCreate()
schema = StructType([
    StructField("Product_ID", IntegerType(), True),
    StructField("Sale_Date", StringType(), True),
    StructField("Sales_Rep", StringType(), True),
    StructField("Region", StringType(), True),
    StructField("Sales_Amount", DoubleType(), True),
    StructField("Quantity_Sold", IntegerType(), True),
    StructField("Product_Category", StringType(), True),
    StructField("Unit_Cost", DoubleType(), True),
    StructField("Unit_Price", DoubleType(), True),
    StructField("Customer_Type", StringType(), True),
    StructField("Discount", DoubleType(), True),
    StructField("Payment_Method", StringType(), True),
    StructField("Sales_Channel", StringType(), True),
    StructField("Region_and_Sales_Rep", StringType(), True)
])
df=spark.read.option('header',True).schema(schema).csv(r"C:\Users\acer\OneDrive\Documents\data_folder\sales_datas.csv")


print("Sales Data:")
df.show(20)


#date format
print("Date Format:")
df=df.withColumn(
    "Sale_Date",
    to_date("Sale_Date", "M/d/yyyy"))
df.show()

#Remove columns
print("Remove Region_and_Sales_Rep:")
drop_col=df.drop("Region_and_Sales_Rep")
drop_col.show()

#filter column
print("Display sal_amount >=4500 & category = furniture:")
furn_sal=df.filter((col("Sales_Amount")>=4500.00) & (col("Product_Category")=="Furniture"))
furn_sal.show()

#total sales amount
print("Total sales Amount:")
tot_sal=df.groupBy("Product_Category").sum("Sales_Amount")
tot_sal.show()

#total count
print("Total Count:")
count_sal=df.groupBy("Product_Category").count()
count_sal.show()

#top 20 sales category
print("Top 20 sales category:")
from pyspark.sql.window import *
window_spec=Window.partitionBy("Product_Category").orderBy(col("Sales_Amount").desc())
top=df.withColumn("Top 20 sales",
              dense_rank().over(window_spec))
top.show()


print("Discount Check:")
df = df.withColumn("Discount_Type",
             when(col("Discount") > 0.15, "High Discount")
                .otherwise("Normal Discount"))
df.show()









