
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.utils import shuffle
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split

dataset = pd.read_table('data_banknote_authentication.txt', sep=",", header=None)
X = dataset.iloc[:, :-1].values
t = dataset.iloc[:, -1].values

# The dataset is split into training, validation, and test sets with a ratio of 60% training, 20% validation, and 20% test data.
X_train, X_test, t_train, t_test = train_test_split(X, t, test_size=0.2, random_state=8135)
X_train, X_valid, t_train, t_valid = train_test_split(X_train, t_train, test_size=0.25, random_state=8135)

sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.fit_transform(X_test)
X_valid = sc.transform(X_valid)

# Define the activation function (ReLU) and its derivative
def ReLU(x):
    return x * (x > 0)

def d_ReLU(x):
    return 1. * (x > 0)

# Define random weight initialization functions
def standard_normal(matrix):
    return np.random.standard_normal(size=matrix.shape)

def random_integers(matrix):
    opt = np.random.choice([0, 1], size=matrix.shape)
    return np.where(opt == 0, -1, opt)

def pattern(matrix):
    for m in range(matrix.shape[0]):
        if np.matrix.ndim != 1:
            for n in range(matrix.shape[1]):
                matrix[m][n] = (m + n) % 2
        else:
            matrix[m] = m % 2
    return np.where(matrix == 0, -1, matrix)

def random(matrix):
    rng = np.random.default_rng()
    for element in matrix:
        element = rng.random()
    return element

# Define the cross-entropy loss function
def cross_entropy(y, t):
    eps = np.finfo(float).eps
    cross_entropy = -np.sum(t * np.log(y + eps)) / len(t)
    return cross_entropy

def misclassification_error(y, t):
    match = 0
    for i in range(y.shape[0]):
        if y[i] == t[i]:
            match = match + 1
    return match / y.shape[0]

# Function to train a neural network with specified hyperparameters and return the best output and its corresponding loss value
def NNClassifier(X, t, hidden_layer_sizes, initialize, epochs, learning_rate):
    layer_1_size = hidden_layer_sizes[0]
    layer_2_size = hidden_layer_sizes[1]

    output = np.zeros(len(X))
    output_best = np.zeros(len(X))

    w_1_best = np.ones((layer_1_size, 5))
    w_2_best = np.ones((layer_2_size, layer_1_size + 1))
    w_3_best = np.ones((1, layer_2_size + 1))

    w_1 = initialize(w_1_best)
    w_2 = initialize(w_2_best)
    w_3 = initialize(w_3_best)

    j = 0
    loss = np.ones(epochs) * np.inf
    entropy_loss = []

    while j < epochs:
        X, t = shuffle(X, t)

        for i in range(len(X)):
            input = X[i]

            z_1 = np.dot(w_1, np.insert(input, 0, 1).T)
            h_1 = ReLU(z_1)

            z_2 = np.dot(w_2, np.insert(h_1, 0, 1).T)
            h_2 = ReLU(z_2)

            z_3 = np.dot(w_3, np.insert(h_2, 0, 1).T)
            out_y = np.power((1 + np.exp(-z_3)), -1)

            if out_y >= 0.5:
                output[i] = 1
            else:
                output[i] = 0

            dz_3 = -output[i] + np.power((1 + np.exp(-z_3)), -1)
            gw_3 = dz_3 * np.insert(h_2.T, 0, 1)
            gz_2 = np.multiply(d_ReLU(z_2), np.dot(np.delete(w_3, 0, 1).T, dz_3))

            gw_2 = gz_2.reshape(layer_2_size, 1) * np.insert(h_1.T, 0, 1)
            gz_1 = np.multiply(d_ReLU(z_1), np.dot(np.delete(w_2, 0, 1).T, gz_2))

            gw_1 = gz_1.reshape(layer_1_size, 1) * np.insert(input.T, 0, 1)

            w_3 = np.subtract(w_3, np.dot(learning_rate, gw_3))
            w_2 = np.subtract(w_2, np.dot(learning_rate, gw_2))
            w_1 = np.subtract(w_1, np.dot(learning_rate, gw_1))

        loss[j] = cross_entropy(output, t)

        if np.argmin(loss) == j:
            w_1_best = w_1
            w_2_best = w_2
            w_3_best = w_3
            output_best = output

        entropy_loss.append(loss[j])
        j = j + 1

    return output_best, np.min(loss), entropy_loss

# Specify the best n1 and n2
best_n1 = 4
best_n2 = 4


loss_Training=[]
loss2_Training=[]
entropy_loss_Training = []
mis_rate_Training = []

loss_valid=[]
loss2_valid=[]
entropy_loss_valid = []
mis_rate_valid = []

loss_test=[]
loss2_test=[]
entropy_loss_test = []
mis_rate_test = []


train_output, l1,loss = NNClassifier(X_train, t_train, hidden_layer_sizes=(best_n1, best_n2), initialize=random_integers, epochs=20, learning_rate=0.0005)

# Calculate misclassification error on the training set
entropy_loss_Training=loss

train_misclassification_error = misclassification_error(train_output, t_train)


#Calculate misclassification error on the validation set

valid_output, l2 ,loss2= NNClassifier(X_valid, t_valid, hidden_layer_sizes=(best_n1, best_n2), initialize=random_integers, epochs=20, learning_rate=0.0005)
entropy_loss_valid = loss2

valid_misclassification_error = misclassification_error(valid_output, t_valid)


# Calculate misclassification error on the test set

test_output, l3 ,loss3 = NNClassifier(X_test, t_test, hidden_layer_sizes=(best_n1, best_n2), initialize=random_integers, epochs=20, learning_rate=0.0005)


entropy_loss_test = loss3

test_misclassification_error = misclassification_error(test_output, t_test)




print("Misclassification Error on Training Set:", train_misclassification_error)
print("Misclassification Error on Validation Set:", valid_misclassification_error)
print("Misclassification Error on Test Set:", test_misclassification_error)

# Plot the learning curve (cross-entropy loss)
plt.figure()
plt.plot(entropy_loss_Training)
plt.xlabel("Epochs")
plt.ylabel("Cross-Entropy Loss")
plt.title("Learning Curve (Training Set)")

plt.figure()
plt.plot(entropy_loss_valid)
plt.xlabel("Epochs")
plt.ylabel("Cross-Entropy Loss")
plt.title("Learning Curve (valid Set)")

plt.figure()
plt.plot(entropy_loss_test)
plt.xlabel("Epochs")
plt.ylabel("Cross-Entropy Loss")
plt.title("Learning Curve (test Set)")



plt.show()