/*Data for crime reports here: 
https://data.boston.gov/dataset/crime-incident-reports-august-2015-to-date-source-new-system*/


select * 
from crime
limit 10;

/*
    
https://data.boston.gov/ offers datasets detailing different aspects of the City of Boston. Using the data provided there and other sources as needed: 

Let’s take a look at the crime data and familiarize ourselves with it. A few questions to start with: 
1. How has crime in Boston changed over the last year? Why do you think that is?
*/

select district, year, count(incident_number)
from crime
group by district,/*reporting_area,*/year
order by district, year;

/* A1       | 2015 |  6032
 A1       | 2016 | 11032
 A1       | 2017 |  9303
 A15      | 2015 |  1010
 A15      | 2016 |  1826
 A15      | 2017 |  1661
 A7       | 2015 |  2421
 A7       | 2016 |  4125
 A7       | 2017 |  3528
 B2       | 2015 |  8682
 B2       | 2016 | 15745
 B2       | 2017 | 12970
 B3       | 2015 |  5596
 B3       | 2016 | 11006
 B3       | 2017 |  9050
  C11      | 2015 |  7318
 C11      | 2016 | 13557
 C11      | 2017 | 10994
 C6       | 2015 |  3937
 C6       | 2016 |  7069
 C6       | 2017 |  5994
 D14      | 2015 |  3276
 D14      | 2016 |  6266
 D14      | 2017 |  5359
 D4       | 2015 |  7222
 D4       | 2016 | 12938
 D4       | 2017 | 10987
 E13      | 2015 |  2800
 E13      | 2016 |  5520
 E13      | 2017 |  4527
 E18      | 2015 |  2737
 E18      | 2016 |  5181
 E18      | 2017 |  4540
 E5       | 2015 |  2158
 E5       | 2016 |  4007
 E5       | 2017 |  3483
          | 2015 |   129
          | 2016 |   605
          | 2017 |   475*/

 /*So firest of all it looks like 2015 might not be a complete year, so we are going to check
 when the first case is*/

 select district, min(year||month)
 from crime
 group by district;

 /*
 A1       | 201510
 A15      | 201510
 A7       | 201510
 B2       | 201510
 B3       | 201510
 C11      | 201510
 C6       | 201510
 D14      | 201510
 D4       | 201510
 E13      | 201510
 E18      | 201510
 E5       | 201510
          | 201510
 */

 /*Hence this starts in october of 2015, so we can't check 2015 to the rest, now let's make
 sure we also have all of 2017 to compare correctly to 2016*/

 select district, max(year||month||occurred_on_date)
 from crime
 group by district;

 /*
 A1       | 201792017-09-30 22:04:00
 A15      | 201792017-09-30 22:38:00
 A7       | 201792017-09-30 21:18:00
 B2       | 201792017-09-30 23:15:00
 B3       | 201792017-09-30 23:40:00
 C11      | 201792017-09-30 23:58:00
 C6       | 201792017-09-30 21:13:00
 D14      | 201792017-09-30 21:30:00
 D4       | 201792017-09-30 23:54:00
 E13      | 201792017-09-30 23:30:00
 E18      | 201792017-09-30 14:26:00
 E5       | 201792017-09-30 23:50:00
          | 201792017-09-29 08:00:00
 */

 /* We do not have all of 2017, so we can only look at data from Jan-Sept 2016 to 
 compare to 2017
 because I have my table set up as all text (easier to load data without error),
 this is going to be annoying, so let's create a better table*/

create table crime_pretty as
	select incident_number,
	offense_code,
	offense_code_group,
	offense_description,
	district,
	reporting_area,
	case when shooting ='Y' then 1 else 0 end shooting,
	cast(occurred_on_date as timestamp),
	cast(year as int),
	cast(month as int),
	day_of_week,
	cast(hour as int),
	ucr_part,
	street,
	lat,
	long,
	location
	from crime
;

select district, year, count(incident_number)
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
group by district,/*reporting_area,*/year
order by district, year;

/*

 A1       | 2016 |  8291
 A1       | 2017 |  8494
 A15      | 2016 |  1395
 A15      | 2017 |  1516
 A7       | 2016 |  3147
 A7       | 2017 |  3211
 B2       | 2016 | 11981
 B2       | 2017 | 11916
 B3       | 2016 |  8284
 B3       | 2017 |  8229
 C11      | 2016 | 10282
 C11      | 2017 | 10104
 C6       | 2016 |  5238
 C6       | 2017 |  5442
 D14      | 2016 |  4657
 D14      | 2017 |  4827
 D4       | 2016 |  9633
 D4       | 2017 | 10026
 E13      | 2016 |  4165
 E13      | 2017 |  4142
 E18      | 2016 |  3942
 E18      | 2017 |  4162
 E5       | 2016 |  3051
 E5       | 2017 |  3182
          | 2016 |   433
          | 2017 |   406

*/
/*This really isn't great to compare though, let's make it better*/

