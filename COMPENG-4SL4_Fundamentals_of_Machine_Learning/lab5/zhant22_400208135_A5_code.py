import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap

# Function to assign each data point to the nearest centroid
def FUNC_deter_closest_centroids(X, centroids):
    shape = centroids.shape[0]
    index = np.zeros(X.shape[0], dtype=int)

    for i in range(X.shape[0]):
        distances = [np.linalg.norm(X[i] - centroids[j]) for j in range(shape)]
        index[i] = np.argmin(distances)

    return index

# Function to compute the new centroids based on the assigned points
def FUNC_compute_centroids(X, idx, K):
    m, n = X.shape
    centroids = np.zeros((K, n))

    for i in range(K):
        current_point = X[idx == i]
        centroids[i] = np.mean(current_point, axis=0)

    return centroids

# Function to run the K-Means algorithm
def K_mean_iteration(X, initial_centroids, run_limit=10, plot_progress=False):
    m, n = X.shape
    K = initial_centroids.shape[0]
    current_centroids = initial_centroids
    previous_centroids = current_centroids
    index = np.zeros(m)
    plt.figure(figsize=(8, 6))
    past_centroids = 0

    for i in range(run_limit):
        print("K-Means iteration at %d/%d" % (i, run_limit-1))
        index = FUNC_deter_closest_centroids(X, current_centroids)

        if plot_progress:
            plot_progress_kMeans(X, current_centroids, previous_centroids, index, K, i)
            previous_centroids = current_centroids

        current_centroids = FUNC_compute_centroids(X, index, K)

        # Check for convergence by comparing centroids
        if np.array_equal(past_centroids, current_centroids):
            break
        past_centroids = current_centroids

    plt.show()
    return current_centroids, index


# Function to plot data points colored by cluster assignment
def Func_color_map_gen(X, idx):
    # Generating a list of 40 distinct colors
    custom_colors = [
        (0.12156863, 0.46666667, 0.70588235),  # Blue
        (1.0, 0.49803922, 0.05490196),         # Orange
        (0.17254902, 0.62745098, 0.17254902),  # Green
        (0.83921569, 0.15294118, 0.15686275),  # Red
        (0.58039216, 0.40392157, 0.74117647),  # Purple
        (0.54901961, 0.3372549 , 0.29411765),  # Brown
        (0.89019608, 0.46666667, 0.76078431),  # Pink
        (0.49803922, 0.49803922, 0.49803922),  # Gray
        (0.7372549 , 0.74117647, 0.13333333),  # Yellow
        (0.09019608, 0.74509804, 0.81176471),  # Cyan
        (0.95686275, 0.64313725, 0.37647059),  # Light Orange
        (0.3254902 , 0.42745098, 0.74509804),  # Dark Blue
        (0.97647059, 0.45098039, 0.02352941),  # Bright Orange
        (0.38039216, 0.78823529, 0.49019608),  # Mint Green
        (0.92156863, 0.38039216, 0.32156863),  # Salmon
        (0.68627451, 0.61176471, 0.85490196),  # Lavender
        (0.65098039, 0.42745098, 0.38823529),  # Mahogany
        (0.92941176, 0.59607843, 0.87843137),  # Orchid
        (0.61568627, 0.61568627, 0.61568627),  # Silver
        (0.81960784, 0.81960784, 0.36862745),  # Lime
        (0.08235294, 0.67058824, 0.7372549),   # Teal
        (0.23921569, 0.54509804, 0.63921569),  # Steel Blue
        (0.99607843, 0.68235294, 0.44705882),  # Peach
        (0.4627451 , 0.63921569, 0.28627451),  # Olive Green
        (0.76862745, 0.31372549, 0.29019608),  # Coral
        (0.55686275, 0.49411765, 0.71372549),  # Lilac
        (0.51764706, 0.3254902 , 0.28235294),  # Sienna
        (0.9372549 , 0.73333333, 0.81568627),  # Rose
        (0.65882353, 0.65882353, 0.65882353),  # Medium Gray
        (0.68627451, 0.69019608, 0.12941176),  # Mustard
        (0.11764706, 0.75686275, 0.82745098),  # Sky Blue
        (0.74901961, 0.57254902, 0.51372549),  # Taupe
        (0.9372549 , 0.69411765, 0.73333333),  # Blush Pink
        (0.41960784, 0.8       , 0.8745098),   # Turquoise
        (0.8627451 , 0.57647059, 0.5372549 ),  # Light Salmon
        (0.96862745, 0.84705882, 0.5372549 ),  # Banana Yellow
        (0.05490196, 0.63137255, 0.32941176),  # Forest Green
        (0.7254902 , 0.52941176, 0.62745098),  # Mauve
        (0.31764706, 0.57254902, 0.64705882)   # Slate Blue
    ]

