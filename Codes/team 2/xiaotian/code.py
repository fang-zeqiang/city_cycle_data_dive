import networkx as nx
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import os
import warnings
warnings.filterwarnings('ignore')


def find_pos(row):
    if len(df_n[df_n['NAME'] == row]) != 0:
        return (df_n[df_n['NAME'] == row].x.values[0],df_n[df_n['NAME'] == row].y.values[0])
    elif len(df_new[df_new['station'] == row]) != 0:
        return df_new[df_new['station'] == row].pos.values[0]
    else:
        return '404'

g_shp=nx.read_shp('./data/underground/underground.shp',geom_attrs=False)

# node -> tube stations: x, y, name
df_n = pd.read_csv("./data/Stations 20180921.csv")
df_n = df_n[['NAME','x','y']]

df = nx.to_pandas_edgelist(g_shp)
s_1 = df[['source','station_1_']].rename(columns = {'source':'pos','station_1_':'station'})
s_2 = df[['target','station_2_']].rename(columns = {'target':'pos','station_2_':'station'})
df_new = pd.concat([s_1,s_2]).drop_duplicates()
df_new = df_new[~df_new.station.isin(df_n['NAME'])]

# Create Graph G from edge -> NumBAT.Link Load.Total
df_e = pd.read_excel(open('./data/NBT19MTT_Outputs.xlsx', 'rb'),sheet_name='Link_Loads',header=2) 
df_e = df_e[['From Station','To Station','Total']]

df_e['F_pos'] = df_e['From Station'].apply(find_pos)
df_e['T_pos'] = df_e['To Station'].apply(find_pos)

df_e = df_e[df_e['F_pos'] != '404']
df_e = df_e[df_e['T_pos'] != '404']

# Build the Graph
G = nx.from_pandas_edgelist(df_e, 'From Station', 'To Station',['Total'])
G = G.to_undirected()

nx.draw(G,node_color='b',node_size=8,edge_color='gray',width=0.4)

# pos of nodes pair
pos = {i:find_pos(i) for i, node in G.nodes(data=True)}

values=[(i[2]['Total']) for i in G.edges(data=True)]
color=[(i[2]['Total']/max(values)) for i in G.edges(data=True)]
width=[(i[2]['Total']/max(values)*10) for i in G.edges(data=True)]


# Plot graph
fig, ax = plt.subplots(figsize=(12,12))

nx.draw_networkx_nodes(G,pos = pos,node_color= 'black',node_size= 1)
nx.draw_networkx_edges(G,pos,edge_color=color, width=width)

plt.title("London tube flow",fontsize=15)
plt.axis("off")
fig.savefig('./img/map.png')