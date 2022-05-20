'''
    Начисления абоненту
'''
from ipaddress import summarize_address_range
from numpy import empty
import pandas as pd
df=pd.read_csv('абоненты.csv', sep=';', encoding="utf-8")
tariff=1.52
list=[]
#обход списка с разделение по типу облаты
for index, row in df.iterrows():
    if ( row['Тип начисления'] ) == 1: list.append( 301.26 )    
    else: 
        sum=round(((row['Текущее'] - row['Предыдущее']) * tariff),2)
        list.append(sum)
#внесение новых элементов в список
df.loc[:,'Начислено']= list
list.clear()
df.to_csv('Начисления_абоненты.csv', encoding="utf-8-sig", index=False, sep=';')

'''
    Начисление дома
'''

df2=df.iloc[0:0]

'''
1) совершается обход по строкам
2) создается выборка по улице и дому
3) сумма начислений вносится в список
4) первая строка выборки конкатенируется с собой из предыдущего шага
5) из выборки удаляются все элементы, которые относились к данной
'''
for index1, row1 in df.iterrows():
    df_filtered = df.loc[(df['Улица'] == row1['Улица']) & (df['№ дома'] == row1['№ дома']) ]  
    if df_filtered.empty: continue  
    to_list_num=df_filtered['Начислено'].sum()    
    list.append(round(to_list_num,2))
    df2= pd.concat([df2, df_filtered.iloc[[0]]], ignore_index=True)
    df.drop(df[(df['Улица'] == row1['Улица']) & (df['№ дома'] == row1['№ дома'])].index, inplace=True)

#форматирование датафрейма под ТЗ
df2.loc[:,'Начислено'] = list
df2.loc[:,'№ строки'] = df2.index+1
df2 = df2.drop(columns=['Фамилия', '№ Квартиры', 'Тип начисления', 'Предыдущее', 'Текущее']) 
#сохранение в файл
df2.to_csv('Начисления_дома.csv', encoding="utf-8-sig", index=False, sep=';')