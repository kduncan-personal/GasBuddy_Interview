create database gasbuddy;

\c gasbuddy

create table boston_police_station (
x text,
y text,
objectid text,
bldg_id text,
bid text,
address text,
point_x text,
point_y text,
name text,
neighborhood text,
city text,
zip text,
ft_sqft text,
story_ht text,
parcel_id text
);

copy boston_police_station from '/Users/kellyduncan/GasBuddy/Boston_Police_Stations.csv' delimiter ',' csv header;

create table crime(
incident_number text,
offense_code text,
offense_code_group text,
offense_description text,
district text,
reporting_area text,
shooting text,
occurred_on_date text,
year text,
month text,
day_of_week text,
hour text,
ucr_part text,
street text,
lat text,
long text,
location text
);

copy crime from '/Users/kellyduncan/GasBuddy/crime.csv' delimiter ',' csv header;

#needed to delete \xa0 from rows for last command to work (thank you sublime)

create table propery(
pid text,
cm_id text,
gis_id text,
st_num text,
st_name text,
st_name_suf text,
unit_num text,
zipcode text,
ptype text,
lu text,
own_occ text,
owner text,
mail_addressee text,
mail_address text,
mail_cs text,
mail_zipcode text,
av_land text,
av_bldg text,
av_total text,
gross_tax text,
land_sf text,
yr_built text,
yr_remod text,
gross_area text,
living_area text,
num_floors text,
structure_class text,
r_bldg_styl text,
r_roof_typ text,
r_ext_fin text,
r_total_rms text,
r_bdrms text,
r_full_bth text,
r_half_bth text,
r_bth_style text,
r_bth_style2 text,
r_bth_style3 text,
r_kitch text,
r_kitch_style text,
r_kitch_style2 text,
r_kitch_style3 text,
r_heat_typ text,
r_ac text,
r_fplace text,
r_ext_cnd text,
r_ovrall_cnd text,
r_int_cnd text,
r_int_fin text,
r_view text,
s_num_bldg text,
s_bldg_styl text,
s_unit_res text,
s_unit_com text,
s_unit_rc text,
s_ext_fin text,
s_ext_cnd text,
u_base_floor text,
u_num_park text,
u_corner text,
u_orient text,
u_tot_rms text,
u_bdrms text,
u_full_bth text,
u_half_bth text,
u_bth_style text,
u_bth_style2 text,
u_bth_style3 text,
u_kitch_type text,
u_kitch_style text,
u_heat_typ text,
u_ac text,
u_fplace text,
u_int_fin text,
u_int_cnd text,
u_view text
);

copy property from '/Users/kellyduncan/GasBuddy/property-assessment-fy2017.csv' delimiter ',' csv header;