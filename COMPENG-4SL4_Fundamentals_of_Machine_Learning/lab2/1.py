
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt  # Import Matplotlib for plotting
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.neighbors import KNeighborsRegressor
from sklearn.metrics import mean_squared_error


# Fetch the Boston housing dataset from the original source
data_url = "http://lib.stat.cmu.edu/datasets/boston"
raw_df = pd.read_csv(data_url, sep="\s+", skiprows=22, header=None)
data = np.hstack([raw_df.values[::2, :], raw_df.values[1::2, :2]])
target = raw_df.values[1::2, 2]

# Split the data into a training set and a test set (80% - 20% split)
X_train, X_test, y_train, y_test = train_test_split(data, target, test_size=0.2, random_state=8135)

# Perform k-NN regression and cross-validation
best_k = None
best_score = float('inf')

ind = len(X_train)  # Calculate the length of the training set

for k in range(1, ind):
    knn = KNeighborsRegressor(n_neighbors=k)
    scores = -cross_val_score(knn, X_train, y_train, cv=5, scoring='neg_mean_squared_error')
    mean_score = np.mean(scores)
    
    if mean_score < best_score:
        best_score = mean_score
        best_k = k

# Train the best k-NN model on the entire training set
best_knn = KNeighborsRegressor(n_neighbors=best_k)
best_knn.fit(X_train, y_train)

# Evaluate the best model on the test set
y_pred = best_knn.predict(X_test)
mse = mean_squared_error(y_test, y_pred)
print(f"Best k: {best_k}")
print(f"Mean Squared Error on Test Set: {mse}")
