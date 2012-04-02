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

INSERT INTO description (name, description) VALUES ('data', 'Contains: NHL Teams as of 2011-2012 Season');

INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New Jersey Devils', 'NHL', 'Prudential Center', '40.733611', '-74.171111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New York Islanders', 'NHL', 'Nassau Veterans Memorial Coliseum', '40.722778', '-73.590556');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New York Rangers', 'NHL', 'Madison Square Garden', '40.750556', '-73.993611');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Philadelphia Flyers', 'NHL', 'Wells Fargo Center', '39.901111', '-75.171944');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Pittsburgh Penguins', 'NHL', 'Consol Energy Center', '40.441762', '-79.990094');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Boston Bruins', 'NHL', 'TD Garden', '42.366303', '-71.062228');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Buffalo Sabres', 'NHL', 'HSBC Arena', '42.875', '-78.876389');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Montreal Canadiens', 'NHL', 'Bell Centre', '45.496111', '-73.569444');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Ottawa Senators', 'NHL', 'Scotiabank Place', '45.296944', '-75.927222');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Toronto Maple Leafs', 'NHL', 'Air Canada Centre', '43.643333', '-79.379167');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Carolina Hurricanes', 'NHL', 'RBC Center', '35.803333', '-78.721944');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Florida Panthers', 'NHL', 'BankAtlantic Center', '26.158333', '-80.325556');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Tampa Bay Lightning', 'NHL', 'St. Pete Times Forum', '27.942778', '-82.451944');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Washington Capitals', 'NHL', 'Verizon Center', '38.898056', '-77.020833');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Winnipeg Jets', 'NHL', 'MTS Centre', '49.892851', '-97.143744');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Chicago Blackhawks', 'NHL', 'United Center', '41.880556', '-87.674167');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Columbus Blue Jackets', 'NHL', 'Nationwide Arena', '39.969283', '-83.006111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Detroit Red Wings', 'NHL', 'Joe Louis Arena', '42.325278', '-83.051389');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Nashville Predators', 'NHL', 'Bridgestone Arena', '36.159167', '-86.778611');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('St. Louis Blues', 'NHL', 'Scottrade Center', '38.626667', '-90.2025');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Calgary Flames', 'NHL', 'Pengrowth Saddledome', '51.0375', '-114.051944');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Colorado Avalanche', 'NHL', 'Pepsi Center', '39.748611', '-105.0075');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Edmonton Oilers', 'NHL', 'Rexall Place', '53.571389', '-113.456111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Minnesota Wild', 'NHL', 'Xcel Energy Center', '44.944722', '-93.101111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Vancouver Canucks', 'NHL', 'Rogers Arena', '49.277778', '-123.108889');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Anaheim Ducks', 'NHL', 'Honda Center', '33.807778', '-117.876667');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Dallas Stars', 'NHL', 'American Airlines Center', '32.790556', '-96.810278');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Los Angeles Kings', 'NHL', 'Staples Center', '34.043056', '-118.267222');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Phoenix Coyotes', 'NHL', 'Jobing.com Arena', '33.531944', '-112.261111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('San Jose Sharks', 'NHL', 'HP Pavilion at San Jose', '37.332778', '-121.901111');

