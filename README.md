# U.S. Used-Toyota Market Analysis  
**Masters in Applied Business Analytics – Final Project**  
**Tech Stack:** R (tidyverse, lubridate, ggplot2, caret, forecast, cluster)   

---

## 1. Situation & Objectives
This project examined the U.S. used-Toyota vehicle market to:  
- Identify environmental factors impacting sales.  
- Describe current industry structure and market leaders.  
- Forecast how the market may evolve over the next 5–10 years.  
- Recommend geographic, model, and consumer strategies for expansion.  

---

## 2. Data & Methodology
**Data Sources:**  
- ~100,000+ Toyota vehicle listings (2014–2015).  
- State-level Real GDP (2015).  

**Methods:**  
- **Data Cleaning:** Standardization of make/model/body columns, removal of non-U.S. states, outlier filtering at 300k+ miles.  
- **EDA:** Price by geography, model popularity, body type distribution, mileage vs. price, price over time.  
- **Regression:** OLS on selling price with predictors (year, odometer, condition, GDP).  
- **Time-Series Forecasting:** ARIMA 12-month forecast of average selling price.  
- **Clustering:** K-means (k=3) segmentation on vehicle year, odometer, and price.  

---

## 3. Research Questions & Findings  

### Q1. What environmental factors tend to impact the sales of our company’s offerings?  
- **Economic:** States with higher GDP (e.g., CA, NY, TX) show higher Toyota sales and average prices. Disposable income enables upgrades and premium trims.  
- **Geographic:** Coastal and southern states (CA, FL, TX) demonstrate high demand; northern states show preferences for AWD SUVs and trucks.  
- **Political:** Tariffs, emissions standards, and EV incentives influence cost structures and consumer demand.  
- **Social:** Strong demand for SUVs and sedans; consumer emphasis on affordability, practicality, and eco-friendliness.  
- **Seasonal:** Prices rise in spring (tax refund season) and dip in fall (holiday spending).  

---

### Q2. What is the current structure of the used car industry in the USA?  
- The U.S. used car market is **large and fragmented**, dominated by small dealerships and private sellers.  
- Emerging leaders like **CarMax** and **Carvana** are reshaping the industry through **digital-first models** (virtual tours, online financing, delivery).  
- Technology enables transparency (vehicle histories, accident reports, financing calculators), fueling consumer trust and convenience.  
- Online research is increasingly driving sales—over half of CarMax buyers use the website before purchasing.  

---

### Q3. Who are the market leaders, and what are their characteristics?  
- **Toyota, Honda, Ford, Chevrolet** dominate the U.S. used market.  
- **Toyota’s leadership confirmed in dataset**: Corolla, Camry, and RAV4 are the most frequently listed and sold.  
- Characteristics of leaders: reliability, resale value, affordability, and nationwide dealership infrastructure.  
- Toyota’s hybrids and CPO programs strengthen competitive positioning.  

---

### Q4. How will the market change in the next 5–10 years?  
- **Forecasting (ARIMA):** Toyota used-vehicle prices projected to grow moderately (3–5% annually).  
- **Technology:** Digitization and online platforms will dominate sales channels.  
- **Electrification:** EV and hybrid adoption will rise due to regulations and consumer demand.  
- **Analytics:** Predictive pricing and segmentation (via clustering) will personalize offers.  
- **Ownership patterns:** Subscription and shared mobility services may reduce long-term ownership in urban areas.  

---

### Q5. What geographic areas should we target?  
- **Top Markets:** California, Florida, and Pennsylvania (highest listings and average prices).  
- **Emerging Markets:** Georgia and Ohio (growing volumes and strong pricing power).  
- Strategy: maintain dominance in top states while building presence in rising markets.  

---

### Q6. What car models and specifications should we use for expansion?  
- **Body Types:** Sedans and SUVs dominate demand and show stable resale prices.  
- **Top Models:** Corolla, Camry, RAV4.  
- **Condition & Mileage:** Prioritize vehicles in **Good+ condition** and with **≤100,000 miles**.  
- Evidence: Price vs. Odometer analysis shows depreciation accelerates with higher mileage.  

---

### Q7. Are there important consumer behavior trends to be aware of?  
- **Affordability & Value:** Consumers remain highly price-sensitive.  
- **Transparency:** Demand for vehicle histories and condition reports is increasing.  
- **Practicality:** Buyers favor fuel efficiency, low maintenance, and reliability.  
- **Seasonal Effects:** Higher purchase activity in spring, lower in fall.  
- **Segmentation:** Clustering revealed three distinct buyer groups—premium (newer, low miles), balanced mid-range, and budget-conscious high-mileage.  

---

## 4. Strategic Recommendations
- **Geographic:** Focus on CA, FL, PA; expand in GA and OH.  
- **Inventory:** Prioritize sedans/SUVs, Corolla, Camry, RAV4; ≤100k miles; Good+ condition.  
- **Consumer Strategy:**  
  - Premium cluster: Certified Pre-Owned + financing.  
  - Value cluster: Affordable, transparent pricing.  
  - Mid-range cluster: Balanced offers.  
- **Future-Proofing:** Invest in hybrid/EV inventory and strengthen digital sales platforms.  

---

## 5. Reproducibility
- All analysis code is available in two forms:  
  - `analysis.R` (original R script)  
  - `analysis_notebook.ipynb` (Jupyter notebook with the same R code, using IRkernel).  
- Visuals are reproduced in the notebook and expanded into a Tableau dashboard.  
- Tableau Public dashboard link (interactive): [https://public.tableau.com/views/UsedCarMarketAnalysis_17574407224210/UsedToyotaMarketAnalysis?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link]  
- To reproduce locally:  
  - Run either the R script or the notebook (R kernel required).  
  - Use the provided CSV datasets. 