select district,
count(case when year = 2016 then incident_number else null end) as incidents_2016,
count(case when year = 2017 then incident_number else null end) as incidents_2017,
count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end) as difference
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
group by district
order by district;

/*
 A1       |           8291 |           8494 |        203
 A15      |           1395 |           1516 |        121
 A7       |           3147 |           3211 |         64
 B2       |          11981 |          11916 |        -65
 B3       |           8284 |           8229 |        -55
 C11      |          10282 |          10104 |       -178
 C6       |           5238 |           5442 |        204
 D14      |           4657 |           4827 |        170
 D4       |           9633 |          10026 |        393
 E13      |           4165 |           4142 |        -23
 E18      |           3942 |           4162 |        220
 E5       |           3051 |           3182 |        131
          |            433 |            406 |        -27
*/

/*Okay so it looks like crim when up in most districts between 2016 and 2017,
let's check by what % over 2016 crime went up
*/

select district,
count(case when year = 2016 then incident_number else null end) as incidents_2016,
count(case when year = 2017 then incident_number else null end) as incidents_2017,
(count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end)) as difference,
(count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end))*100.0/
	count(case when year = 2016 then incident_number else null end) as percent_diff
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
group by district
order by district;

/*
 A1       |           8291 |           8494 |        203 |      2.4484380653720902
 A15      |           1395 |           1516 |        121 |      8.6738351254480287
 A7       |           3147 |           3211 |         64 |      2.0336828725770575
 B2       |          11981 |          11916 |        -65 | -0.54252566563725899341
 B3       |           8284 |           8229 |        -55 | -0.66393046837276677933
 C11      |          10282 |          10104 |       -178 | -1.73118070414316280879
 C6       |           5238 |           5442 |        204 |      3.8946162657502864
 D14      |           4657 |           4827 |        170 |      3.6504187245007516
 D4       |           9633 |          10026 |        393 |      4.0797259420741202
 E13      |           4165 |           4142 |        -23 | -0.55222088835534213685
 E18      |           3942 |           4162 |        220 |      5.5809233891425672
 E5       |           3051 |           3182 |        131 |      4.2936742051786300
          |            433 |            406 |        -27 |     -6.2355658198614319
 */

 /*What type of crime went up though?*/

 select offense_description,
(count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end)) as diff
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
group by offense_description
order by 2 desc
limit 10;

/*
INVESTIGATE PERSON                    | 1741
 TOWED MOTOR VEHICLE                   |  670
 INVESTIGATE PROPERTY                  |  541
 SICK/INJURED/MEDICAL - PERSON         |  523
 M/V ACCIDENT - OTHER                  |  432
 VERBAL DISPUTE                        |  240
 M/V - LEAVING SCENE - PROPERTY DAMAGE |  211
 TRESPASSING                           |  171
 PROPERTY - FOUND                      |  150
 PROPERTY - LOST                       |  150
 */

 /*How about by % difference*/

select offense_description,
(count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end))*100.0/
	case when count(case when year = 2016 then incident_number else null end) = 0 then 1
		else count(case when year = 2016 then incident_number else null end) end,
		count(case when year = 2017 then incident_number else null end)-
		count(case when year = 2016 then incident_number else null end)

	 as diff
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
group by offense_description
order by 2 desc
limit 10;

 /*AIRCRAFT INCIDENTS                         | 500.0000000000000000 |   15
 GAMBLING - BETTING / WAGERING              | 300.0000000000000000 |    3
 CONTRIBUTING TO DELINQUENCY OF MINOR       | 300.0000000000000000 |    3
 DRUGS - CONSP TO VIOL CONTROLLED SUBSTANCE | 209.0909090909090909 |   23
 CUSTODIAL KIDNAPPING                       | 200.0000000000000000 |    2
 HUMAN TRAFFICKING - COMMERCIAL SEX ACTS    | 150.0000000000000000 |    3
 KIDNAPPING/CUSTODIAL KIDNAPPING            | 125.0000000000000000 |   10
 PRISONER ESCAPE / ESCAPE & RECAPTURE       | 100.0000000000000000 |    1
 DRUGS - CLASS D TRAFFICKING OVER 50 GRAMS  | 100.0000000000000000 |    1
 PROSTITUTION - COMMON NIGHTWALKER          | 100.0000000000000000 |    1
 */

 /*Interesting there was a huge increase in aircraft incidents, now let's
 only look at things with 10 and over in difference.*/

 select offense_description,
(count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end))*100.0/
	case when count(case when year = 2016 then incident_number else null end) = 0 then 1
		else count(case when year = 2016 then incident_number else null end) end,
		count(case when year = 2017 then incident_number else null end)-
		count(case when year = 2016 then incident_number else null end)

	 as diff
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
group by offense_description
having count(case when year = 2017 then incident_number else null end)-
		count(case when year = 2016 then incident_number else null end) >=10
