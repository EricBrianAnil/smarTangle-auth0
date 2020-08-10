import pandas as pd
from matplotlib import pyplot as plt
from fbprophet import Prophet
from .models import TransactionHistory


class TimeSeriesModel:

    def __init__(self, raw_material_id, store_id, future_period):
        self.df = ''
        self.prediction_size = future_period
        self.error_log = {}
        self.partForecast = ''
        self.labels = []
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

    def post_data_clean(self):
        self.partForecast['ds'] = pd.to_datetime(self.partForecast['ds']).dt.strftime('%d %b')
        self.partForecast = self.partForecast.drop([
            'additive_terms', 'additive_terms_lower', 'additive_terms_upper',
            'multiplicative_terms', 'multiplicative_terms_lower', 'multiplicative_terms_upper'
        ], axis=1)
        self.labels = self.partForecast.ds.values
        self.partForecast = self.partForecast.round(2)
        indexList = list(self.partForecast.columns)
        ele = indexList.pop(-1)
        indexList.insert(1, ele)
        self.partForecast = self.partForecast[indexList]

    def fb_prophet(self, plot=False):
        fbP_model = Prophet(weekly_seasonality=True, daily_seasonality=True)
        fbP_model.fit(self.df)
        future = fbP_model.make_future_dataframe(periods=self.prediction_size, freq="D", include_history=False)
        forecast = fbP_model.predict(future)

        self.partForecast = forecast[-self.prediction_size:]
        y_hat = forecast['yhat'][-self.prediction_size:]
        y_hat.reset_index(drop=True, inplace=True)

        if plot:
            fbP_model.plot_components(forecast)
            plt.plot(forecast['ds'], forecast['yhat'])
            plt.plot(self.df['ds'], self.df['y'], color='red')
            plt.show()

        self.post_data_clean()
        return self.partForecast, forecast, y_hat, self.labels


if __name__ == '__main__':
    model = TimeSeriesModel('101', 'S1', 7)
    model.fb_prophet(plot=True)
