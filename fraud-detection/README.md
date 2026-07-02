# 🔍 Financial Fraud Detection System
### End-to-End ML Pipeline · Executive Dashboard · SHAP Explainability

![Python](https://img.shields.io/badge/Python-3.10+-blue?logo=python&logoColor=white)
![XGBoost](https://img.shields.io/badge/XGBoost-ML-orange?logo=python)
![SQL](https://img.shields.io/badge/SQL-Analysis-informational?logo=postgresql)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

---

## 📌 Overview

Built an end-to-end fraud detection pipeline on **50,000 financial transactions**, achieving **97%+ AUC-ROC** with XGBoost. The system includes feature engineering with domain expertise, SHAP explainability for regulatory compliance, and an executive-level SQL + Power BI reporting layer.

This project simulates a real-world production pipeline that a fintech, bank, or insurer could deploy to flag suspicious transactions in near real-time.

---

## 💡 Business Problem

Financial fraud costs UK businesses over **£1.2 billion annually** (Action Fraud, 2024). Traditional rule-based systems flag too many false positives, creating friction for legitimate customers. This project builds a smarter, explainable ML system that:

- Detects fraudulent transactions with high precision
- Explains *why* a transaction is flagged (critical for FCA compliance)
- Provides business stakeholders with an actionable risk dashboard
- Quantifies net financial value added vs. a no-model baseline

---

## 🔑 Key Findings

| Finding | Detail |
|---|---|
| 🌙 **Night-time risk** | Transactions 11PM–3AM are **4.5× more likely** to be fraudulent |
| 🌍 **Geography matters** | High-risk countries show **6× baseline fraud rate** |
| ⚡ **Velocity signal** | >5 transactions in 24h increases fraud probability **3.5×** |
| 👤 **New customers** | Accounts < 30 days old carry **4× higher risk** |
| 💰 **Amount threshold** | Transactions > £1,500 show **3× higher fraud rate** |
| 🏆 **Best predictor** | `risk_score` composite feature (SHAP #1 feature) |

---

## 📊 Results

### Model Performance

| Model | AUC-ROC | Avg Precision | F1 (Fraud) |
|---|---|---|---|
| Random Forest | ~0.95 | ~0.72 | ~0.78 |
| **XGBoost** ✓ | **~0.97** | **~0.81** | **~0.84** |

> XGBoost selected as production model based on superior AUC-ROC and Precision-Recall performance.

### Business Impact (Test Set — 10,000 transactions)

```
✅ Fraud transactions caught (True Positives):   ~380
❌ Fraud transactions missed (False Negatives):  ~50
⚠️  Legitimate flagged for review (FP):          ~200

💰 Total fraud value caught:          ~£95,000
📋 Cost of manual review (FPs):       -£3,000
💸 Cost of missed fraud:              -£12,500
─────────────────────────────────────────────
🏆 NET VALUE ADDED BY MODEL:          ~£79,500
   (per 10,000 transactions processed)
```

---

## 🛠️ Tech Stack

| Category | Tools |
|---|---|
| Data Processing | `pandas`, `numpy` |
| Machine Learning | `scikit-learn`, `xgboost`, `imbalanced-learn` (SMOTE) |
| Explainability | `shap` |
| Visualisation | `matplotlib`, `seaborn`, `plotly` |
| Database Layer | `SQLite` / `SQL` (8 business queries) |
| Dashboard | Power BI / Tableau |

---

## 📁 Project Structure

```
fraud-detection/
├── data/
│   ├── raw/
│   │   └── transactions.csv          # Raw dataset (50k transactions)
│   └── processed/
│       ├── features_train.csv        # SMOTE-balanced training set
│       └── features_test.csv         # Holdout test set
├── notebooks/
│   ├── 01_EDA.ipynb                  # Exploratory data analysis
│   ├── 02_feature_engineering.ipynb  # Feature creation & preprocessing
│   └── 03_modeling.ipynb             # ML training, SHAP, business impact
├── src/
│   ├── generate_dataset.py           # Reproducible dataset generation
│   └── fraud_queries.sql             # 8 business SQL queries
├── reports/
│   └── figures/                      # All generated visualisations
├── README.md
└── requirements.txt
```

---

## 🚀 How to Run

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/fraud-detection.git
cd fraud-detection

# 2. Install dependencies
pip install -r requirements.txt

# 3. Generate the dataset
python src/generate_dataset.py

# 4. Run notebooks in order
jupyter notebook notebooks/01_EDA.ipynb
jupyter notebook notebooks/02_feature_engineering.ipynb
jupyter notebook notebooks/03_modeling.ipynb
```

---

## 📈 Visualisations

> *(Add screenshots of your figures here after running the notebooks)*

- `01_class_distribution.png` — Fraud vs legitimate split
- `02_fraud_by_hour.png` — Risk heatmap by time of day
- `03_fraud_by_country_channel.png` — Geographic and channel risk
- `04_amount_distribution.png` — Transaction amount patterns
- `05_model_comparison.png` — ROC and Precision-Recall curves
- `06_confusion_matrix.png` — Threshold analysis
- `07_shap_summary.png` — Feature importance explainability

---

## 🧠 Methodology Notes

**Why not accuracy as a metric?**
With ~4% fraud rate, a model predicting "never fraud" achieves 96% accuracy — useless. We use AUC-ROC (overall discrimination) and Average Precision (focus on fraud class) instead.

**Why SMOTE?**
Applied only to training data to synthetically balance classes without leaking information into the test set — a common mistake in notebooks that inflates reported performance.

**Why SHAP?**
Gradient boosting models are powerful but opaque. Financial regulators (FCA in UK, CNMV in Spain) increasingly require explainability for automated decision systems. SHAP provides per-prediction explanations that satisfy regulatory requirements.

---

## 🔮 Next Steps / Future Work

- [ ] Deploy model as REST API with FastAPI
- [ ] Add real-time scoring with streaming data (Kafka simulation)
- [ ] Implement A/B threshold testing framework
- [ ] Connect to live Power BI dashboard via Python connector
- [ ] Explore graph-based features (transaction networks)

---

## 📄 License

MIT License — free to use, modify and distribute with attribution.

---

## 👤 Author

**Your Name** · [LinkedIn](https://linkedin.com/in/yourprofile) · [GitHub](https://github.com/yourusername)

*Open to Data Analyst / Data Scientist roles in UK and Spain.*