order by 2 desc
limit 10;

 /*AIRCRAFT INCIDENTS                             | 500.0000000000000000 |   15
 DRUGS - CONSP TO VIOL CONTROLLED SUBSTANCE     | 209.0909090909090909 |   23
 KIDNAPPING/CUSTODIAL KIDNAPPING                | 125.0000000000000000 |   10
 HARBOR INCIDENT / VIOLATION                    |  88.8888888888888889 |   40
 M/V ACCIDENT - OTHER                           |  87.4493927125506073 |  432
 PROPERTY - STOLEN THEN RECOVERED               |  70.2380952380952381 |   59
 DRUGS - CLASS B TRAFFICKING OVER 18 GRAMS      |  67.7419354838709677 |   21
 DRUGS - POSS CLASS C - INTENT TO MFR DIST DISP |  64.4444444444444444 |   29
 FIRE REPORT/ALARM - FALSE                      |  61.9047619047619048 |   13
 ROBBERY - COMMERCIAL                           |  60.6741573033707865 |   54*/

 /*So it looks like there were a lot more Motor Vechile Accidents, lets now look at over
 100*/
 select offense_description,
(count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end))*100.0/
	case when count(case when year = 2016 then incident_number else null end) = 0 then 1
		else count(case when year = 2016 then incident_number else null end) end,
		count(case when year = 2017 then incident_number else null end)-
		count(case when year = 2016 then incident_number else null end)

	 as diff
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
group by offense_description
having count(case when year = 2017 then incident_number else null end)-
		count(case when year = 2016 then incident_number else null end) >=100
order by 2 desc
limit 10;

/*
M/V ACCIDENT - OTHER           | 87.4493927125506073 |  432
 INVESTIGATE PERSON             | 42.6611124724332272 | 1741
 TOWED MOTOR VEHICLE            | 28.6937901498929336 |  670
 TRESPASSING                    | 23.1081081081081081 |  171
 INVESTIGATE PROPERTY           | 22.2908941079522044 |  541
 PROPERTY - FOUND               | 19.6850393700787402 |  150
 SICK/INJURED/MEDICAL - PERSON  | 12.6603727910917453 |  523
 M/V ACCIDENT - PERSONAL INJURY | 12.4448367166813769 |  141
 LARCENY ALL OTHERS             |  8.8989441930618401 |  118
 VERBAL DISPUTE                 |  7.7896786757546251 |  240
*/

/*In bad news, we towed and investigated people at lot more in Boston, in 
good news, we found a lot more property! Over all there wasn't a increase that much 
in violent crime though, maybe we should figure out what violent crime means*/

/*The FBI Defines Violent Crime as:
In the FBI’s Uniform Crime Reporting (UCR) Program, 
violent crime is composed of four offenses: 
murder and nonnegligent manslaughter, forcible rape, robbery, and aggravated assault. 
Violent crimes are defined in the UCR Program 
as those offenses which involve force or threat of force.

For this I am going to say, that those + kidnapping are violent crime. 

interesting Looking through offense descriptions I could not find no trafficking/prostitution
sex crimes or rape:
*/

select * from crime_pretty 
where offense_description like '%sex%' 
	or offense_description like '%rape%'
/*So what I could find (decided to add Burgarly forced):*/

select offense_description,
count(case when year = 2016 then incident_number else null end),
count(case when year = 2017 then incident_number else null end),
(count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end))*100.0/
	case when count(case when year = 2016 then incident_number else null end) = 0 then 1
		else count(case when year = 2016 then incident_number else null end) end,
		count(case when year = 2017 then incident_number else null end)-
		count(case when year = 2016 then incident_number else null end)

	 as diff
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
	and offense_description in ('ASSAULT SIMPLE - BATTERY','BURGLARY - RESIDENTIAL - FORCE',
		'BURGLARY - COMMERICAL - FORCE','ASSAULT - AGGRAVATED - BATTERY','ASSAULT - AGGRAVATED',
		'MURDER, NON-NEGLIGIENT MANSLAUGHTER','KIDNAPPING/CUSTODIAL KIDNAPPING',
		'HUMAN TRAFFICKING - COMMERCIAL SEX ACTS','HUMAN TRAFFICKING - INVOLUNTARY SERVITUDE',
		'ASSAULT & BATTERY D/W - OTHER','ASSAULT D/W - KNIFE ON POLICE OFFICER')
