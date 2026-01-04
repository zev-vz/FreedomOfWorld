# 🌍 Economic Freedom of the World Dashboard

An interactive data visualization dashboard built in **R (Shiny + Plotly)** for exploring the **Economic Freedom of the World (EFW) Index** across countries and time. The project enables users to examine global patterns in economic freedom, compare countries across institutional dimensions, and visualize changes over time using an intuitive, modern interface.

Link: https://ogcovk-zev-van0zanten.shinyapps.io/dashboard/

---

## 🎯 Project Overview

This dashboard allows users to:

- Explore **economic freedom indicators across countries and years**
- Compare nations across the core components of the Economic Freedom of the World Index
- Visualize global patterns using an interactive choropleth map
- Examine cross-sectional and temporal variation in institutional quality and policy outcomes

The application is designed for **exploratory analysis, clarity, and reproducibility**, with a clear separation between data processing and visualization.

---

## 📊 Dataset

**Source:** *Economic Freedom of the World* — Fraser Institute  
**Coverage:** Country-level data across multiple years

## ⚙️ Dashboard Features

### Interactive Controls
- **Year selector** to explore changes over time
- **Variable selector** for overall index scores or component measures
- **Dynamic tooltips** displaying country-level values

### Visualizations
- **Global choropleth map**
  - Interactive world map colored by selected economic freedom indicator
  - Hover tooltips with country names and values
- **Cross-sectional comparison**
  - Compare countries within the same year
- **Temporal exploration**
  - Observe how global and regional patterns evolve over time

---

## 🏆 Key Insights

- **Geographic patterns:** Economic freedom shows strong regional clustering, with higher scores concentrated in North America, Western Europe, and parts of East Asia.
- **Institutional drivers:** Legal systems, property rights, and trade openness are major contributors to overall economic freedom.
- **Time dynamics:** Changes in economic freedom tend to be gradual, with notable shifts around major global economic and political events.
- - **Not all indicators are equal:** Some indicators of economic freedom used by Fraser (such as government spending) are highest in states that are otherwise unfree. Some indicators seem to be correlated more with state capacity than with freedom.

---

## 🔁 Reproducibility & Project Structure

- Raw data from the Fraser Institute is processed using reproducible R scripts
- Data cleaning and feature preparation are completed prior to visualization
- The dashboard consumes a finalized, deployment-ready dataset
- Data processing, UI logic, and visualization components are modular and documented

---

## 🛠 Technologies Used

- **R**
- **Shiny**
- **ggplot2**
- **plotly**
- **dplyr**
- **maps**
- **viridis**

---

## 🚀 Running the App Locally

```r
library(shiny)
runApp("Dashboard.R")
