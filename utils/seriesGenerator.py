import numpy as np
import matplotlib.pyplot as plt
from random import randrange

class SeriesGenerator:

    def __init__(self, period=24, phase=0, baseline=100, amplitude=40, slope=0.005, noise_level=3, seed=51):
        self.baseline = baseline
        self.amplitude = amplitude
        self.slope = slope
        self.noise_level = noise_level
        self.seed = seed
        self.phase = phase
        self.period = period
        self.time = np.arange(10000000, dtype="float32")
        self.series = self.trend()

    def randomInit(self):
        self.phase = randrange(0, 720, 90)
        self.amplitude = randrange(30, 50)
        self.slope = randrange(45, 55)/10000
        self.noise_level = randrange(3, 6)

    def plot_series(self):
        plt.plot(self.time, self.series, "-")
        plt.xlabel("Time")
        plt.ylabel("Value")
        plt.grid(False)

    def trend(self):
        return self.slope * self.time

    def seasonal_pattern(self, season_time):
        """Just an arbitrary pattern, you can change it if you wish"""
        return np.where(season_time < 0.1,
                        np.cos(season_time * 6 * np.pi),
                        2 / np.exp(9 * season_time))

    def seasonality(self):
        """Repeats the same pattern at each period"""
        season_time = ((self.time + self.phase) % self.period) / self.period
        return self.amplitude * self.seasonal_pattern(season_time)

    def noise(self):
        rnd = np.random.RandomState(self.seed)
        return rnd.randn(len(self.time)) * self.noise_level


    def generate(self):
        self.series = self.baseline + self.trend() + self.seasonality()
        self.series += self.noise()
        return self.series 

if __name__ == '__main__':
    print('--series--')
    SG1 = SeriesGenerator()
    SG1.randomInit()
    SG1.generate()
    SG1.plot_series()
    SG2 = SeriesGenerator()
    SG2.randomInit()
    SG2.generate()
    SG2.plot_series()
    SG3 = SeriesGenerator()
    SG3.randomInit()
    SG3.generate()
    SG3.plot_series()
    plt.show()