group by offense_description
order by 2 desc
--limit 10
;
/*
ASSAULT SIMPLE - BATTERY                  |  3339 |  3348 | 0.26954177897574123989 |    9
 ASSAULT - AGGRAVATED - BATTERY            |  1122 |  1182 |     5.3475935828877005 |   60
 ASSAULT - AGGRAVATED                      |   684 |   641 |    -6.2865497076023392 |  -43
 BURGLARY - RESIDENTIAL - FORCE            |   621 |   588 |    -5.3140096618357488 |  -33
 BURGLARY - COMMERICAL - FORCE             |   184 |   254 |    38.0434782608695652 |   70
 MURDER, NON-NEGLIGIENT MANSLAUGHTER       |    30 |    41 |    36.6666666666666667 |   11
 KIDNAPPING/CUSTODIAL KIDNAPPING           |     8 |    18 |   125.0000000000000000 |   10
 HUMAN TRAFFICKING - COMMERCIAL SEX ACTS   |     2 |     5 |   150.0000000000000000 |    3
 ASSAULT & BATTERY D/W - OTHER             |     2 |     0 |  -100.0000000000000000 |   -2
 HUMAN TRAFFICKING - INVOLUNTARY SERVITUDE |     1 |     1 | 0.00000000000000000000 |    0
 */

 /*Now without the group by (aka all together)*/
 select
count(case when year = 2016 then incident_number else null end),
count(case when year = 2017 then incident_number else null end),
(count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end))*100.0/
	case when count(case when year = 2016 then incident_number else null end) = 0 then 1
		else count(case when year = 2016 then incident_number else null end) end,
		count(case when year = 2017 then incident_number else null end)-
		count(case when year = 2016 then incident_number else null end)

	 as diff
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
	and offense_description in ('ASSAULT SIMPLE - BATTERY','BURGLARY - RESIDENTIAL - FORCE',
		'BURGLARY - COMMERICAL - FORCE','ASSAULT - AGGRAVATED - BATTERY','ASSAULT - AGGRAVATED',
		'MURDER, NON-NEGLIGIENT MANSLAUGHTER','KIDNAPPING/CUSTODIAL KIDNAPPING',
		'HUMAN TRAFFICKING - COMMERCIAL SEX ACTS','HUMAN TRAFFICKING - INVOLUNTARY SERVITUDE',
		'ASSAULT & BATTERY D/W - OTHER','ASSAULT D/W - KNIFE ON POLICE OFFICER')
--group by offense_description
--order by 2 desc
;

--5993 |  6078 | 1.4183213749374270 |   85

/*Overall there was a 1.4% increase in violent crime, mostly coming from aggravated assalt
	& battery, and commerical robberies.  
*/



/*2. What type of crime is most common? Has that changed? Why?*/

select offense_description,
count(case when year = 2016 then incident_number else null end),
count(case when year = 2017 then incident_number else null end),
count(case when year = 2016 then incident_number else null end)-
	count(case when year = 2017 then incident_number else null end)
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
group by offense_description
order by 2 desc
limit 10;

/*
 SICK/INJURED/MEDICAL - PERSON         |  4131 |  4654 |     -523
 INVESTIGATE PERSON                    |  4081 |  5822 |    -1741
 VANDALISM                             |  3780 |  3695 |       85
 M/V - LEAVING SCENE - PROPERTY DAMAGE |  3771 |  3982 |     -211
 ASSAULT SIMPLE - BATTERY              |  3339 |  3348 |       -9
 VERBAL DISPUTE                        |  3081 |  3321 |     -240
 INVESTIGATE PROPERTY                  |  2427 |  2968 |     -541
 TOWED MOTOR VEHICLE                   |  2335 |  3005 |     -670
 LARCENY THEFT FROM MV - NON-ACCESSORY |  2157 |  2008 |      149
 THREATS TO DO BODILY HARM             |  2138 |  1971 |      167
 */

 /*In 2016 the top crime was Vandalism, and there was a slight decrease in 2017*/

select offense_description,
count(case when year = 2017 then incident_number else null end),
count(case when year = 2016 then incident_number else null end),
count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end)
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
group by offense_description
order by 2 desc
limit 10;
/*
 INVESTIGATE PERSON                    |  5822 |  4081 |     1741
 SICK/INJURED/MEDICAL - PERSON         |  4654 |  4131 |      523
 M/V - LEAVING SCENE - PROPERTY DAMAGE |  3982 |  3771 |      211
 VANDALISM                             |  3695 |  3780 |      -85
 ASSAULT SIMPLE - BATTERY              |  3348 |  3339 |        9
 VERBAL DISPUTE                        |  3321 |  3081 |      240
 TOWED MOTOR VEHICLE                   |  3005 |  2335 |      670
 INVESTIGATE PROPERTY                  |  2968 |  2427 |      541
 PROPERTY - LOST                       |  2103 |  1953 |      150
 WARRANT ARREST                        |  2084 |  2006 |       78
*/

/*In 2017 we investigated more people, and also had more Motor Vechile Property damage.

From these numbers I can not tell you why things went up, it looks like in general 
we got more paranoid though.  Some of this could be survivors bias, where they 
are more likely to report this year then last year, or there could have been more
outreach by police to report certain types of crime.*/



/*
3. Are certain neighborhoods more or less crime-prone? Why do you think that is?
*/

/*Let's play with shooting here, what areas is one most likely to get shot, and
break it down not only to district by reporting_area?*/
select district, reporting_area,
	count(case when year = 2017 then shooting else null end),
