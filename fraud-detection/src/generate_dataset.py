import pandas as pd
import numpy as np

np.random.seed(42)
N = 50000

# Probabilities normalised to sum exactly to 1.0
hour_p = [
    0.020161, 0.015121, 0.012097, 0.010081, 0.010081, 0.015121,
    0.030242, 0.050403, 0.060484, 0.060484, 0.060484, 0.060484,
    0.060484, 0.060484, 0.060484, 0.055444, 0.055444, 0.055444,
    0.050403, 0.050403, 0.045363, 0.040323, 0.035282, 0.025202
]
# Force exact sum of 1 by adjusting last element
hour_p[-1] = round(1.0 - sum(hour_p[:-1]), 6)

hours = np.random.choice(range(24), N, p=hour_p)

countries = ['UK','UK','UK','UK','Spain','Spain','Spain',
             'US','US','Germany','France','Nigeria','Romania','Unknown']
country   = np.random.choice(countries, N)
channels  = np.random.choice(['online','pos','atm','mobile'], N, p=[0.45,0.30,0.15,0.10])

amount = np.where(
    np.random.random(N) < 0.05,
    np.random.exponential(2000, N),
    np.random.exponential(120, N)
)
amount = np.clip(amount, 0.5, 25000).round(2)

velocity  = np.random.poisson(2, N)
days_cust = np.clip(np.random.exponential(500, N).astype(int), 1, 3000)

# Fraud probability with realistic risk signals
fp = np.full(N, 0.008)
fp[(hours >= 23) | (hours <= 2)] *= 4.5
fp[np.isin(country, ['Nigeria', 'Romania', 'Unknown'])] *= 6
fp[channels == 'online'] *= 2.5
fp[amount > 1500]   *= 3
fp[velocity > 5]    *= 3.5
fp[days_cust < 30]  *= 4
fp = np.clip(fp, 0, 0.95)

is_fraud = (np.random.random(N) < fp).astype(int)

df = pd.DataFrame({
    'transaction_id':        [f'TXN{i:07d}' for i in range(N)],
    'amount':                amount,
    'hour':                  hours,
    'country':               country,
    'channel':               channels,
    'transactions_last_24h': velocity,
    'days_as_customer':      days_cust,
    'is_fraud':              is_fraud
})

# Inject realistic nulls
df.loc[np.random.choice(N, 800, replace=False), 'country'] = None
df.loc[np.random.choice(N, 300, replace=False), 'amount']  = None

df.to_csv('data/raw/transactions.csv', index=False)
print(f"Saved {len(df):,} rows | Fraud rate: {is_fraud.mean()*100:.2f}%")