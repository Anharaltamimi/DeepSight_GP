# DeepSight — AI-Powered Diabetic Maculopathy Diagnosis System

DeepSight is a full-stack, AI-powered web application that leverages deep learning to automate the screening of **Diabetic Maculopathy (DM)** from **Optical Coherence Tomography (OCT)** images. The system uses a fine-tuned **DenseNet121** model to analyze retinal scans and classify them as either **Diabetic Maculopathy (DM)** or **Normal**, achieving **96% accuracy**. It provides an AI-assisted tool to support healthcare professionals in analyzing retinal images and making informed diagnostic decisions.

Developed as a Graduation Project at the **College of Computer & Information Sciences, Princess Nourah bint Abdulrahman University (PNU)**, Riyadh, KSA.

## System Architecture

The system follows a sequential workflow from doctor authentication to OCT validation, classification, explainability, and report generation.

```text
┌─────────────────────────────┐
│         User Login          │  ← Doctor enters username and password
│   (username + password)     │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│   Email OTP Verification    │  ← 6-digit code sent to the doctor's email
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│      Upload OCT Image       │  ← Doctor uploads a retinal OCT scan
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│     OCT Validity Check      │  ← EfficientNet-B2 features + One-Class SVM
│     EfficientNet-B2 +       │    decide whether this is an OCT image or not
│        One-Class SVM        │
└──────────────┬──────────────┘
               │
        ┌──────┴──────┐
        │             │
     Invalid         Valid
        │             │
        ▼             ▼
┌───────────────┐     │
│ Reject Message│     │
│  (re-upload)  │     │
└───────────────┘     ▼
              ┌─────────────────────────────┐
              │        Preprocessing        │  ← Image resized to 224×224×3
              │        (224×224×3)          │
              └──────────────┬──────────────┘
                             │
                             ▼
              ┌─────────────────────────────┐
              │         DenseNet121         │  ← Fine-tuned CNN classifies the scan (DM / Normal)
              │    (Transfer Learning)      │
              └──────────────┬──────────────┘
                             │
                             ▼
              ┌─────────────────────────────┐
              │     Result: DM / Normal     │  ← Predicted class for the OCT image
              └──────────────┬──────────────┘
                             │
                             ▼
              ┌─────────────────────────────┐
              │      Grad-CAM Heatmap       │  ← Highlights regions behind the prediction
              └──────────────┬──────────────┘
                             │
                             ▼
              ┌─────────────────────────────┐
              │      Diagnostic Report      │  ← Combines result, heatmap, and patient info
              │    (PDF, with Heatmap)      │
              └──────────────┬──────────────┘
                             │
                             ▼
              ┌─────────────────────────────┐
              │   View / Download Report    │  ← Doctor reviews or saves the final report
              └─────────────────────────────┘
```

DeepSight relies on two main AI components in its diagnostic pipeline:

* **OCT validity checker (EfficientNet-B2 + One-Class SVM):** The uploaded image is divided into **224×224 patches**, and deep features are extracted from each patch using a pretrained **EfficientNet-B2** model used as a fixed feature extractor. A **One-Class SVM** is trained on OCT patch features to learn the characteristics of OCT images. Non-OCT samples are used to calibrate the decision threshold using ROC analysis. During inference, the system evaluates the image patches and accepts the image as an OCT scan when at least one patch meets the calibrated threshold. Otherwise, the image is rejected and the user is asked to upload another image.

* **DM classification model (DenseNet121):** Validated OCT images are preprocessed and classified using a fine-tuned **DenseNet121** model into **Diabetic Maculopathy (DM)** or **Normal**. A **Grad-CAM** heatmap is generated alongside each prediction and included in the diagnostic report to visually highlight the regions that influenced the model's prediction.

## Model Development & Comparison

Four pretrained CNN architectures — **VGG-16, InceptionV3 (GoogleNet), MobileNetV2, and DenseNet121** — were trained and compared under the same experimental conditions using **transfer learning** and **5-fold cross-validation** on a binary classification task (DM vs. Normal). All images were resized to **224×224×3**.

**DenseNet121** was selected as the final model because it achieved the best overall performance.

| Model                      |   Accuracy |  Precision |     Recall |         Specificity |
| -------------------------- | ---------: | ---------: | ---------: | ------------------: |
| VGG-16                     |     89.17% |     90.33% |     89.17% |     97.67% / 80.67% |
| InceptionV3 (GoogleNet)    |     91.83% |     91.91% |     91.83% |     94.00% / 89.67% |
| MobileNetV2                |     92.83% |     93.04% |     92.83% |     96.33% / 89.33% |
| **DenseNet121 (selected)** | **96.00%** | **96.03%** | **96.00%** | **97.33% / 94.67%** |

## Dataset

DeepSight uses separate datasets for model development and independent evaluation.

