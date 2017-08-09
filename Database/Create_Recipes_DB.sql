/* - Create Recipes DB and then run the CREATE TABLE and INSERT INTO
statements to generate the recipes tables - */

--Use this to see all tables in all DBs
SELECT * FROM SQLITE_MASTER

--This will generate a DROP TABLE query for each table in all DBs
select 'drop table ' || name || ';'
from sqlite_master
where type = 'table';

/*
drop table Fermentables;
drop table Yeast;
drop table Hops;
drop table Mash;
drop table Chemistry;
drop table Fermentation;
drop table Home;
drop table System;
*/

CREATE TABLE Fermentables(
Recipe varchar,
Ingredient varchar,
Weight_Lbs real,
Percent_Of_Total real
);
INSERT INTO Fermentables VALUES('New','0 - None',0.0,0); -- Need 5


CREATE TABLE Yeast(
Recipe varchar,
Name varchar,
Attenuation real,
ABV real,
OG real,
FG real,
Init_Cells real,
Pitched_Cells real,
Liters_for_Starter real
);
INSERT INTO Yeast VALUES('New','Brewferm Blanche Ale Yeast',76.0,6.6,1.055,1.010,100,150,0.5);


CREATE TABLE Hops(
Recipe varchar,
Name varchar,
Weight_Oz real,
Boil_Time_Min int,
Alpha_Acid_Content real,
Utilization real,
IBU real
);
INSERT INTO Hops VALUES ('New','Admiral',0,0,0,0,0); -- Need 5


CREATE TABLE Mash(
Recipe varchar,
Init_Grain_Temp real,
Infusion_Temp real,
Sacc_Rest_Temp real,
Mash_Duration int,
Mash_Volume_Gal real,
Mash_Thickness real,
Mash_Out_Vol real
);
INSERT INTO Mash VALUES('New',70,165,150,60,0,1.25,0);


CREATE TABLE Chemistry(
Recipe varchar,
Init_Ca real,
Init_Mg real,
Init_Na real,
Init_Cl real,
Init_SO4 real,
Init_HCO3_CaCO3 real,
Actual_pH real,
Effective_Alkalinity real,
Residual_Alkalinity real,
pH_DOWN_Gypsum_CaSO4 real,
pH_DOWN_Cal_Chl_CaCl2 real,
pH_DOWN_Epsom_Salt_MgSO4 real,
pH_UP_Slaked_Lime_CaOH2 real,
pH_UP_Baking_Soda_NaHCO3 real,
pH_UP_Chalk_CaCO3 real
);
INSERT INTO Chemistry VALUES('New',4,1,32,27,6,40,5.5,-150,-200,5.5,5.5,5.5,0,0,0);


CREATE TABLE Fermentation(
Recipe varchar,
Days1 Int,Temp1 Int,
Days2 Int,Temp2 Int,
Days3 Int,Temp3 Int,
Days4 Int,Temp4 Int,
Days5 Int,Temp5 Int
);

INSERT INTO Fermentation VALUES('Template',5,65,5,65,5,65,5,65,5,65);

CREATE TABLE Water(
Recipe varchar,
Mash_Thickness real,
Grain_Abs_Factor real,
);
INSERT INTO Water VALUES('New',5,0);


CREATE TABLE System(
Recipe varchar,
Batch_Size real,
Boil_Time Int,
Evap_Rate Int,
Shrinkage Int,
Efficiency Int,
Boil_Kettle_Dead_Space_Gal real,
Lauter_Tun_Dead_Space_Gal real,
Mash_Tun_Dead_Space_Gal real,
Fermentation_Tank_Loss_Gal real
);
INSERT INTO System VALUES('New',5,0,0,4,73.5,0,0.25,0,0);


# save and delete
INSERT INTO Chemistry VALUES('New',4,1,32,27,6,40,5.5,-150,-200,5.5,0,0,0,0,0);
INSERT INTO Fermentables VALUES('New','0 - None',0.0,0); -- Need 5
INSERT INTO Fermentation VALUES('New',0);
INSERT INTO Yeast VALUES('New','Brewferm Blanche Ale Yeast',76.0,6.6,1.055,1.010,100,150,0.5);
INSERT INTO Hops VALUES ('New','Admiral',0,0,0,0,0); -- Need 5
INSERT INTO Mash VALUES('New',70,165,150,60,0,1.25,0);
INSERT INTO System VALUES('New',5,0,0,4,73.5,0,0.25,0,0);
INSERT INTO Water VALUES('New',5,0);

DELETE FROM Chemistry WHERE Recipe = 'New';
DELETE FROM Fermentables WHERE Recipe = 'New';
DELETE FROM Fermentation WHERE Recipe = 'New';
DELETE FROM Yeast WHERE Recipe = 'New';
DELETE FROM Hops WHERE Recipe = 'New';
DELETE FROM Mash WHERE Recipe = 'New';
DELETE FROM System WHERE Recipe = 'New';
DELETE FROM Water WHERE Recipe = 'New';

SELECT * FROM Chemistry;
SELECT * FROM Fermentables;
SELECT * FROM Fermentation;
SELECT * FROM Yeast;
SELECT * FROM Hops;
SELECT * FROM Mash;
SELECT * FROM System
SELECT * FROM Water