# Create a ListedColormap with the custom colors
    cmap = ListedColormap(custom_colors)

    # Check for NaN values in X
    nan_mask = np.isnan(X)
    
    # Check if there are any NaN values in the array
    if np.any(nan_mask):
        # Handle NaN values (for example, by removing them)
        X = X[~np.any(nan_mask, axis=1)]  # Remove entire rows with NaN values

    # Check if X is empty after removing NaN values
    if X.size == 0:
        return

    # Calculate the mean after NaN values are handled
    mean_X = np.mean(X, axis=0)

    # Use the colormap to get colors based on idx
    c = cmap(idx)

    # Plot the scatter plot
    plt.scatter(X[:, 0], X[:, 1], facecolors='none', edgecolors=c, linewidth=0.1, alpha=0.7)
    


# Function to plot the progress of K-Means algorithm
def plot_progress_kMeans(X, centroids, previous_centroids, idx, K, i):

    plt.scatter(centroids[:, 0], centroids[:, 1], marker='x', c='k', linewidths=3)

    plt.title("Iteration number %d" % i)

# Function to display the colors of the centroids
def centroid_colors_gen(centroids):
    palette = np.expand_dims(centroids, axis=0)
    num = np.arange(0, len(centroids))
    plt.figure(figsize=(16, 16))
    plt.xticks(num)
    plt.yticks([])
    plt.imshow(palette)

# Function to initialize centroids randomly


# Function to initialize centroids non-randomly
def kMeans_init_centroids_non_random(X, K):
    num_samples, num_features = X.shape
    centroids = np.empty((K, num_features))

    rand_index = np.random.randint(0, num_samples)
    centroids[0] = X[rand_index]

    distances = np.linalg.norm(X - centroids[0], axis=1)

    for k in range(1, K):
        prob = distances ** 2 / np.sum(distances ** 2)
        cum_prob = np.cumsum(prob)

        rand_val = np.random.rand()
        for idx, c_prob in enumerate(cum_prob):
            if rand_val < c_prob:
                centroids[k] = X[idx]
                break

        new_distances = np.linalg.norm(X - centroids[k], axis=1)
        distances = np.minimum(distances, new_distances)

    return centroids

# Load and preprocess an image for K-Means compression
original_img = plt.imread('bird.png')
plt.imshow(original_img)
print("Shape of original_img is:", original_img.shape)
original_img = original_img[:, :, :3]
print("Shape of new* original_img is:", original_img.shape)

X_img = np.reshape(original_img, (original_img.shape[0] * original_img.shape[1], 3))

# List of different values for K
K_list = [2, 3, 10, 20, 40]
max_iters = 1000

