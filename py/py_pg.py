import psycopg2
from psycopg2 import OperationalError,ProgrammingError
import pandas as pd
import matplotlib.pyplot as plt

#
def main():
    conn = None
    try:

        #PG信息设置
        pg_config={
        "host":"127.0.0.1",
        "port":5432,
        "database":"sql_learn2",
        "user":"postgres",
        "password":"0508"
        }

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

        #=======绘图：设置中文，一次性写一次======
        plt.rcParams["font.sans-serif"]=["Microsoft YaHei"]#微软雅黑
        plt.rcParams["axes.unicode_minus"]=False #解决负号显示乱码

        #图1：原有直方图（人口分布）
        plt.figure(figsize=(8,4))
        df_clean['population'].hist(bins=10)
        plt.title("人口分布直方图")
        plt.xlabel("人口")
        plt.ylabel("频次")
        plt.tight_layout()
        plt.show()

        #图2：新增柱状图：各地区人口对比
        plt.figure(figsize=(10,4))
        df_clean.plot(kind="bar",x="name",y="population",ax=plt.gca())
        plt.title("各地区人口柱状图")
        plt.xlabel("地区名称")
        plt.ylabel("人口数量")
        plt.tight_layout()#自动调整画布，防止文字重叠
        plt.show()

        #图3：新增箱线图：识别人口异常值
        plt.figure(figsize=(6,4))
        df_clean.boxplot(column="population")
        plt.title("人口箱线图（查看异常值）")
        plt.ylabel("人口")
        plt.tight_layout()
        plt.show()

        #5.导出csv报表
        df_clean.to_csv(
            "pop_tbl_report.csv",
            index=False,
            encoding="utf-8-sig"
        )
        print("\n 报表已保存 pop_tbl_report.csv")

        #6. 简单可视化（示例，根据你的表字段自行修改）
        df_clean['population'].hist()
        plt.title("人口分布直方图")
        plt.show()

    except OperationalError as err:
        #OperationalError:连接层面错误，端口、账号密码、数据库服务没启动
        print(f"\n 数据库连接失败！检查地址、账号密码：{err}")
    except  ProgrammingError as err:
        #ProgrammingError:SQL语法错误、表不存在、字段不存在
        print(f"\n SQL错误，表或字段不存在：{err}")
    except Exception as err:
        #兜底：其他所有未知错误
        print(f"\n 其他未知错误：{err}")
    finally:
        #无论是否报错，最后都会执行，关闭连接
        if conn is not None:
            #7. 关闭通道
            conn.close()
            print("\n 数据库连接关闭")


if __name__=="__main__":
    main()
