#!/usr/bin/env python3

# make the dataframe
import pandas as pd
#%% all data
cols = ['Cancer_Incidence',
        'Over_65',
        'White',
        'Black',
        'Hispanic',
        'Native_American',
        'Asian',
        'Premature_Death',
        'Poor_Physical_Days',
        'Poor_Mental_Days',
        'Adult_Smoking',
        'Adult_Obesity',
        'Food_Envr_Index',
        'Physical_Inactivity',
        'Exercise_Access',
        'Excessive_Drinking',
        'STD',
        'Uninsured',
        'Primary_Care',
        'Dentists',
        'Mental_Health_Providers',
        'Diabetic',
        'Mammography',
        'HS_Graduation',
        'Some_College',
        'Unemployment',
        'Inadequate_Social_Support',
        'Single_Parent',
        'Violent_Crime',
        'Housing_Problems',
        'Driving_Alone',
        'Long_Commute',
        'Rural_Area',
        'Diabetes_Value',
        'Food_Insecurity',
        'Access_To_Healthy_Food',
        'a_ccl4',
        'a_cl_ln',
        'a_cn_ln',
        'a_diesel_ln',
        'a_eox_ln',
        'a_pb_ln',
        'a_pm10_mean_ln',
        'a_pm25_mean',
        'a_so2_mean_ln',
        'a_no2_mean_ln',
        'a_co_mean_ln',
        'a_o3_mean_ln',
        'a_teca_ln',
        'w_112tca_ln',
        'a_dbcp_ln',
        'a_tdi_ln',
        'a_2clacephen_ln',
        'a_2np_ln',
        'a_pnp_ln',
        'a_ch3cn_ln',
        'a_acetophenone_ln',
        'a_acrolein_ln',
        'a_acrylic_acid_ln',
        'a_c3h3n_ln',
        'a_sb_ln',
        'a_benzidine_ln',
        'a_benzyl_cl_ln',
        'a_be_ln',
        'a_biphenyl_ln',
        'a_dehp_ln',
        'a_bromoform_ln',
        'a_cd_ln',
        'a_cs2_ln',
        'a_cs_ln',
        'a_c6h5cl_ln',
        'a_chloroform_ln',
        'a_chloroprene_ln',
        'a_cr_ln',
        'a_cresol_ln',
        'a_cumene_ln',
        'a_dbp_ln',
        'a_dmf_ln',
        'a_me2_phthalate_ln',
        'a_me2so4_ln',
        'a_ech_ln',
        'a_etacrylate_ln',
        'a_etcl_ln',
        'a_edb_ln',
        'a_edc_ln',
        'a_egly_ln',
        'a_edcl2_ln',
        'a_glycol_ethers_ln',
        'a_hcb_ln',
        'a_hcbd_ln',
        'a_hccpd_ln',
        'a_hexane_ln',
        'a_n2h2_ln',
        'a_hcl_ln',
        'a_isophorone_ln',
        'a_mn_ln',
        'a_hg_ln',
        'a_meoh_ln',
        'a_mibk_ln',
        'a_mma_ln',
        'a_mecl_ln',
        'a_mehydrazine_ln',
        'a_mtbe_ln',
        'a_nitrobenzene_ln',
        'a_dma_ln',
        'a_otoluidine_ln',
        'a_pahpom_ln',
        'a_pcp_ln',
        'a_ph3_ln',
        'a_p_ln',
        'a_pcbs_ln',
        'a_procl2_ln',
        'a_proo_ln',
        'a_quinoline_ln',
        'a_se_ln',
        'a_cl4c2_ln',
        'a_toluene_ln',
        'a_c2hcl3_ln',
        'a_etn_ln',
        'a_vyac_ln',
        'a_vycl_ln',
        'a_11dce_ln']
