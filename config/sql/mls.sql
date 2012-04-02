CREATE TABLE IF NOT EXISTS data (
  col1 INTEGER PRIMARY KEY,
  col2 varchar(200) NOT NULL,
  col3 varchar(100) NOT NULL,
  col4 varchar(200) NOT NULL,
  col5 double NOT NULL,
  col6 double NOT NULL
);

CREATE TABLE IF NOT EXISTS data_column_description (
  id INTEGER PRIMARY KEY,
  col_name varchar(200) NOT NULL,
  col_type varchar(50) NOT NULL, 
  match_level INTEGER NOT NULL
);

INSERT INTO data_column_description (id, col_name, col_type, match_level) VALUES (1, 'Id', 'id', 0);
INSERT INTO data_column_description (id, col_name, col_type, match_level) VALUES (2, 'Team Name', 'sports', 1);
INSERT INTO data_column_description (id, col_name, col_type, match_level) VALUES (3, 'League', 'data', 2);
INSERT INTO data_column_description (id, col_name, col_type, match_level) VALUES (4, 'Stadium', 'data', 2);
INSERT INTO data_column_description (id, col_name, col_type, match_level) VALUES (5, 'Latitude', 'latitude', 2);
INSERT INTO data_column_description (id, col_name, col_type, match_level) VALUES (6, 'Longitude', 'longitude', 2);

CREATE TABLE IF NOT EXISTS alias (
  id INTEGER PRIMARY KEY,
  data_id INTEGER NOT NULL,
  alias_name varchar(200) NOT NULL,
  FOREIGN KEY (data_id) REFERENCES data(id)
);

CREATE TABLE IF NOT EXISTS description (
  name varchar(200) NOT NULL,
  description varchar(200) NOT NULL
);

INSERT INTO description (name, description) VALUES ('data', 'Contains: MLS Teams as of 2011-2012 Season');

INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Chicago Fire', 'MLS', 'Toyota Park', '41.764722', '-87.806111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Columbus Crew', 'MLS', 'Columbus Crew Stadium', '40.009444', '-82.991111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('D.C. United', 'MLS', 'RFK Stadium', '38.889722', '-76.971667');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Houston Dynamo', 'MLS', 'Robertson Stadium', '29.721944', '-95.349167');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Montreal Impact', 'MLS', 'Saputo Stadium', '45.5631', '-73.5526');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New England Revolution', 'MLS', 'Gillette Stadium', '42.090944', '-71.264344');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New York Red Bulls', 'MLS', 'Red Bull Arena', '40.737031', '-74.15023');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Philadelphia Union', 'MLS', 'PPL Park', '39.83287', '-75.378401');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Sporting Kansas City', 'MLS', 'Livestrong Sporting Park', '39.1218', '-94.8237');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Toronto FC', 'MLS', 'BMO Field', '43.632778', '-79.418611');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Club Deportivo Chivas USA', 'MLS', 'The Home Depot Center', '33.864444', '-118.261111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Colorado Rapids', 'MLS', 'Dick''s Sporting Goods Park', '39.805556', '-104.891944');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('FC Dallas', 'MLS', 'Pizza Hut Park', '33.154444', '-96.835278');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Los Angeles Galaxy', 'MLS', 'The Home Depot Center', '33.864444', '-118.261111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Portland Timbers', 'MLS', 'Jeld-Wen Field', '45.521389', '-122.691667');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Real Salt Lake', 'MLS', 'Rio Tinto Stadium', '40.582923', '-111.893156');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('San Jose Earthquakes', 'MLS', 'Buck Shaw Stadium', '37.350556', '-121.936667');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Seattle Sounders FC', 'MLS', 'Qwest Field', '47.595278', '-122.331667');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Vancouver Whitecaps FC', 'MLS', 'BC Place Stadium', '49.276667', '-123.111944');

INSERT INTO alias (data_id, alias_name) VALUES (1, 'The Fire');
INSERT INTO alias (data_id, alias_name) VALUES (1, 'La Maquina Roja');
INSERT INTO alias (data_id, alias_name) VALUES (1, 'Men in Red');
INSERT INTO alias (data_id, alias_name) VALUES (1, 'CF97');
INSERT INTO alias (data_id, alias_name) VALUES (1, 'Strazacy');
INSERT INTO alias (data_id, alias_name) VALUES (1, 'Firemen');
INSERT INTO alias (data_id, alias_name) VALUES (2, 'The Massive');
INSERT INTO alias (data_id, alias_name) VALUES (2, 'The Crew');
INSERT INTO alias (data_id, alias_name) VALUES (2, 'America''s Hardest Working Team');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'United');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'DCU');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'Black-and-Red');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'Dynamo');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'Orange Crush');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'La Naranja');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'The Men in Orange');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'The Orange');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'Die Oranje');
INSERT INTO alias (data_id, alias_name) VALUES (5, 'Impact de Montreal');
INSERT INTO alias (data_id, alias_name) VALUES (5, 'Impact');
INSERT INTO alias (data_id, alias_name) VALUES (6, 'Revs');
INSERT INTO alias (data_id, alias_name) VALUES (7, 'Red Bulls');
INSERT INTO alias (data_id, alias_name) VALUES (7, 'Metros');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'Zolos');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'The U');
INSERT INTO alias (data_id, alias_name) VALUES (9, 'Sporting');
INSERT INTO alias (data_id, alias_name) VALUES (9, 'Sporting KC');
INSERT INTO alias (data_id, alias_name) VALUES (9, 'Wizards');
INSERT INTO alias (data_id, alias_name) VALUES (9, 'The Wiz');
INSERT INTO alias (data_id, alias_name) VALUES (9, 'KC Swope Park Rangers');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'Reds');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'TFC');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'CD Chivas USA');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'C.D. Chivas USA');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'Chivas USA');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'CD Chivas');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'C.D. Chivas');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'Chivas');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'Red-and-White');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'Goats');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'Goats USA');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'Rojiblancos Rebano Angelino');
INSERT INTO alias (data_id, alias_name) VALUES (13, 'FCD');
INSERT INTO alias (data_id, alias_name) VALUES (13, 'Hoops');
INSERT INTO alias (data_id, alias_name) VALUES (13, 'Red Stripes');
INSERT INTO alias (data_id, alias_name) VALUES (13, 'Toros');
INSERT INTO alias (data_id, alias_name) VALUES (13, 'Burn');
INSERT INTO alias (data_id, alias_name) VALUES (13, 'Dallas 96');
INSERT INTO alias (data_id, alias_name) VALUES (14, 'LA Galaxy');
INSERT INTO alias (data_id, alias_name) VALUES (14, 'Los Galacticos');
INSERT INTO alias (data_id, alias_name) VALUES (15, 'The Timbers');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'Claret and Cobalt');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'Royals');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'RSL');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'Real');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'Lakers');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'Los Monarcas');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'La Realeza');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'Quakes');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'The Boys in Blue');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'SJ Earthquakes');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'SJ Quakes');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'Los Terremotos de San Jose');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'The Sounders');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'Rave Green');
INSERT INTO alias (data_id, alias_name) VALUES (19, 'Whitecaps');
INSERT INTO alias (data_id, alias_name) VALUES (19, '''Caps');
INSERT INTO alias (data_id, alias_name) VALUES (19, 'Blue and White');


