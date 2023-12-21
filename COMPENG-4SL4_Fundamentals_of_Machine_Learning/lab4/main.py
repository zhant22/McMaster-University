
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.utils import shuffle
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
import csv


dataset = pd.read_table('data_banknote_authentication.txt', sep = ",", header=None)
X = dataset.iloc[:, :-1].values
t = dataset.iloc[:, -1].values

#%% The dataset is split into training, validation, and test sets with a ratio of 60% training, 20% validation, and 20% test data. 
X_train, X_test, t_train, t_test = train_test_split(X, t, test_size=0.2, random_state=8135)
X_train, X_valid, t_train, t_valid = train_test_split(X_train, t_train, test_size=0.25, random_state=8135)

sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.fit_transform(X_test)
X_valid = sc.transform(X_valid)


#%%Define the activation function here I am using Relu for the hidden layer 
def ReLU(x):  #using Relu as the activation function 
    return x * (x > 0)

def d_ReLU(x):  # derivative of Relu 
    return 1. * (x > 0)


#%% Define random weight initialization functions
def standard_normal(matrix):    # mean=0, stdev=1
    return np.random.standard_normal(size=matrix.shape)

def random_integers(matrix):    # random 1 -1
    opt = np.random.choice([0,1],size=matrix.shape)
    return np.where(opt==0, -1, opt)

def pattern(matrix):    # pattern matrix of 1 -1 1 -1 1 -1
    for m in range (matrix.shape[0]):

        if np.matrix.ndim != 1:
            for n in range (matrix.shape[1]):
                matrix[m][n] = (m+n)%2
        else:
            matrix[m] = m%2

    return np.where(matrix==0, -1, matrix)

def random(matrix):
    rng = np.random.default_rng()
    for element in matrix:
        element = rng.random()
    return element

#%% the loss function as mentioned in the lab is cross_entropy
def cross_entropy(y,t):
    eps = np.finfo(float).eps
    cross_entropy = -np.sum(t * np.log(y + eps))/len(t)
    return cross_entropy

def misclassification_error(y,t):
    match = 0
    for i in range (y.shape[0]):
        if y[i] == t[i]:
            match = match+1
            
    return match/y.shape[0]

#%%
# function trains a neural network with specified hyperparameters and returns the best output and its corresponding loss value.
def NNClassifier(X, t, hidden_layer_sizes, initialize, epochs, learning_rate):
    #print(hidden_layer_sizes)
    layer_1_size = hidden_layer_sizes[0]  # extracted from the hidden_layer_sizes tuple.
    layer_2_size = hidden_layer_sizes[1]
    
    output = np.zeros(len(X)) # current output and store the best output
    output_best = np.zeros(len(X))

    # initialize the matrix for best weights
    w_1_best = np.ones((layer_1_size, 5))
    w_2_best = np.ones((layer_2_size, layer_1_size+1))
    w_3_best = np.ones((1, layer_2_size+1))

    # initialize weights for training
    w_1 = initialize(w_1_best)
    w_2 = initialize(w_2_best)
    w_3 = initialize(w_3_best)

    

    j=0
    loss = np.ones(epochs)*np.inf

    while(j<epochs):

        X,t = shuffle(X,t)      # shuffle the set

        for i in range (len(X)):    # loop through all examples 
            input = X[i]

            # forward pass with Relu 
            z_1 = np.dot(w_1, np.insert(input,0,1).T)
            h_1 = ReLU(z_1)

            z_2 = np.dot(w_2, np.insert(h_1,0,1).T)
            h_2 = ReLU(z_2)

            z_3 = np.dot(w_3, np.insert(h_2,0,1).T)
            out_y = np.power((1 + np.exp(-z_3)), -1)
            
            if out_y>=0.5:
                output[i] = 1
            else:
                output[i] = 0
                
            #output[i] = np.rint( np.power((1 + np.exp(-z_3)), -1) )

            # backward pass
            dz_3 = -output[i]+ np.power((1 + np.exp(-z_3)), -1)
            gw_3 = dz_3*np.insert(h_2.T,0,1)
            gz_2 = np.multiply(d_ReLU(z_2),np.dot( np.delete(w_3,0,1).T, dz_3))

            gw_2 = gz_2.reshape(layer_2_size,1)*np.insert(h_1.T,0,1)
            gz_1 = np.multiply(d_ReLU(z_1),np.dot( np.delete(w_2,0,1).T, gz_2))

            gw_1 = gz_1.reshape(layer_1_size,1)*np.insert(input.T,0,1)

            # update w
            w_3 = np.subtract(w_3, np.dot(learning_rate,gw_3))
            w_2 = np.subtract(w_2, np.dot(learning_rate,gw_2))
            w_1 = np.subtract(w_1, np.dot(learning_rate,gw_1))

        # calculate loss of these particular group of weights
        loss[j] = cross_entropy(output,t)   

        if np.argmin(loss)==j:  # if the current result is minimum, update best weights
            w_1_best = w_1
            w_2_best = w_2
            w_3_best = w_3
            output_best = output

        j=j+1


    return output_best, np.min(loss)


