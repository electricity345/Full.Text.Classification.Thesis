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

INSERT INTO description (name, description) VALUES ('data', 'Contains: MLB Teams as of 2011-2012 Season');

INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Atlanta Braves', 'MLB', 'Turner Field', '33.735278', '-84.389444');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Florida Marlins', 'MLB', 'Sun Life Stadium', '25.958056', '-80.238889');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Miami Marlins', 'MLB', 'Marlins Park', '25.778056', '-80.219722');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New York Mets', 'MLB', 'Citi Field', '40.756944', '-73.845833');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Philadelphia Phillies', 'MLB', 'Citizens Bank Park', '39.905833', '-75.166389');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Washington Nationals', 'MLB', 'Nationals Park', '38.872778', '-77.0075');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Chicago Cubs', 'MLB', 'Wrigley Field', '41.948333', '-87.655556');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Cincinnati Reds', 'MLB', 'Great American Ball Park', '39.0975', '-84.506667');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Houston Astros', 'MLB', 'Minute Maid Park', '29.756944', '-95.355556');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Milwaukee Brewers', 'MLB', 'Miller Park', '43.028333', '-87.971111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Pittsburgh Pirates', 'MLB', 'PNC Park', '40.446944', '-80.005833');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('St. Louis Cardinals', 'MLB', 'Busch Stadium', '38.6225', '-90.193056');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Arizona Diamondbacks', 'MLB', 'Chase Field', '33.445278', '-112.066944');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Colorado Rockies', 'MLB', 'Coors Field', '39.756111', '-104.994167');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Los Angeles Dodgers', 'MLB', 'Dodger Stadium', '34.073611', '-118.24');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('San Diego Padres', 'MLB', 'PETCO Park', '32.7073', '-117.1566');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('San Francisco Giants', 'MLB', 'AT&T Park', '37.778333', '-122.389444');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Baltimore Orioles', 'MLB', 'Oriole Park at Camden Yards', '39.283889', '-76.621667');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Boston Red Sox', 'MLB', 'Fenway Park', '42.346389', '-71.0975');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New York Yankees', 'MLB', 'Yankee Stadium', '40.829167', '-73.926389');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Tampa Bay Rays', 'MLB', 'Tropicana Field', '27.768333', '-82.653333');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Toronto Blue Jays', 'MLB', 'Rogers Centre', '43.641389', '-79.389167');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Chicago White Sox', 'MLB', 'U.S. Cellular Field', '41.83', '-87.633889');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Cleveland Indians', 'MLB', 'Progressive Field', '41.495833', '-81.685278');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Detroit Tigers', 'MLB', 'Comerica Park', '42.339167', '-83.048611');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Kansas City Royals', 'MLB', 'Kauffman Stadium', '39.051389', '-94.480556');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Minnesota Twins', 'MLB', 'Target Field', '44.981667', '-93.278333');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Los Angeles Angels of Anaheim', 'MLB', 'Angel Stadium of Anaheim', '33.800278', '-117.882778');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Oakland Athletics', 'MLB', 'O.co Coliseum', '37.751667', '-122.200556');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Seattle Mariners', 'MLB', 'Safeco Field', '47.591389', '-122.3325');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Texas Rangers', 'MLB', 'Rangers Ballpark in Arlington', '32.751389', '-97.082778');