count(case when year = 2016 then shooting else null end),
count(case when year = 2017 then shooting else null end)-
	count(case when year = 2016 then shooting else null end)
from crime_pretty
group by 1,2
order by 1,2;

/*
A1       |                |  1148 |  1134 |       14
 A1       | 000            |     0 |     0 |        0
 A1       | 100            |    76 |   147 |      -71
 A1       | 101            |   134 |   160 |      -26
 A1       | 102            |   329 |   348 |      -19
 A1       | 103            |   134 |   174 |      -40
 A1       | 104            |    83 |    95 |      -12
 A1       | 105            |   244 |   296 |      -52
 A1       | 106            |    58 |    85 |      -27
 A1       | 107            |    25 |    31 |       -6
 A1       | 108            |    78 |    62 |       16
 A1       | 109            |    77 |   117 |      -40
 A1       | 110            |    30 |    36 |       -6
 A1       | 111            |   538 |   669 |     -131
 A1       | 112            |   299 |   364 |      -65
 A1       | 113            |   188 |   158 |       30
 A1       | 114            |    61 |    77 |      -16
 A1       | 115            |   121 |   207 |      -86
 A1       | 116            |   232 |   327 |      -95
 A1       | 117            |   432 |   582 |     -150
 A1       | 118            |    96 |   159 |      -63
 A1       | 119            |   231 |   270 |      -39
 A1       | 120            |   139 |   311 |     -172
 A1       | 121            |   150 |   136 |       14
 A1       | 122            |    60 |   110 |      -50
 A1       | 123            |   148 |   269 |     -121
 A1       | 124            |   130 |   167 |      -37
 A1       | 125            |    87 |   114 |      -27
 A1       | 126            |    27 |    53 |      -26
 A1       | 127            |    72 |    81 |       -9
 A1       | 128            |    67 |    37 |       30
 A1       | 131            |     1 |     1 |        0
 A1       | 133            |     1 |     0 |        1
 A1       | 134            |     1 |     0 |        1
 A1       | 142            |     0 |     1 |       -1
 A1       | 146            |     0 |     1 |       -1
 A1       | 161            |     0 |     8 |       -8
 A1       | 162            |     9 |     9 |        0
 A1       | 165            |    58 |     2 |       56
 A1       | 171            |     1 |     0 |        1
 A1       | 173            |    94 |    89 |        5
 A1       | 175            |     0 |     0 |        0
 A1       | 176            |     0 |     0 |        0
 A1       | 178            |     0 |     1 |       -1
 A1       | 200            |     0 |     1 |       -1
 A1       | 201            |     2 |     0 |        2
 A1       | 206            |     0 |     1 |       -1
 A1       | 207            |     8 |    13 |       -5
 A1       | 265            |     1 |     1 |        0
 A1       | 307            |     0 |     0 |        0
 A1       | 338            |     1 |     0 |        1
 A1       | 339            |     0 |     1 |       -1
 A1       | 347            |     4 |     5 |       -1
 A1       | 356            |     1 |     1 |        0
 A1       | 358            |     1 |     0 |        1
 A1       | 364            |     2 |     0 |        2
 A1       | 41             |     0 |     1 |       -1
 A1       | 459            |     0 |     1 |       -1
 A1       | 462            |    22 |     1 |       21
 A1       | 540            |     0 |     0 |        0
 A1       | 58             |     0 |     0 |        0
 A1       | 587            |     0 |     0 |        0
 A1       | 61             |   226 |   236 |      -10
 A1       | 610            |     1 |     0 |        1
 A1       | 62             |    22 |    30 |       -8

 ...


 Okay so maybe I over specified this for right now, let's just go back to police districts*/


select district,
	sum(case when year = 2017 then shooting else null end),
sum(case when year = 2016 then shooting else null end),
sum(case when year = 2017 then shooting else null end)-
	sum(case when year = 2016 then shooting else null end)
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
group by 1
order by 1;
 
 /*
 A1       |   6 |   1 |        5
 A15      |   1 |   1 |        0
 A7       |   0 |   5 |       -5
 B2       |  71 |  60 |       11
 B3       |  66 |  55 |       11
 C11      |  74 |  33 |       41
 C6       |   6 |   7 |       -1
 D14      |   0 |   3 |       -3
 D4       |  11 |   4 |        7
 E13      |  13 |  11 |        2
 E18      |   7 |   6 |        1
 E5       |   1 |   1 |        0
          |   0 |   0 |        0
*/

/*So it looks like there are places with higher number of shootings, but are those also
the places with the highest numbers of "crimes" in general"*/

select district,
	sum(case when year = 2017 then shooting else null end)*100.0/
	count(case when year = 2017 then incident_number else null end),
sum(case when year = 2016 then shooting else null end)*100.0/
	count(case when year = 2016 then incident_number else null end),
sum(case when year = 2017 then shooting else null end)-
	sum(case when year = 2016 then shooting else null end)
