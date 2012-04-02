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

INSERT INTO description (name, description) VALUES ('data', 'Contains: NBA Teams as of 2011-2012 Season');

INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Boston Celtics', 'NBA', 'TD Garden', '42.366303', '-71.062228');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New Jersey Nets', 'NBA', 'Prudential Center', '40.733611', '-74.171111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New York Knicks', 'NBA', 'Madison Square Garden', '40.750556', '-73.993611');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Philadelphia 76ers', 'NBA', 'Wells Fargo Center', '39.901111', '-75.171944');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Toronto Raptors', 'NBA', 'Air Canada Centre', '43.643333', '-79.379167');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Chicago Bulls', 'NBA', 'United Center', '41.880556', '-87.674167');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Cleveland Cavaliers', 'NBA', 'Quicken Loans Arena', '41.496389', '-81.688056');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Detroit Pistons', 'NBA', 'The Palace of Auburn Hills', '42.696944', '-83.245556');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Indiana Pacers', 'NBA', 'Conseco Fieldhouse', '39.763889', '-86.155556');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Milwaukee Bucks', 'NBA', 'Bradley Center', '43.043611', '-87.916944');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Atlanta Hawks', 'NBA', 'Philips Arena', '33.757222', '-84.396389');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Charlotte Bobcats', 'NBA', 'Time Warner Cable Arena', '35.225', '-80.839167');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Miami Heat', 'NBA', 'American Airlines Arena', '25.781389', '-80.188056');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Orlando Magic', 'NBA', 'Amway Center', '28.539338', '-81.383963');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Washington Wizards', 'NBA', 'Verizon Center', '38.898056', '-77.020833');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Denver Nuggets', 'NBA', 'Pepsi Center', '39.748611', '-105.0075');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Minnesota Timberwolves', 'NBA', 'Target Center', '44.979444', '-93.276111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Portland Trail Blazers', 'NBA', 'Rose Garden', '45.531667', '-122.666667');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Oklahoma City Thunder', 'NBA', 'Oklahoma City Arena', '35.463333', '-97.515');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Utah Jazz', 'NBA', 'EnergySolutions Arena', '40.768333', '-111.901111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Golden State Warriors', 'NBA', 'Oracle Arena', '37.750278', '-122.203056');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Los Angeles Clippers', 'NBA', 'Staples Center', '34.043056', '-118.267222');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Los Angeles Lakers', 'NBA', 'Staples Center', '34.043056', '-118.267222');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Phoenix Suns', 'NBA', 'US Airways Center', '33.445833', '-112.071389');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Sacramento Kings', 'NBA', 'Power Balance Pavilion', '38.649167', '-121.518056');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Dallas Mavericks', 'NBA', 'American Airlines Center', '32.790556', '-96.810278');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Houston Rockets', 'NBA', 'Toyota Center', '29.750833', '-95.362222');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Memphis Grizzlies', 'NBA', 'FedExForum', '35.138333', '-90.050556');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New Orleans Hornets', 'NBA', 'New Orleans Arena', '29.948889', '-90.081944');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('San Antonio Spurs', 'NBA', 'AT&T Center', '29.426944', '-98.4375');

INSERT INTO alias (data_id, alias_name) VALUES (1, 'The C''s');
INSERT INTO alias (data_id, alias_name) VALUES (1, 'The Celts');
INSERT INTO alias (data_id, alias_name) VALUES (1, 'The Green');
INSERT INTO alias (data_id, alias_name) VALUES (21, 'Golden State');