INSERT INTO alias (data_id, alias_name) VALUES (1, 'The Bravos');
INSERT INTO alias (data_id, alias_name) VALUES (1, 'The Team of the 90s');
INSERT INTO alias (data_id, alias_name) VALUES (2, 'The Fish');
INSERT INTO alias (data_id, alias_name) VALUES (2, 'The Fightin'' Fish');
INSERT INTO alias (data_id, alias_name) VALUES (2, 'Miracle Marlins');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'The Fish');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'The Fightin'' Fish');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'Miracle Marlins');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'The Amazin''s');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'The Metropolitans');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'The Miracle Mets');
INSERT INTO alias (data_id, alias_name) VALUES (5, 'The Phils');
INSERT INTO alias (data_id, alias_name) VALUES (5, 'The Fightin'' Phils');
INSERT INTO alias (data_id, alias_name) VALUES (5, 'The Phightin'' Phils');
INSERT INTO alias (data_id, alias_name) VALUES (5, 'The Fightin''s');
INSERT INTO alias (data_id, alias_name) VALUES (5, 'The Phightin''s');
INSERT INTO alias (data_id, alias_name) VALUES (6, 'The Nats');
INSERT INTO alias (data_id, alias_name) VALUES (7, 'The Cubbies');
INSERT INTO alias (data_id, alias_name) VALUES (7, 'The North Siders');
INSERT INTO alias (data_id, alias_name) VALUES (7, 'The Boys in Blue');
INSERT INTO alias (data_id, alias_name) VALUES (7, 'The Lovable Losers');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'The Big Red Machine');
INSERT INTO alias (data_id, alias_name) VALUES (9, 'The ''Stros');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'True Blue Brew Crew');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'The Brew Crew');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'The Crew');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'Beermakers');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'Beersmen');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'Cerveceros');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'The Bucs');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'The Buccos');
INSERT INTO alias (data_id, alias_name) VALUES (12, 'The Cards');
INSERT INTO alias (data_id, alias_name) VALUES (12, 'The Redbirds');
INSERT INTO alias (data_id, alias_name) VALUES (12, 'The Birds');
INSERT INTO alias (data_id, alias_name) VALUES (12, 'The Birds on the Bat');
INSERT INTO alias (data_id, alias_name) VALUES (12, 'The Reddings');
INSERT INTO alias (data_id, alias_name) VALUES (12, 'The Red Tigers');
INSERT INTO alias (data_id, alias_name) VALUES (13, 'The D''Backs');
INSERT INTO alias (data_id, alias_name) VALUES (14, 'The Rox');
INSERT INTO alias (data_id, alias_name) VALUES (14, 'Blake Street Bombers');
INSERT INTO alias (data_id, alias_name) VALUES (15, 'Big Blue Wrecking Crew');
INSERT INTO alias (data_id, alias_name) VALUES (15, 'Blue Crew, Dem Bums');
INSERT INTO alias (data_id, alias_name) VALUES (15, 'Boys of Summer');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'The Pad Squad');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'The Pads');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'My Padres');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'The Friars');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'The Orange and Black');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'Los Gigantes');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'The G-Men');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'The Jints');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'The Gyros');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'Boys from the Bay');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'The O''s');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'The Birds');
INSERT INTO alias (data_id, alias_name) VALUES (19, 'The Sox');
INSERT INTO alias (data_id, alias_name) VALUES (19, 'The BoSox');
INSERT INTO alias (data_id, alias_name) VALUES (19, 'The Olde Towne Team');
INSERT INTO alias (data_id, alias_name) VALUES (20, 'The Bronx Bombers');
INSERT INTO alias (data_id, alias_name) VALUES (20, 'The Yanks');
INSERT INTO alias (data_id, alias_name) VALUES (20, 'The Pinstripers');
INSERT INTO alias (data_id, alias_name) VALUES (20, 'The Bronx Zoo');
INSERT INTO alias (data_id, alias_name) VALUES (21, 'D-Rays');
INSERT INTO alias (data_id, alias_name) VALUES (22, 'The Jays');
INSERT INTO alias (data_id, alias_name) VALUES (23, 'The Sox');
INSERT INTO alias (data_id, alias_name) VALUES (23, 'The ChiSox');
INSERT INTO alias (data_id, alias_name) VALUES (23, 'The South Siders');
INSERT INTO alias (data_id, alias_name) VALUES (23, 'The Pale Hose');
INSERT INTO alias (data_id, alias_name) VALUES (23, 'The Men in Black');
INSERT INTO alias (data_id, alias_name) VALUES (23, 'The Shy Sox');
INSERT INTO alias (data_id, alias_name) VALUES (23, 'The Black Sox');
INSERT INTO alias (data_id, alias_name) VALUES (24, 'The Tribe');
INSERT INTO alias (data_id, alias_name) VALUES (24, 'The Wahoos');
INSERT INTO alias (data_id, alias_name) VALUES (25, 'The Tigs');
INSERT INTO alias (data_id, alias_name) VALUES (26, 'The Boys in Blue');
INSERT INTO alias (data_id, alias_name) VALUES (27, 'The Twinkies');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'The Halos');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'Los Angeles Angels');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'Angels');
INSERT INTO alias (data_id, alias_name) VALUES (29, 'The A''s');
INSERT INTO alias (data_id, alias_name) VALUES (29, 'The White Elephants');
INSERT INTO alias (data_id, alias_name) VALUES (29, 'The Elephants');
INSERT INTO alias (data_id, alias_name) VALUES (29, 'The Green and Gold');
INSERT INTO alias (data_id, alias_name) VALUES (30, 'The M''s');
INSERT INTO alias (data_id, alias_name) VALUES (31, 'The Blue Crew');