from crime_pretty_2
where month between 1 and 9 and year in (2017, 2016)
group by 1
order by 1;

/*
 A1       | 0.07063809748057452319 | 0.01206127125799059221 |        5
 A15      | 0.06596306068601583113 | 0.07168458781362007168 |        0
 A7       | 0.00000000000000000000 | 0.15888147442008261837 |       -5
 B2       | 0.59583752937227257469 | 0.50079292212670060930 |       11
 B3       | 0.80204156033539919796 | 0.66393046837276677933 |       11
 C11      | 0.73238321456848772763 | 0.32094923166699085781 |       41
 C6       | 0.11025358324145534730 | 0.13363879343260786560 |       -1
 D14      | 0.00000000000000000000 | 0.06441915396177796865 |       -3
 D4       | 0.10971474167165370038 | 0.04152392816360427696 |        7
 E13      | 0.31385803959439884114 | 0.26410564225690276110 |        2
 E18      | 0.16818837097549255166 | 0.15220700152207001522 |        1
 E5       | 0.03142677561282212445 | 0.03277613897082923632 |        0
          | 0.00000000000000000000 | 0.00000000000000000000 |        0
 */

/*So not only are there more shootings in distrinct B2, B3, and C11, there are more
shootings for average number of crimes there (and they all went up in 2017, which is
interesting)

Hence for shootings, I think certain areas one is more likely to see a shooting, but 
becuase we really don't know the std deviation, it would be hard to create a 
statistical test for this*/

 select district,
count(case when year = 2016 then incident_number else null end),
count(case when year = 2017 then incident_number else null end),
(count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end))*100.0/
	case when count(case when year = 2016 then incident_number else null end) = 0 then 1
		else count(case when year = 2016 then incident_number else null end) end,
		count(case when year = 2017 then incident_number else null end)-
		count(case when year = 2016 then incident_number else null end)

	 as diff
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
	and offense_description in ('ASSAULT SIMPLE - BATTERY','BURGLARY - RESIDENTIAL - FORCE',
		'BURGLARY - COMMERICAL - FORCE','ASSAULT - AGGRAVATED - BATTERY','ASSAULT - AGGRAVATED',
		'MURDER, NON-NEGLIGIENT MANSLAUGHTER','KIDNAPPING/CUSTODIAL KIDNAPPING',
		'HUMAN TRAFFICKING - COMMERCIAL SEX ACTS','HUMAN TRAFFICKING - INVOLUNTARY SERVITUDE',
		'ASSAULT & BATTERY D/W - OTHER','ASSAULT D/W - KNIFE ON POLICE OFFICER')
group by district
order by 1
;

/*
A1       |   679 |   768 |     13.1075110456553756 |   89
 A15      |    78 |   107 |     37.1794871794871795 |   29
 A7       |   278 |   265 |     -4.6762589928057554 |  -13
 B2       |  1059 |  1050 | -0.84985835694050991501 |   -9
 B3       |   793 |   750 |     -5.4224464060529634 |  -43
 C11      |   877 |   879 |  0.22805017103762827822 |    2
 C6       |   369 |   411 |     11.3821138211382114 |   42
 D14      |   342 |   316 |     -7.6023391812865497 |  -26
 D4       |   735 |   770 |      4.7619047619047619 |   35
 E13      |   285 |   311 |      9.1228070175438596 |   26
 E18      |   294 |   266 |     -9.5238095238095238 |  -28
 E5       |   181 |   174 |     -3.8674033149171271 |   -7
          |    23 |    11 |    -52.1739130434782609 |  -12
*/

/*In terms of violent crime in general, b2 seems to have the most, with B11 and B3 
following close behind, hence these areas probably are more crime prone (but I should
look at how big these areas are, because maybe B2,B3, and C11 just cover more area)
*/

/*Looking at the KML file in Google earth (I really didn't have time to install any
GIS programs and remember how to use them at this time, though I have used multiple
GIS programs in the past, just not recently), B2 covers Roxbury/Mission Hill, C11 Covers
Dorchester, and B3 Covers Mattapan areas, all areas where if you read the news, there 
are more shootings.  Interseting though D4 covers Back Bay and the South End, where one
does not hear about shootings in the news that often in those neighborhoods.

KML File From: https://data.boston.gov/dataset/police-districts
*/



/*
4. Does day/hour of the week make a difference? Why?
*/
select day_of_week,-- hour,
count(case when year = 2016 then incident_number else null end),
count(case when year = 2017 then incident_number else null end),
(count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end))*100.0/
	case when count(case when year = 2016 then incident_number else null end) = 0 then 1
		else count(case when year = 2016 then incident_number else null end) end,
		count(case when year = 2017 then incident_number else null end)-
		count(case when year = 2016 then incident_number else null end)

	 as diff
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
	and offense_description in ('ASSAULT SIMPLE - BATTERY','BURGLARY - RESIDENTIAL - FORCE',
		'BURGLARY - COMMERICAL - FORCE','ASSAULT - AGGRAVATED - BATTERY','ASSAULT - AGGRAVATED',
		'MURDER, NON-NEGLIGIENT MANSLAUGHTER','KIDNAPPING/CUSTODIAL KIDNAPPING',
		'HUMAN TRAFFICKING - COMMERCIAL SEX ACTS','HUMAN TRAFFICKING - INVOLUNTARY SERVITUDE',
		'ASSAULT & BATTERY D/W - OTHER','ASSAULT D/W - KNIFE ON POLICE OFFICER')
