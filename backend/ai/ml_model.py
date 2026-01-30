import cv2
import numpy as np
from sklearn.linear_model import LogisticRegression

# -------------------------------
# Train a tiny ML model (on start)
# -------------------------------

# Dummy training data (edge_density, texture)
X_train = [
    [0.1, 10],  # smooth road → Accessible
    [0.3, 30],  # uneven → Difficult
    [0.6, 70],  # stairs / broken → Inaccessible
]

y_train = [0, 1, 2]

model = LogisticRegression(multi_class="auto", max_iter=200)
model.fit(X_train, y_train)


def extract_features(image_path):
    """
    Extract simple visual features using OpenCV
    """
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    img = cv2.resize(img, (224, 224))

    edges = cv2.Canny(img, 100, 200)
    edge_density = np.sum(edges > 0) / edges.size

    texture = np.std(img)

    return [edge_density, texture]


def predict_accessibility(image_path):
    """
    ML prediction:
    0 = Accessible
    1 = Difficult
    2 = Inaccessible
    """
    features = extract_features(image_path)
    prediction = model.predict([features])[0]
    return prediction