data = pd.DataFrame(columns = cols)
#%% environmental only
cols = ['Cancer_Incidence',
        'a_ccl4',
        'a_cl_ln',
        'a_cn_ln',
        'a_diesel_ln',
        'a_eox_ln',
        'a_pb_ln',
        'a_pm10_mean_ln',
        'a_pm25_mean',
        'a_so2_mean_ln',
        'a_no2_mean_ln',
        'a_co_mean_ln',
        'a_o3_mean_ln',
        'a_teca_ln',
        'w_112tca_ln',
        'a_dbcp_ln',
        'a_tdi_ln',
        'a_2clacephen_ln',
        'a_2np_ln',
        'a_pnp_ln',
        'a_ch3cn_ln',
        'a_acetophenone_ln',
        'a_acrolein_ln',
        'a_acrylic_acid_ln',
        'a_c3h3n_ln',
        'a_sb_ln',
        'a_benzidine_ln',
        'a_benzyl_cl_ln',
        'a_be_ln',
        'a_biphenyl_ln',
        'a_dehp_ln',
        'a_bromoform_ln',
        'a_cd_ln',
        'a_cs2_ln',
        'a_cs_ln',
        'a_c6h5cl_ln',
        'a_chloroform_ln',
        'a_chloroprene_ln',
        'a_cr_ln',
        'a_cresol_ln',
        'a_cumene_ln',
        'a_dbp_ln',
        'a_dmf_ln',
        'a_me2_phthalate_ln',
        'a_me2so4_ln',
        'a_ech_ln',
        'a_etacrylate_ln',
        'a_etcl_ln',
        'a_edb_ln',
        'a_edc_ln',
        'a_egly_ln',
        'a_edcl2_ln',
        'a_glycol_ethers_ln',
        'a_hcb_ln',
        'a_hcbd_ln',
        'a_hccpd_ln',
        'a_hexane_ln',
        'a_n2h2_ln',
        'a_hcl_ln',
        'a_isophorone_ln',
        'a_mn_ln',
        'a_hg_ln',
        'a_meoh_ln',
        'a_mibk_ln',
        'a_mma_ln',
        'a_mecl_ln',
        'a_mehydrazine_ln',
        'a_mtbe_ln',
        'a_nitrobenzene_ln',
        'a_dma_ln',
        'a_otoluidine_ln',
        'a_pahpom_ln',
        'a_pcp_ln',
        'a_ph3_ln',
        'a_p_ln',
        'a_pcbs_ln',
        'a_procl2_ln',
        'a_proo_ln',
        'a_quinoline_ln',
        'a_se_ln',
        'a_cl4c2_ln',
        'a_toluene_ln',
        'a_c2hcl3_ln',
        'a_etn_ln',
        'a_vyac_ln',
        'a_vycl_ln',
        'a_11dce_ln']
data = pd.DataFrame(columns = cols)
#%% read the cancer incidence
import csv
with open('lung cancer.csv') as f:
    reader = csv.reader(f)
    for row in reader:
        key = row[0].strip()
        incidence = row[2].strip()
        data.at[key,'Cancer_Incidence'] = incidence

#%% read the demographic data

def padZero(text,length):
    l = len(text)
    if l < length:
        return '0'*(length - l) + text
    else:
        return text
    
#%% read in the health factors
with open('chsi_dataset/2014CHR_CSV_Analytic_Data.csv') as f:
    reader = csv.DictReader(f)
    for row in reader:
        fipsState = row['State_FIPS_Code']
        fipsCounty = padZero(row['County_FIPS_Code'],3)
        key = fipsState + fipsCounty
        for col in cols:
            if col in row:
                data.at[key, col] = row[col]


                
# %% in the chemical environmental exposure
with open('chsi_dataset/CHEMICALEXPOSURE.csv') as f:
    reader = csv.DictReader(f)
    for row in reader:
        key = row['stfips']
        for col in cols:
            if col in row:
                data.at[key, col] = row[col]
                
 data=data.iloc[1:]             
#%%
data=data.dropna()
data=data[~data['Cancer_Incidence'].isin(['#N/A'])]

#%%
data.to_csv('clean_data_lung_new.csv', index_label='FIPS')