INSERT INTO alias (data_id, alias_name) VALUES (1, 'Devs');
INSERT INTO alias (data_id, alias_name) VALUES (2, 'Fishsticks');
INSERT INTO alias (data_id, alias_name) VALUES (2, 'Isles');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'Blueshirts');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'Broadway Blueshirts');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'Broadway Bullies');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'Rags');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'Rangos');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'Broad Street Bullies');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'Cheesepuffs');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'Fly Guys');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'Orange & Black');
INSERT INTO alias (data_id, alias_name) VALUES (5, '''Guins');
INSERT INTO alias (data_id, alias_name) VALUES (5, 'Pens');
INSERT INTO alias (data_id, alias_name) VALUES (6, 'B''s');
INSERT INTO alias (data_id, alias_name) VALUES (6, 'The Black and Gold');
INSERT INTO alias (data_id, alias_name) VALUES (6, 'Bears');
INSERT INTO alias (data_id, alias_name) VALUES (6, 'Spoked B');
INSERT INTO alias (data_id, alias_name) VALUES (6, 'Spokes');
INSERT INTO alias (data_id, alias_name) VALUES (7, 'Katanas');
INSERT INTO alias (data_id, alias_name) VALUES (7, 'Sabes');
INSERT INTO alias (data_id, alias_name) VALUES (7, 'Sabs');
INSERT INTO alias (data_id, alias_name) VALUES (7, 'Slugs');
INSERT INTO alias (data_id, alias_name) VALUES (7, 'Swords');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'Le Bleu-Blanc-Rouge');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'The Blue-White-Red');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'The Blue, White & Red');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'Flying Frenchmen');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'Les Glorieux');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'The Glorious Ones');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'Les Habitants');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'The Habs');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'Les Rouges');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'La sainte flanelle');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'Le Tricolore');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'The Tricolour');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'The Three Colours');
INSERT INTO alias (data_id, alias_name) VALUES (9, 'Sens');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'Bay Street Bullies');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'Blue-and-White');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'Buds');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'Hogs');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'Leafs');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'Leaves');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'Tomales');
INSERT INTO alias (data_id, alias_name) VALUES (11, '''Canes');
INSERT INTO alias (data_id, alias_name) VALUES (12, 'Cats');
INSERT INTO alias (data_id, alias_name) VALUES (12, 'Paws');
INSERT INTO alias (data_id, alias_name) VALUES (12, 'Rink Rats');
INSERT INTO alias (data_id, alias_name) VALUES (12, 'South Paws');
INSERT INTO alias (data_id, alias_name) VALUES (13, 'Bolts');
INSERT INTO alias (data_id, alias_name) VALUES (14, 'Caps');
INSERT INTO alias (data_id, alias_name) VALUES (14, 'Eagles');
INSERT INTO alias (data_id, alias_name) VALUES (15, 'The Airforce');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'B-Hawks');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'Blackbirds');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'Hawks');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'The Indianhead');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'BJ''s');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'Cannons');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'Jackets');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'Navy Blazers');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'Dead Wings');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'The Red and White');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'Winged Wheel');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'Wings');
INSERT INTO alias (data_id, alias_name) VALUES (19, 'Preds');
INSERT INTO alias (data_id, alias_name) VALUES (20, 'Bluenotes');
INSERT INTO alias (data_id, alias_name) VALUES (20, 'The ''Notes');
INSERT INTO alias (data_id, alias_name) VALUES (21, 'Fire');
INSERT INTO alias (data_id, alias_name) VALUES (21, 'Smoke');
INSERT INTO alias (data_id, alias_name) VALUES (22, 'Avs');
INSERT INTO alias (data_id, alias_name) VALUES (22, '''Lanche');
INSERT INTO alias (data_id, alias_name) VALUES (23, 'Greasers');
INSERT INTO alias (data_id, alias_name) VALUES (23, 'The Oil');
INSERT INTO alias (data_id, alias_name) VALUES (25, '''Nucks');
INSERT INTO alias (data_id, alias_name) VALUES (26, 'The Mallards');
INSERT INTO alias (data_id, alias_name) VALUES (26, 'The Mighty Ducks');
INSERT INTO alias (data_id, alias_name) VALUES (26, 'Webbed-Toes');
INSERT INTO alias (data_id, alias_name) VALUES (27, 'Sheriffs');
INSERT INTO alias (data_id, alias_name) VALUES (27, 'Southern Stars');
INSERT INTO alias (data_id, alias_name) VALUES (27, 'Yellow Stars');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'The Crown');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'Monarchs');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'Queens');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'Rink Royalty');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'Royalty');
INSERT INTO alias (data_id, alias_name) VALUES (29, 'Desert Dogs');
INSERT INTO alias (data_id, alias_name) VALUES (29, 'Dogs');
INSERT INTO alias (data_id, alias_name) VALUES (29, '''Yotes');
INSERT INTO alias (data_id, alias_name) VALUES (30, 'Fins');
INSERT INTO alias (data_id, alias_name) VALUES (30, 'Fish');
INSERT INTO alias (data_id, alias_name) VALUES (30, 'The Teal Team');
INSERT INTO alias (data_id, alias_name) VALUES (30, 'Team Teal');
INSERT INTO alias (data_id, alias_name) VALUES (30, 'Tuna');