group by 1--,2
order by 1--,2
;

/*

 Monday      |   779 |   808 |      3.7227214377406932 |   29
 Tuesday     |   814 |   865 |      6.2653562653562654 |   51
 Wednesday   |   788 |   835 |      5.9644670050761421 |   47
 Thursday    |   846 |   841 | -0.59101654846335697400 |   -5
 Friday      |   963 |   872 |     -9.4496365524402908 |  -91
 Saturday    |   882 |   917 |      3.9682539682539683 |   35
 Sunday      |   921 |   940 |      2.0629750271444083 |   19
*/

/*For violent crime, it seems that in 2016 there were more day of week differences
then in 2017, in 2017, it looks like Weekends were the days to commit crimes*/

--For all reporting:
select day_of_week,-- hour,
count(case when year = 2016 then incident_number else null end),
count(case when year = 2017 then incident_number else null end),
(count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end))*100.0/
	case when count(case when year = 2016 then incident_number else null end) = 0 then 1
		else count(case when year = 2016 then incident_number else null end) end,
		count(case when year = 2017 then incident_number else null end)-
		count(case when year = 2016 then incident_number else null end)

	 as diff
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
group by 1--,2
order by 1--,2


/*
 Monday      | 10667 | 10772 | 0.98434423924252367114 |  105
 Tuesday     | 10797 | 10820 | 0.21302213577845697879 |   23
 Wednesday   | 10832 | 11172 |     3.1388478581979321 |  340
 Thursday    | 10865 | 11171 |     2.8163828808099402 |  306
 Friday      | 11475 | 11546 | 0.61873638344226579521 |   71
 Saturday    | 10335 | 10644 |     2.9898403483309144 |  309
 Sunday      |  9528 |  9532 | 0.04198152812762384551 |    4
 */

 /*People seem to like to report crimes mostly in the middle of the week.  So violent 
 crimes on weekend but majority of crimes in the middle of the week, let's look at 
 time of day*/

select --day_of_week,
 hour,
count(case when year = 2016 then incident_number else null end),
count(case when year = 2017 then incident_number else null end),
(count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end))*100.0/
	case when count(case when year = 2016 then incident_number else null end) = 0 then 1
		else count(case when year = 2016 then incident_number else null end) end,
		count(case when year = 2017 then incident_number else null end)-
		count(case when year = 2016 then incident_number else null end)

	 as diff
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
	and offense_description in ('ASSAULT SIMPLE - BATTERY','BURGLARY - RESIDENTIAL - FORCE',
		'BURGLARY - COMMERICAL - FORCE','ASSAULT - AGGRAVATED - BATTERY','ASSAULT - AGGRAVATED',
		'MURDER, NON-NEGLIGIENT MANSLAUGHTER','KIDNAPPING/CUSTODIAL KIDNAPPING',
		'HUMAN TRAFFICKING - COMMERCIAL SEX ACTS','HUMAN TRAFFICKING - INVOLUNTARY SERVITUDE',
		'ASSAULT & BATTERY D/W - OTHER','ASSAULT D/W - KNIFE ON POLICE OFFICER')
group by 1--,2
order by 1--,2
;
 
/*
    0 |   310 |   318 |   2.5806451612903226 |    8
    1 |   254 |   268 |   5.5118110236220472 |   14
    2 |   252 |   284 |  12.6984126984126984 |   32
    3 |   126 |   129 |   2.3809523809523810 |    3
    4 |    94 |   108 |  14.8936170212765957 |   14
    5 |    70 |    69 |  -1.4285714285714286 |   -1
    6 |    85 |    82 |  -3.5294117647058824 |   -3
    7 |   128 |   134 |   4.6875000000000000 |    6
    8 |   182 |   185 |   1.6483516483516484 |    3
    9 |   197 |   217 |  10.1522842639593909 |   20
   10 |   231 |   201 | -12.9870129870129870 |  -30
   11 |   292 |   231 | -20.8904109589041096 |  -61
   12 |   294 |   275 |  -6.4625850340136054 |  -19
   13 |   267 |   304 |  13.8576779026217228 |   37
   14 |   300 |   277 |  -7.6666666666666667 |  -23
   15 |   298 |   332 |  11.4093959731543624 |   34
   16 |   346 |   360 |   4.0462427745664740 |   14
   17 |   318 |   397 |  24.8427672955974843 |   79
   18 |   371 |   366 |  -1.3477088948787062 |   -5
   19 |   350 |   344 |  -1.7142857142857143 |   -6
   20 |   315 |   336 |   6.6666666666666667 |   21
   21 |   312 |   323 |   3.5256410256410256 |   11
   22 |   293 |   290 |  -1.0238907849829352 |   -3
   23 |   308 |   248 | -19.4805194805194805 |  -60
/*Between 3 and 8 the least number of violent crimes are being reported, while
the most seem to be between 1 and 9 and the midnight hour*/

