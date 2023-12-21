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

sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

# Perform k-NN regression and cross-validation
best_k = None
best_score = float('inf')

#size_of_the_training_set = len(X_train)*0.8

size_of_the_training_set = 323
print(f"Size of the training set: {size_of_the_training_set}")

# Lists to store errors
cross_val_errors = []
training_errors = []



for k in range(1, size_of_the_training_set + 1):
    knn = KNeighborsRegressor(n_neighbors=k)
    
    # Cross-validation
    mean_score = -cross_val_score(knn, X_train, y_train, cv=5, scoring='neg_mean_squared_error').mean()
    cross_val_errors.append(mean_score)

    
    # Training error
    knn.fit(X_train, y_train)
    y_train_pred = knn.predict(X_train)
    train_error = mean_squared_error(y_train, y_train_pred)
    training_errors.append(train_error)

    if mean_score < best_score:
        best_score = mean_score
        best_k = k

    print(f"\rProgress: {k}/{size_of_the_training_set}", end='')


# Train the best k-NN model on the entire training set
best_knn = KNeighborsRegressor(n_neighbors=best_k)
best_knn.fit(X_train, y_train)

# Evaluate the best model on the test set
y_pred = best_knn.predict(X_test)
mse = mean_squared_error(y_test, y_pred)
print("")
print(f"\nBest k: {best_k}")
print(f"Mean Squared Error on Test Set: {mse}")
print("")

# Print cross-validation and training errors for all k-NN models versus k
for k, cv_error, train_error in zip(range(1, size_of_the_training_set + 1), cross_val_errors, training_errors):
    print(f"k: {k}, Cross-Validation Error: {cv_error:.2f}, Training Error: {train_error:.2f}")

# Plot cross-validation and training errors
plt.figure(figsize=(10, 6))
plt.plot(range(1, size_of_the_training_set + 1), cross_val_errors, label='Cross-Validation Error')
plt.plot(range(1, size_of_the_training_set + 1), training_errors, label='Training Error')
plt.xlabel('k (Number of Neighbors)')
plt.ylabel('Mean Squared Error')
plt.title('Cross-Validation and Training Errors vs. k')
plt.legend()
plt.grid(True)
plt.show()

