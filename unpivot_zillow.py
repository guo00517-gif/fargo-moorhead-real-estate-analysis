import pandas as pd

df = pd.read_csv('C:/Github/fargo-moorhead-real-estate-analysis/data/raw/zillow_zhvi_fm_zip.csv', low_memory=False)

id_cols = ['RegionID', 'SizeRank', 'RegionName', 'RegionType', 'StateName', 'State', 'City', 'Metro', 'CountyName']

df_melted = df.melt(id_vars=id_cols, var_name='period_date', value_name='home_value')

df_melted.to_csv('C:/Github/fargo-moorhead-real-estate-analysis/data/raw/zillow_zhvi_fm_zip_long.csv', index=False)

print('Done:', len(df_melted), 'rows')
print('Sample dates:', df_melted['period_date'].unique()[:5])
