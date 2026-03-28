# Fargo-Moorhead Real Estate Investment Analysis

## Business Context
Built for H&J Property Development to identify undervalued zip codes 
in the Fargo-Moorhead metro and support residential acquisition decisions.
Includes a property-level analysis of 2306 38th St S, Moorhead MN 56560.

## Business Question
Which Fargo-Moorhead zip codes offer below-median pricing with positive 
appreciation trends? Is the subject property at 2306 38th St S a sound 
investment relative to the broader market?

## Tools Used
- PostgreSQL + pgAdmin — relational database and querying
- Python (pandas) — data unpivoting and transformation
- Tableau Public — interactive dashboard
- GitHub — version control

## Data Sources
- Zillow ZHVI All Homes, Zip Code Level (January 2015 to September 2025)

## Key Findings
1. Moorhead 56560 is a Value Opportunity — priced at $274,597, below the metro 
   median of $321,252, with 2.8% YoY appreciation
2. Moorhead ranks as the most affordable zip code on the Minnesota side 
   of the FM metro at the 22nd percentile metro-wide
3. Core Fargo zip codes (58102, 58103) and Dilworth (56529) show the 
   strongest appreciation at 3.9-4.1% YoY
4. Subject property at $337,900 ($91/sqft) is priced well below new 
   construction replacement cost of $165-185/sqft in the area

## Dashboard
[View Interactive Dashboard](https://public.tableau.com/app/profile/jeffery.guo/viz/Fargo-MoorheadRealEstateInvestmentAnalysis/Fargo-MoorheadRealEstateInvestmentAnalysis)

## Data Notes
- 7 zip codes included covering Moorhead MN, Fargo ND, West Fargo ND, 
  Horace ND, Dilworth MN, Hawley MN, and Casselton ND
- 1,082 null values excluded from analysis (sparse early 2000s data)
- Data current through September 2025
