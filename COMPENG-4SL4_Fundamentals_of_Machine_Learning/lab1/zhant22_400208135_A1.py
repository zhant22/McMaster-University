import numpy as np
import matplotlib.pyplot as plt
plt.rcParams['figure.figsize'] = [10, 8]

x_training_point = np.linspace(0,1,12) #training set between 0 to 1 with 12 evenly unit Construct a training set consisting of only 12 examples
x_validation_point = np.linspace(0,1,120) #validation set between 0 to 1 with 120 evenly unit 

np.random.seed(8135) # student number: 400208135

# where noise is random noise with a Gaussian distribution with 0 mean and variance 0.0625
mean =0
variance = 0.0625
noise_train = np.random.normal(mean, np.sqrt(variance),size=(12,))
noise_valid = np.random.normal(mean, np.sqrt(variance),size=(120,))

t_train = np.sin((4*np.pi*x_training_point)+(np.pi/2)) + noise_train #target for training
t_valid = np.sin((4*np.pi*x_validation_point)+(np.pi/2)) + noise_valid #target for validation

#create a matrix of features with powers of x based on the example numbers. starting with 0 so, the first col is 1 
def create_matrix_for_X(example_numbers, x):
    return np.array(np.array([np.power(x,i) for i in range(example_numbers+1)])).transpose()  #[1, x^1, x^2, x^i ] transpose 

#calculate the error between predicted values and actual values.
def Error_Cal(parameter_W, x, target_value):
    num = target_value.size-1 # find the size of the target(actual) value used to cal mean error value

    predicted_value = create_matrix_for_X(parameter_W.size-1, x) #cal the predicted values by performing a matrix multiplication between the feature matrix 
    squared_error = np.dot(predicted_value,parameter_W)-target_value
 
    return np.dot(squared_error.transpose(),squared_error)/num #return the mean errors 
#    return np.sum(np.square(squared_error)) / num #return the mean errors 

#plot function
def plotFunc(params):#params is parameter containing all regression results
    x = np.linspace(0,1,120)
    ftrue = np.sin((4*np.pi*x)+(np.pi/2))
    predicted_function = []

    for M in range(0,12): # M from 0 to 11
        predicted_function.append(np.dot(params[M],create_matrix_for_X(M,x).transpose())) 
        plt.figure()
        plt.plot(x_training_point, t_train, 'o', color = "green", label = "Training Set")
        plt.plot(x_validation_point, t_valid, '.', color = "orange", label = "Validation Set")
        plt.plot(x, predicted_function[M], color = "red", label = "prediction fM(x) function")
        plt.plot(x, ftrue, color = "blue", label = "curve ftrue(x)")
        plt.title("M = " + str(M), fontsize=30)
        plt.xlabel("x")
        plt.ylabel("t")
        plt.legend(loc='best', bbox_to_anchor=(1, 1))



#plot the training and validation errors versus M.
def plotErrors_vs_M(trainErr, validErr):
    plt.figure()
    plt.plot(trainErr, color = "g", label = "Training Error")
    plt.plot(validErr, color = "m", label = "Validation Error")
    plt.title('training and validation errors versus M', fontsize=30)
    plt.xlabel("regression times (value of M)", fontsize=20)
    plt.ylabel("variance", fontsize=20)
    plt.grid()
    plt.legend(loc='best', bbox_to_anchor=(1, 1))

############################################### doing same thing 
## generate parameters 'w' for polynomial regression with regularization
def generateParams(lamb_da, X, target_value):
    num = target_value.size
    A = np.dot(X.transpose(),X) # calculates the matrix product of the transpose of the feature matrix X and X itself. It essentially computes the covariance matrix of the features.
    B = np.identity(12)*2*lamb_da  #identity matrix, acts as a penalty for large coefficients.
    r = np.linalg.inv(A+B*num/2) # used to find find the coefficients.
    return np.dot(r,np.dot(X.transpose(),t_train))

def lambdaErrorCalc(w, X, target_value, lamb_da):
    num = target_value.size
    r = np.dot(X, w) - target_value # error by computing the squared difference between the predicted values (obtained using w and X) and the actual target values t
    return np.dot(r.transpose(), r)/num + lamb_da*sum(np.power(w,2)) #adds the regularization term to the error by summing the squared values of the parameters weighted by lambda


#plot Training and Validation Errors vs. Lambda
def plotErrors_lambda(lambda_values, training_errors, validation_errors):
    plt.figure()
    plt.semilogx(lambda_values, training_errors, 'o-', color="g", label="Training Error")
    plt.semilogx(lambda_values, validation_errors, 'o-', color="m", label="Validation Error")
    plt.title('Training and Validation Errors vs. Lambda')
    plt.xlabel("Lambda")
    plt.ylabel("Error")
    plt.grid()
    plt.legend(loc='best')

# use this function to plot how lambda impact over / under fitting 
def plotFunc_when_M_11(x_validation_point,x_training_point,t_train,t_valid,param_w1,XX_valid,lambda_value):
    x = np.linspace(0,1,120)
    ftrue = np.sin((4*np.pi*x)+(np.pi/2))
    predicted_function = np.dot(XX_valid,param_w1) # the param is not the real param, the really param which impact by lambda is calculated below

    plt.figure()
    plt.plot(x_validation_point,ftrue,label = 'true curve',color = 'blue')
    plt.plot(x_validation_point,predicted_function,label = 'prediction',color = 'red')
    plt.plot(x_training_point, t_train, 'o', color="green", label="Training Set")
    plt.plot(x_validation_point, t_valid, '.', color="orange", label="Validation Set")
    plt.title('standardization for M = 11 when lambda = '+ str(lambda_value))
    plt.legend()