# Define a range of values for n1 and n2 such that n1 + n2 <= 8
n_values = range(1, 8)  # You can adjust this range as needed

best_n1 = None
best_n2 = None
best_mis_rate = float('inf')
best_entropy_loss = float('inf')  # Track the best entropy_loss

entropy_loss = []  # To store entropy_loss for each n1
n1_values = []  # To store n1 values
mis_rate = []

best_mis_rate = float('inf')  # Initialize best misclassification rate to positive infinity
best_entropy_loss = float('inf')  # Initialize best entropy loss to positive infinity
best_n1 = None  # Initialize best n1
best_n2 = None  # Initialize best n2
best_weights = None  # Initialize best weights

print(f"| {'n1':^10} | {'n2':^10} | {'Misclassification Rate':^20} |{'entropy_loss':^15} |")
print(f"|{'-'*12}|{'-'*12}|{'-'*24}|{'-'*15}|")

for n1 in n_values:
    for n2 in range(1, 8 - n1 + 1):
        loss = []

        early_stopping_patience = 5
        best_misclassification_error = float('inf')  # Initialize the best misclassification error for this (n1, n2) pair

        for i in range(3):
            o, l = NNClassifier(X_train, t_train, hidden_layer_sizes=(n1, n2), initialize=random_integers, epochs=50, learning_rate=0.5)

            # Here, you should update the loss list with the loss values
            if l > 0.1:
                loss.append(l)

            X_train_sub, X_valid_sub, t_train_sub, t_valid_sub = train_test_split(X_train, t_train, test_size=0.2, random_state=8135)

            best_epoch = 0

            for epoch in range(50):
                o_valid, _ = NNClassifier(X_valid_sub, t_valid_sub, hidden_layer_sizes=(n1, n2), initialize=random_integers, epochs=1, learning_rate=0.5)
                mis_error = misclassification_error(o_valid, t_valid_sub)

                if mis_error < best_misclassification_error:
                    best_misclassification_error = mis_error
                    best_epoch = epoch

                if epoch - best_epoch >= early_stopping_patience:
                    break

            if best_misclassification_error < best_mis_rate:
                best_mis_rate = best_misclassification_error
                best_n1 = n1
                best_n2 = n2
                best_weights = o

        # After the inner loop for i, calculate the mean loss for this (n1, n2) pair
        entropy_loss_mean = np.mean(loss)
        entropy_loss.append(entropy_loss_mean)
        n1_values.append(n1)  # Store n1 value for this iteration

        # Track the best entropy_loss and its corresponding n1 and n2 values
        if entropy_loss_mean < best_entropy_loss:
            best_entropy_loss = entropy_loss_mean

        # Print the values in the table for each (n1, n2) pair
        print(f"| {n1:^10} | {n2:^10} | {best_misclassification_error:^20.4f} |{entropy_loss_mean:^15.4f}")


# After both loops, you can print the overall best values and the best weights
print("Best n1:", best_n1)
print("Best n2:", best_n2)
print("Best Misclassification Rate:", best_mis_rate)
print("Best Entropy Loss:", best_entropy_loss)
#print("Best Weights:", best_weights)






