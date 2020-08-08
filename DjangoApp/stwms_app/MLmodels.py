import pandas as pd
from matplotlib import pyplot as plt
import numpy as np
from fbprophet import Prophet


class TimeSeriesModel:

    def __init__(self, file, item_index, split_percent):
        self.df = pd.read_csv(file)
        self.item_index = item_index
        self.split_percent = split_percent
        self.error_log = {}

    def predictor(self):
        raw_df = self.df
        raw_df.Description = pd.Categorical(raw_df.Description)
        raw_df['item'] = raw_df.Description.cat.codes
        raw_df['Date'] = pd.to_datetime(raw_df['Date'])
        mod_df = raw_df.drop(['Description', 'Time', 'InvoiceNo'], axis=1)
        mod_df.rename(columns={'Date': 'ds', 'Quantity': 'y'}, inplace=True)
        pos_df = mod_df[mod_df['y'] > 0]
        pos_df = pos_df[pos_df['item'] == self.item_index]
        final_df = pos_df.drop(['item'], axis=1)
        self.df = final_df.sort_values(by="ds")

    def plot_df(self):
        plt.figure(figsize=(17, 8))
        plt.plot(self.df['ds'], self.df['y'])
        plt.xlabel('Date')
        plt.ylabel('Quantity')
        plt.show()

    def split(self):
        prediction_size = int(self.split_percent * len(self.df))
        train_df = self.df[:-prediction_size]
        test_df = self.df[-prediction_size:]
        return train_df, test_df, prediction_size

    def fb_prophet(self, plot=False):
        self.predictor()
        train_df, test_df, prediction_size = self.split()

        fbP_model = Prophet()
        fbP_model.fit(train_df)
        future = fbP_model.make_future_dataframe(periods=prediction_size)
        forecast = fbP_model.predict(future)

        y_hat = forecast['yhat'][-prediction_size:]
        y = test_df['y']
        y_hat.reset_index(drop=True, inplace=True)
        y.reset_index(drop=True, inplace=True)

        self.error_log['se'] = np.square(y_hat - y)
        self.error_log['mse'] = np.mean(self.error_log['se'])
        self.error_log['rmse'] = np.sqrt(self.error_log['mse'])

        if plot:
            plt.plot(forecast['ds'], forecast['yhat'])
            plt.plot(train_df['ds'], train_df['y'], color='red')
            plt.show()


model = TimeSeriesModel('datasets/Online Retail.csv', 15, 0.1)
model.fb_prophet(plot=True)