select --day_of_week,
 hour,
count(case when year = 2016 then incident_number else null end),
count(case when year = 2017 then incident_number else null end),
(count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end))*100.0/
	case when count(case when year = 2016 then incident_number else null end) = 0 then 1
		else count(case when year = 2016 then incident_number else null end) end,
		count(case when year = 2017 then incident_number else null end)-
		count(case when year = 2016 then incident_number else null end)

	 as diff
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
group by 1--,2
order by 1--,2
;

/*
    0 |  3382 |  3396 |  0.41395623891188645772 |   14
    1 |  2184 |  2140 |     -2.0146520146520147 |  -44
    2 |  1865 |  1819 |     -2.4664879356568365 |  -46
    3 |  1105 |  1131 |      2.3529411764705882 |   26
    4 |   793 |   792 | -0.12610340479192938209 |   -1
    5 |   761 |   786 |      3.2851511169513798 |   25
    6 |  1145 |  1180 |      3.0567685589519651 |   35
    7 |  2025 |  2127 |      5.0370370370370370 |  102
    8 |  3059 |  3084 |  0.81726054266100032690 |   25
    9 |  3381 |  3465 |      2.4844720496894410 |   84
   10 |  3854 |  3805 |     -1.2714063310845874 |  -49
   11 |  3769 |  3813 |      1.1674184133722473 |   44
   12 |  4259 |  4368 |      2.5592862174219300 |  109
   13 |  3888 |  3965 |      1.9804526748971193 |   77
   14 |  3961 |  3938 | -0.58066144912900782631 |  -23
   15 |  3767 |  4077 |      8.2293602336076453 |  310
   16 |  4571 |  4904 |      7.2850579741850799 |  333
   17 |  4846 |  5059 |      4.3953776310359059 |  213
   18 |  4892 |  4829 |     -1.2878168438266558 |  -63
   19 |  4318 |  4217 |     -2.3390458545622974 | -101
   20 |  3719 |  3721 |  0.05377789728421618715 |    2
   21 |  3344 |  3481 |      4.0968899521531100 |  137
   22 |  3106 |  3078 | -0.90148100450740502254 |  -28
   23 |  2505 |  2482 | -0.91816367265469061876 |  -23
 */

/*For all repors lunch hour, and 4-7 pm (or times people have lunch, and evening rush
hour/when people get home), have the most reports; but people are more likely to put
off reporting non-violent crime most likely until they have time to report it correctly
most likely*/

/*
5. Given recent trends, if the City were to open one additional police station next year, 
where would you locate it and what type of crime would it specialize in? 
Requires an additional data set. 
*/
select district, offense_description,
count(case when year = 2017 then incident_number else null end),
count(case when year = 2016 then incident_number else null end),
count(case when year = 2017 then incident_number else null end)-
	count(case when year = 2016 then incident_number else null end)
from crime_pretty
where month between 1 and 9 and year in (2017, 2016)
group by 1,2
order by 3 desc
limit 10;

/*

 B2       | INVESTIGATE PERSON                    |   830 |   612 |      218
 C11      | INVESTIGATE PERSON                    |   822 |   646 |      176
 B2       | VERBAL DISPUTE                        |   805 |   713 |       92
 B3       | VERBAL DISPUTE                        |   778 |   691 |       87
 B3       | INVESTIGATE PERSON                    |   773 |   542 |      231
 D4       | LARCENY SHOPLIFTING                   |   734 |   798 |      -64
 B2       | SICK/INJURED/MEDICAL - PERSON         |   732 |   625 |      107
 B2       | M/V - LEAVING SCENE - PROPERTY DAMAGE |   688 |   663 |       25
 C11      | VERBAL DISPUTE                        |   683 |   651 |       32
 C11      | M/V - LEAVING SCENE - PROPERTY DAMAGE |   662 |   648 |       14

 */

 /*If it were up to me, I like opening a police station around Newbury/Prudential that
 specializes in Larceny Shoplifiting (also as someone who got my purse stolen at
 BPL Main Branch, I would have also like a closer police station to report that too,
 getting down to Harrison Ave from Copley is not fun).  In terms of the data, Putting
 a police station between B2, B3, and C11, that has lots of consoulers to deal with 
 verbal disputes might be very helpful though*/
 

/*
6. Suppose you were given a budget of $500,000 to buy property and move into Boston. 
Which is the safest neighborhood to settle down in? 
What if you had $1M? 
Requires an additional data set. 
*/



*/