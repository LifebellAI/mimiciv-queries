# mimiciv-queries
Putting queries for mimic-iv in a public database to reconstruct the data into the schema required for sepsis labeling and model training, in a similar format to the 2019 Physionet Challenge in early prediction of sepsis

# Some Exploratory Statistics
1. There are 76384 unique icu stays in the MIMIC-IV (as of April 2, 2021 on the MIMIC-IV BigQuery database, which is the most updated version as per the MIMIC-IV project page)
as queried by:
`SELECT count(distinct (hadm_id + subject_id + stay_id)) FROM physionet-data.mimic_icu.icustays`\
In contrast, MIMIC-III only had 52264 unique icustays as queried by:
`SELECT count(distinct (hadm_id + subject_id + icustay_id)) FROM physionet-data.mimiciii_clinical.icustays`\

2. Other changes noted in the MIMIC-IV are largely around schema and how data was pulled and stored, and are listed on the project page seen here: https://mimic-iv.mit.edu/docs/overview/whatsnew/

# How to Use

From a BigQuery free tier account, run the queries in the order indicated by the number preceding the filename. All of this can be done from a free tier account with no subscription.

If you'd like the most updated version I'm using, email me your GCP account email address and I'll give you permissions.
