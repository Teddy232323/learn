import psycopg2
import pandas as pd
import matplotlib.pyplot as plt
#PG信息设置
pg_config={
    "host":"127.0.0.1",
    "port":5432,
    "database":"sql_learn2",
    "user":"postgres",
    "password":"0508"
}
#
def main():
    #1.连接postgreSQL
    conn=psycopg2.connect(**pg_config)
    print("数据库连接成功")
   
    #2.读取pop_tbl全部数据
    sql="""
    select * from public.poptbl2;
    """
    df=pd.read_sql(sql,conn)
    print(f"\n 读取数据： 一共{df.shape[0]} 行，{df.shape[1]} 列")
    
    #3.基础数据探查
    print("\n==== 前5行数据 ====")
    print(df.head())

    print("\n==== 字段类型 ====")
    print(df.dtypes)

    print("\n====缺失值统计 ====")
    print(df.isnull().sum())

    print("\n==== 数值字段描述性统计 ====")
    print(df.describe())

    #4.简单清洗示例：删除全空行
    df_clean=df.dropna(how="all")
    print(f"\n清洗后数据量：{df_clean.shape[0]} 行")

    #5.导出csv报表
    df_clean.to_csv("pop_tbl_report.csv",index=False,encoding="utf-8-sig")
    print("\n 报表已保存 pop_tbl_report.csv")

    #6. 简单可视化（示例，根据你的表字段自行修改）
    df_clean['population'].hist()
    plt.title("population")
    plt.show()

    conn.close()
    print("\n 数据库连接关闭")


if __name__=="__main__":
    main()
