import pandas as pd
from matplotlib import pyplot as plt
from fbprophet import Prophet
from .models import TransactionHistory


def post_data_clean(temp_df, periodicity='D'):
    if periodicity == 'H':
        temp_df['ds'] = pd.to_datetime(temp_df['ds']).dt.strftime('%-I %p %A %d')
    elif periodicity == 'M':
        temp_df['ds'] = pd.to_datetime(temp_df['ds']).dt.strftime('%b %Y')
    else:
        temp_df['ds'] = pd.to_datetime(temp_df['ds']).dt.strftime('%d %b')
    temp_df = temp_df.drop([
        'additive_terms', 'additive_terms_lower', 'additive_terms_upper',
        'multiplicative_terms', 'multiplicative_terms_lower', 'multiplicative_terms_upper'
    ], axis=1)
    labels = temp_df.ds.values
    temp_df = temp_df.round(2)
    indexList = list(temp_df.columns)
    ele = indexList.pop(-1)
    indexList.insert(1, ele)
    temp_df = temp_df[indexList]
    return [labels, temp_df]


class TimeSeriesModel:

    def __init__(self, raw_material_id, store_id, future_period):
        self.df = ''
        self.prediction_size = future_period
        self.error_log = {}
        self.get_data(raw_material_id, store_id)
        self.pre_data_clean()

    def get_data(self, raw_material_id, store_id):
        self.df = TransactionHistory.objects.filter(rawMaterial_id_id=raw_material_id, storeId_id=store_id) \
            .to_dataframe()

    def pre_data_clean(self, with_time=False):
        raw_df = self.df
        if with_time:
            raw_df['dateTime'] = pd.to_datetime(df['dateTime']).dt.tz_convert('Asia/Kolkata').dt.tz_localize(None)
        else:
            raw_df['dateTime'] = pd.to_datetime(raw_df['dateTime']).dt.date
        final_df = raw_df.drop(['transaction_id', 'rawMaterial_id', 'storeId'], axis=1)
        final_df.rename(columns={'dateTime': 'ds', 'units': 'y'}, inplace=True)
        self.df = final_df.sort_values(by="ds")

    def plot_df(self):
        plt.figure(figsize=(17, 8))
        plt.plot(self.df['ds'], self.df['y'])
        plt.xlabel('Date')
        plt.ylabel('Quantity')
        plt.show()

    def fb_prophet(self, plot=False):
        fbP_model = Prophet(weekly_seasonality=True, daily_seasonality=True, yearly_seasonality=True)
        fbP_model.fit(self.df)

        # Day Forecast
        futureD = fbP_model.make_future_dataframe(periods=self.prediction_size, freq="D")
        forecast_day = fbP_model.predict(futureD)[-self.prediction_size:]

        # Hourly Forecast
        futureH = fbP_model.make_future_dataframe(periods=self.prediction_size * 12, freq='H')
        forecast_hour = fbP_model.predict(futureH)[-self.prediction_size * 12:]

        # Weekly Forecast
        futureW = fbP_model.make_future_dataframe(periods=self.prediction_size, freq='W')
        forecast_week = fbP_model.predict(futureW)[-self.prediction_size:]

        # Monthly Forecast
        futureM = fbP_model.make_future_dataframe(periods=self.prediction_size, freq='M')
        forecast_month = fbP_model.predict(futureM)[-self.prediction_size:]

        fbP_model.plot_components(forecast_day).savefig('static/files/forecast.png')
        if plot:
            plt.show()

        forecast_day = post_data_clean(forecast_day)
        forecast_hour = post_data_clean(forecast_hour, periodicity='H')
        forecast_week = post_data_clean(forecast_week)
        forecast_month = post_data_clean(forecast_month, periodicity='M')

        return forecast_day, forecast_hour, forecast_week, forecast_month