| Dataset                     | Source                                         |       Total Images |                     Images Used | Purpose                                                                   |
| --------------------------- | ---------------------------------------------- | -----------------: | ------------------------------: | ------------------------------------------------------------------------- |
| Training / Cross-Validation | Retinal OCT Image Classification – C8 (Kaggle) | 24,000 (8 classes) | 6,000 (Normal + DM, 3,000 each) | Model training and 5-fold cross-validation                                |
| Independent Testing         | Kermany et al., 2018 (Kaggle)                  |             18,897 |                          18,897 | Final evaluation only; unseen during training and cross-validation        |
| Non-OCT                     | Kaggle (exact dataset link unavailable)        |                  — |                               — | Used to calibrate the OCT validity threshold using non-OCT image features |

## Application Features

* Doctor login using username and password
* Email-based OTP verification for secure authentication
* OCT image upload with patient information
* OCT image validity checking before classification
* DM / Normal classification of validated OCT scans
* Grad-CAM heatmap visualization
* Diagnostic report generation and download in PDF format
* Diagnosis history for reviewing previous patient diagnoses
* Doctor profile management

## Tech Stack

| Category                       | Technologies                                          |
| ------------------------------ | ----------------------------------------------------- |
| Frontend                       | HTML, CSS, JavaScript, Jinja2                         |
| Backend                        | Flask, Flask-SQLAlchemy, Flask-Session, Flask-Limiter |
| Deep Learning                  | TensorFlow, Keras, DenseNet121                        |
| Feature Extraction (OCT Check) | PyTorch, TorchVision, EfficientNet-B2                 |
| Classical Machine Learning     | Scikit-learn, One-Class SVM                           |
| Image Processing               | OpenCV, Pillow                                        |
| Data Processing                | NumPy, Pandas                                         |
| Database                       | MySQL, SQLAlchemy ORM                                 |
| Authentication & Security      | Werkzeug, Email OTP, Flask-Limiter                    |
| Explainable AI                 | Grad-CAM                                              |

## Project Structure

```text
├── models/                  # Trained DenseNet121 model
├── Non_OCT/                 # Non-OCT images used for OCT validity checking
├── RetinalOCT_Dataset/      # Training/cross-validation dataset
├── static/                  # CSS, JavaScript, uploaded images, generated reports
├── templates/               # Frontend (Jinja2 HTML templates)
├── .env.example             # Template for required environment variables
├── app.py                   # Backend (Flask)
├── create_db.py             # Database initialization script
├── db.py                    # Database models and session setup
├── oct_checker.py           # OCT validity checker
├── train_oct_svm.py         # Script for training the OCT validity checker
├── libraries.txt            # Python dependencies
└── README.md                # Project documentation
```

## Getting Started

### Prerequisites

Before running DeepSight, make sure the following are installed and configured:

* Python 3.10+
* MySQL server (e.g., via XAMPP)
* A Gmail account with an App Password for sending OTP emails

### Installation

The following steps use a **terminal (Windows PowerShell)**.

```
cd DeepSight

# If another virtual environment is currently active, deactivate it first
deactivate

# Create a virtual environment
py -m venv .venv

# Allow the activation script to run (one-time, per user)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Activate the virtual environment
.venv\Scripts\activate

# Install PyTorch (CPU version) for the OCT validity checker
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Install the remaining project dependencies
pip install -r libraries.txt
```

### Environment Configuration

Create a local `.env` file from the provided template:

```
cp .env.example .env
```

Then update the required values in `.env`, including:

* `SECRET_KEY`
* Gmail address
* Gmail App Password
* Any other variables defined in `.env.example`

For local testing, `TEST_MODE` and `TEST_OTP` can be used to test the login flow with a fixed OTP without sending real emails.

> **Never commit the `.env` file or expose Gmail credentials, App Passwords, or secret keys.**

### Database Configuration

DeepSight includes a **prepared database** that should be imported into MySQL using **phpMyAdmin**.

1. Open the provided `Database` file and update any required values (e.g. the Gmail address used for sending OTPs) so they match your local configuration.
2. Open **XAMPP**.
3. Start the **MySQL** service.
4. Open **phpMyAdmin**.
5. Create the required database if it does not already exist.
6. Import the updated SQL database file into the database.
7. Update `DATABASE_URL` in `.env` so that it matches the local MySQL configuration.

The imported database already contains the required tables and project data.

### OCT Validity Checker

The OCT validity checker must be trained before running the application.

Run:

```
python train_oct_svm.py
```

The script uses OCT and Non-OCT images to:

* Extract deep features from 224×224 image patches using EfficientNet-B2.
* Train the One-Class SVM on OCT patch features.
* Calibrate the decision threshold using ROC analysis and Non-OCT features.
* Save the trained model and calibrated threshold.

The resulting file is:

```
oct_svm.joblib
```

### Running the Application

After installing the dependencies, configuring the `.env` file, importing the prepared database, and training the OCT validity checker, start the Flask application:

```
python app.py
```

Then open the application in your browser:

```text
http://localhost:5000
```


**Team Members:**

* Anhar Saud Altamimi
* Maryam Ahmad Alshibli
* Roqaiah Ali Domari
* Shaden Mohammed Alqahtani
* Fajer Mohammed Binali
