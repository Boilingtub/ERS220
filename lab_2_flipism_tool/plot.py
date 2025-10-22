import matplotlib.pyplot as plt
# import matplotlib.ticker as ticker
# import numpy as np 
import pandas as pd

def plot_csv(path,name):
    plt.figure(figsize=(20, 20))
    data = pd.read_csv(path)
    print(data)
    plt.plot(data['t / s'],data['CH1 / V'])
    plt.xlabel("time")
    plt.ylabel("V")
    plt.title("Voltage-Time plot of on-debounced button press")
    plt.savefig(name)


plot_csv('Scope/hantek.csv',"hantek_non_debounce.pdf")