M_list = np.arange(0, 12)
C_train = []
C_valid = []
params = []
results = {"M": list(M_list), "training error": [], "validation error": []}

for M in range(0,12):
    X = create_matrix_for_X(M, x_training_point)

    A = np.linalg.inv(np.dot(X.transpose(),X))
    B = np.dot(X.transpose(),t_train) # the dot product of x matrix with the equation 1
    w = np.dot(A,B)  # the parameter is calculated here 
    
    current_train_error = Error_Cal(w, x_training_point, t_train) # find the error at current M setting. 
    current_valid_error = Error_Cal(w, x_validation_point, t_valid)
    print(f"when M =  {M}: training error = {current_train_error}, validation error = {current_valid_error}")
    
    C_train.append(current_train_error)
    C_valid.append(current_valid_error)
    params.append(w)

print("")
print(f"The lowest training error was when M =  {results['M'][np.argmin(C_train)]} and the "
          f"lowest validation error was when M = {results['M'][np.argmin(C_valid)]}")


# For each M you have to train the model using least squares and record the training and validation
# errors. For each M, plot the prediction fM(x) function and the curve ftrue(x) versus
# x = [0; 1]
plotFunc(params)

# plot the training and validation errors versus M.
plotErrors_vs_M(C_train, C_valid)


########------------------------------------------------------------------------
## below begin when M=11, adjusting lambda value. 

from sklearn.preprocessing import StandardScaler
sc = StandardScaler()


XX_train_Matrix = create_matrix_for_X(M, x_training_point)[:,1:] #generate a feature matrix for training data. Then, select all columns except the first one
XX_valid_Matrix = create_matrix_for_X(M, x_validation_point)[:,1:] #generate a feature matrix for validation data. Then, select all columns except the first one


# transform it to have zero mean and unit variance
XX_train_standardization = sc.fit_transform(XX_train_Matrix) 
XX_valid_standardization = sc.transform(XX_valid_Matrix) 

XX_train = np.concatenate((create_matrix_for_X(0, x_training_point), XX_train_standardization), axis=1) #concatenates two NumPy arrays horizontally along the axis 1 
XX_valid = np.concatenate((create_matrix_for_X(0, x_validation_point), XX_valid_standardization), axis=1)



lambda_values = np.logspace(-5, -15, num=100)  # Generate lambda values ranging from e^-5 to e^-15
best_lambda_train = None
best_lambda_valid = None
min_train_error = float('inf')
min_valid_error = float('inf')

# Initialize lists to store training and validation errors for each lambda
training_errors = []
validation_errors = []

# Iterate over lambda values
for lamb_da in lambda_values:
    # Train and evaluate the model for the current lambda value
    param_w = generateParams(lamb_da, XX_train, t_train)
    train_error = lambdaErrorCalc(param_w, X, t_train, lamb_da)
    valid_error = lambdaErrorCalc(param_w, XX_valid, t_valid, lamb_da)
    
    # Append errors to the lists
    training_errors.append(train_error)
    validation_errors.append(valid_error)
    
    #find the best lambda with smallest validation or training error
    if train_error < min_train_error:
        min_train_error = train_error
        best_lambda_train = lamb_da

    if valid_error < min_valid_error:
        min_valid_error = valid_error
        best_lambda_valid = lamb_da

        

print(f"The lambda value with the smallest training error is {best_lambda_train} the training error is {min_train_error}")
print(f"The lambda value with the smallest validation error is {best_lambda_valid} the validation error is {min_valid_error}")


lamb_da1 = 2.72e-12 # control overfitting 
param_w1 = generateParams(lamb_da1, XX_train, t_train)
C_train_lamb_da1 = lambdaErrorCalc(param_w1, X, t_train, lamb_da1)
C_valid_lamb_da1 = lambdaErrorCalc(param_w1, XX_valid, t_valid, lamb_da1)


lamb_da2 = 10e-3   #under fitting 
param_w2 = generateParams(lamb_da2, XX_train, t_train)
C_train_lamb_da2 = lambdaErrorCalc(param_w2, X, t_train, lamb_da2)
C_valid_lamb_da2 = lambdaErrorCalc(param_w2, XX_valid, t_valid, lamb_da2)



# Plot training and validation errors versus lambda
plotErrors_lambda(lambda_values, training_errors, validation_errors)

#----------------------------------------------
# this plot show Here you have to try several values for lambda until you find a value lambda that eliminates the overfitting
# Then plot the training and validation errors versus lambda

# plot when lambda = 2.72e-12 where over fitting is controlled. and it is the best lambda from calculation 
plotFunc_when_M_11(x_validation_point,x_training_point,t_train,t_valid,param_w1,XX_valid,lamb_da1)

# plot when lambda = 10e-3 where under fitting is happening. 
plotFunc_when_M_11(x_validation_point,x_training_point,t_train,t_valid,param_w2,XX_valid,lamb_da2)

plt.show()