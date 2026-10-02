# project_01_pg_basic_report.py
import psycopg2
import pandas as pd

# ========== 1. 数据库连接信息（改成你本地PG账号密码）==========
conn = psycopg2.connect(
    host="localhost",
    port="5432",
    dbname="sql_learn2",
    user="postgres",
    password="0508",
    options="-c client_encoding=utf8"
)

# ========== 2. 从PG读取pop_tbl表 ==========
sql = """
SELECT * FROM poptbl2;
"""
df = pd.read_sql(sql, conn)

# ========== 3. 基础探查与描述统计 ==========
print("数据集前5行：")
print(df.head())

print("\n基础统计信息：")
print(df.describe())

# ========== 4. 分组统计：按地区district分组，人口总和 ==========
df["district"] = df["pref_name"].apply(
    lambda x: "四国" if x in ["德岛","香川","爱媛","高知"]
              else "九州" if x in ["福冈","佐贺","长崎"]
              else "其他"
)
group_result = df.groupby("district")["population"].sum()
print("\n按地区汇总人口：")
print(group_result)

# ========== 5. 结果导出为CSV报表 ==========
group_result.to_csv("report_pop.csv", encoding="utf-8-sig")

# 关闭连接
conn.close()
print("\n任务完成，已生成 report_pop.csv")