# Loop through different values of K and run K-Means
for K in K_list:

    random_index = np.random.permutation(X_img.shape[0])
    initial_centroids_random = X_img[random_index[:K]]

    print("\n")
    print(f"K = {K}\n")
    centroids_random, idx_random = K_mean_iteration(X_img, initial_centroids_random, max_iters)

    show_centroid_colors(centroids_random)

    idx_random = FUNC_deter_closest_centroids(X_img, centroids_random)

    X_recovered = centroids_random[idx_random, :]
    X_recovered = np.reshape(X_recovered, original_img.shape)

    # Display the original and compressed images with random initialization
    fig, ax = plt.subplots(1, 2, figsize=(16, 16))
    plt.axis('off')

    ax[0].imshow(original_img)
    ax[0].set_title('Original (Random)')
    ax[0].set_axis_off()

    ax[1].imshow(X_recovered)
    ax[1].set_title('Compressed with %d colours (Random)' % K)
    ax[1].set_axis_off()

    mse_random = np.mean((original_img - X_recovered) ** 2)
    print(f"MSE  (Random) : {mse_random}")


    # Run K-Means with non-random initialization
    initial_centroids_non_random = kMeans_init_centroids_nonrand(X_img, K)

    centroids_non_rand, idx_random = K_mean_iteration(X_img, initial_centroids_non_random, max_iters)

    show_centroid_colors(centroids_non_rand)

    idx_random = FUNC_deter_closest_centroids(X_img, centroids_non_rand)

    X_recovered_non_random = centroids_non_rand[idx_random, :]
    X_recovered_non_random = np.reshape(X_recovered_non_random, original_img.shape)

    # Display the original and compressed images with non-random initialization
    fig, ax = plt.subplots(1, 2, figsize=(16, 16))
    plt.axis('off')

    ax[0].imshow(original_img)
    ax[0].set_title('Original (Non-Random)')
    ax[0].set_axis_off()

    ax[1].imshow(X_recovered_non_random)
    ax[1].set_title('Compressed with %d colours (Non-Random)' % K)
    ax[1].set_axis_off()

    mse_nonrandom = np.mean((original_img - X_recovered_non_random) ** 2)
    print(f"MSE  (Non-Random): {mse_nonrandom}")
    print("when K is : ",K,"the random MSE is : ",mse_random, " and non_random mse is : ",mse_nonrandom)

#plot the data_point below: 
for K in K_list:
    # Random Initialization
    randidx = np.random.permutation(X_img.shape[0])
    initial_centroids_random = X_img[randidx[:K]]

    print("\n")
    print(f"K = {K}\n")
    centroids_random, idx_random = K_mean_iteration(X_img, initial_centroids_random, max_iters)

    Func_color_map_gen(X_img, idx_random)
    plt.scatter(centroids_random[:, 0], centroids_random[:, 1], marker='x', c='k', linewidths=3)

    plt.title(f"Final Result for K = {K} (Random Initialization)")
    plt.show()

    mse_random_f = np.mean((X_img - centroids_random[idx_random, :]) ** 2)
    print(f"MSE (Random Initialization): {mse_random_f}")

    # Non-Random Initialization
    rand_index = np.random.randint(0, X_img.shape[0])
    initial_centroids_nonrandom = np.zeros((K, X_img.shape[1]))

    distances_nonrandom = np.linalg.norm(X_img - X_img[rand_index], axis=1)

    for k in range(1, K):
        prob_nonrandom = distances_nonrandom ** 2 / np.sum(distances_nonrandom ** 2)
        cum_prob_nonrandom = np.cumsum(prob_nonrandom)

        rand_val_nonrandom = np.random.rand()
        for idx_nonrandom, c_prob_nonrandom in enumerate(cum_prob_nonrandom):
            if rand_val_nonrandom < c_prob_nonrandom:
                initial_centroids_nonrandom[k] = X_img[idx_nonrandom]
                break

        new_distances_nonrandom = np.linalg.norm(X_img - initial_centroids_nonrandom[k], axis=1)
        distances_nonrandom = np.minimum(distances_nonrandom, new_distances_nonrandom)

    centroids_nonrandom, idx_nonrandom = K_mean_iteration(X_img, initial_centroids_nonrandom, max_iters)

    Func_color_map_gen(X_img, idx_nonrandom)
    plt.scatter(centroids_nonrandom[:, 0], centroids_nonrandom[:, 1], marker='x', c='k', linewidths=3)

    plt.title(f"Final Result for K = {K} (Non-Random Initialization)")
    plt.show()

    mse_nonrandom_f = np.mean((X_img - centroids_nonrandom[idx_nonrandom, :]) ** 2)
    print(f"MSE (Non-Random Initialization): {mse_nonrandom_f}")