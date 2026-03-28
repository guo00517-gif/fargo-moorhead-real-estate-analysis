import pandas as pd

df = pd.read_csv('C:/Github/fargo-moorhead-real-estate-analysis/data/raw/zillow_zhvi_fm_zip.csv')

id_cols = list(df.columns[:9])

df_melted = df.melt(id_vars=id_cols, var_name='period_date', value_name='home_value')

df_melted.to_csv('C:/Github/fargo-moorhead-real-estate-analysis/data/raw/zillow_zhvi_fm_zip_long.csv', index=False)

print('Done:', len(df_melted), 'rows')
