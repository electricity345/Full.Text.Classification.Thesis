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

INSERT INTO description (name, description) VALUES ('data', 'Contains: NFL Teams as of 2011-2012 Season');

INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Buffalo Bills', 'NFL', 'Ralph Wilson Stadium', '42.773611', '-78.786944');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Miami Dolphins', 'NFL', 'Sun Life Stadium', '25.958056', '-80.238889');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New England Patriots', 'NFL', 'Gillette Stadium', '42.090944', '-71.264344');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New York Jets', 'NFL', 'New Meadowlands Stadium', '40.813611', '-74.074444');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Baltimore Ravens', 'NFL', 'M&T Bank Stadium', '39.278056', '-76.622778');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Cincinnati Bengals', 'NFL', 'Paul Brown Stadium', '39.095556', '-84.516111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Cleveland Browns', 'NFL', 'Cleveland Browns Stadium', '41.506111', '-81.699444');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Pittsburgh Steelers', 'NFL', 'Heinz Field', '40.446667', '-80.015833');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Houston Texans', 'NFL', 'Reliant Stadium', '29.684722', '-95.410833');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Indianapolis Colts', 'NFL', 'Lucas Oil Stadium', '39.760056', '-86.163806');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Jacksonville Jaguars', 'NFL', 'EverBank Field', '30.323889', '-81.6375');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Tennessee Titans', 'NFL', 'LP Field', '36.166389', '-86.771389');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Denver Broncos', 'NFL', 'Invesco Field at Mile High', '39.743889', '-105.02');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Kansas City Chiefs', 'NFL', 'Arrowhead Stadium', '39.048889', '-94.483889');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Oakland Raiders', 'NFL', 'O.co Coliseum', '37.751667', '-122.200556');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('San Diego Chargers', 'NFL', 'Qualcomm Stadium', '32.783056', '-117.119444');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Dallas Cowboys', 'NFL', 'Cowboys Stadium', '32.747778', '-97.092778');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New York Giants', 'NFL', 'New Meadowlands Stadium', '40.813611', '-74.074444');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Philadelphia Eagles', 'NFL', 'Lincoln Financial Field', '39.900833', '-75.1675');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Washington Redskins', 'NFL', 'FedExField', '38.907778', '-76.864444');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Chicago Bears', 'NFL', 'Soldier Field', '41.8625', '-87.616667');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Detroit Lions', 'NFL', 'Ford Field', '42.34', '-83.045556');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Green Bay Packers', 'NFL', 'Lambeau Field', '44.501389', '-88.062222');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Minnesota Vikings', 'NFL', 'Hubert H. Humphrey Metrodome', '44.973889', '-93.258056');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Atlanta Falcons', 'NFL', 'Georgia Dome', '33.7575', '-84.400833');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Carolina Panthers', 'NFL', 'Bank of America Stadium', '35.225833', '-80.852778');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('New Orleans Saints', 'NFL', 'Louisiana Superdome', '29.950833', '-90.081111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Tampa Bay Buccaneers', 'NFL', 'Raymond James Stadium', '27.975833', '-82.503333');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Arizona Cardinals', 'NFL', 'University of Phoenix Stadium', '33.5275', '-112.2625');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('St. Louis Rams', 'NFL', 'Edward Jones Dome', '38.632778', '-90.188611');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('San Francisco 49ers', 'NFL', 'Candlestick Park', '37.713611', '-122.386111');
INSERT INTO data (col2, col3, col4, col5, col6) VALUES ('Seattle Seahawks', 'NFL', 'Qwest Field', '47.595278', '-122.331667');

INSERT INTO alias (data_id, alias_name) VALUES (1, 'Electric Company');
INSERT INTO alias (data_id, alias_name) VALUES (1, 'Fort Knox');
INSERT INTO alias (data_id, alias_name) VALUES (1, 'Ground Chuck');
INSERT INTO alias (data_id, alias_name) VALUES (1, 'Kelly Gun');
INSERT INTO alias (data_id, alias_name) VALUES (1, 'K-Gun');
INSERT INTO alias (data_id, alias_name) VALUES (2, 'The Fins');
INSERT INTO alias (data_id, alias_name) VALUES (2, 'The Phins');
INSERT INTO alias (data_id, alias_name) VALUES (2, 'The Fish');
INSERT INTO alias (data_id, alias_name) VALUES (2, 'The Killer Bees');
INSERT INTO alias (data_id, alias_name) VALUES (2, 'No-Name Defense');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'The Pats');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'NE Patriots');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'Evil Empire');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'Homeland Defense');
INSERT INTO alias (data_id, alias_name) VALUES (3, 'Patsies');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'Gang Green');
INSERT INTO alias (data_id, alias_name) VALUES (4, 'New York Sack Exchange');
INSERT INTO alias (data_id, alias_name) VALUES (5, 'Purple Pain');
INSERT INTO alias (data_id, alias_name) VALUES (5, 'Riptide Rush');
INSERT INTO alias (data_id, alias_name) VALUES (5, 'Death on Wings');
INSERT INTO alias (data_id, alias_name) VALUES (5, 'Ball So Hard University');
INSERT INTO alias (data_id, alias_name) VALUES (6, 'Bungles');
INSERT INTO alias (data_id, alias_name) VALUES (6, 'SWAT team');
INSERT INTO alias (data_id, alias_name) VALUES (7, 'Kardiac Kids');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'The Black and Gold');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'Stillers');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'Stihllers');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'Blitzburgh');
INSERT INTO alias (data_id, alias_name) VALUES (8, 'Steel Curtain');
INSERT INTO alias (data_id, alias_name) VALUES (9, 'Bulls on Parade');
INSERT INTO alias (data_id, alias_name) VALUES (10, 'Dolts');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'Jags');
INSERT INTO alias (data_id, alias_name) VALUES (11, 'Cardiac Jags');
INSERT INTO alias (data_id, alias_name) VALUES (13, 'Orange Crush');
INSERT INTO alias (data_id, alias_name) VALUES (13, 'Three Amigos');
INSERT INTO alias (data_id, alias_name) VALUES (15, 'The Silver and Black');
INSERT INTO alias (data_id, alias_name) VALUES (15, 'The Team of the Decades');
INSERT INTO alias (data_id, alias_name) VALUES (15, 'The World''s Team');
INSERT INTO alias (data_id, alias_name) VALUES (15, 'America''s Most Wanted');
INSERT INTO alias (data_id, alias_name) VALUES (15, 'Jokeland');
INSERT INTO alias (data_id, alias_name) VALUES (15, 'Oakland Faiders');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'The Bolts');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'San Diego Super Chargers');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'Bills West');
INSERT INTO alias (data_id, alias_name) VALUES (16, 'Dolts');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'America''s Team');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'Doomsday Defense');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'The Boys');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'Big D');
INSERT INTO alias (data_id, alias_name) VALUES (17, 'The Triplets');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'Big Blue');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'Big Blue Wrecking Crew');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'G-Men');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'G Men');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'Jints');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'Crunch Bunch');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'Earth, Wind, and Fire');
INSERT INTO alias (data_id, alias_name) VALUES (18, 'Jet Blue');
INSERT INTO alias (data_id, alias_name) VALUES (19, 'Blitz, Inc.');
INSERT INTO alias (data_id, alias_name) VALUES (20, 'The Skins');
INSERT INTO alias (data_id, alias_name) VALUES (20, 'The Burgundy and Gold');
INSERT INTO alias (data_id, alias_name) VALUES (20, 'The Deadskins');
INSERT INTO alias (data_id, alias_name) VALUES (20, 'Hogs');
INSERT INTO alias (data_id, alias_name) VALUES (20, 'Over-the-Hill Gang');
INSERT INTO alias (data_id, alias_name) VALUES (21, 'Da Bears');
INSERT INTO alias (data_id, alias_name) VALUES (21, 'The Monsters of the Midway');
INSERT INTO alias (data_id, alias_name) VALUES (23, 'The Pack');
INSERT INTO alias (data_id, alias_name) VALUES (23, 'The Green and Gold');
INSERT INTO alias (data_id, alias_name) VALUES (24, 'The Vikes');
INSERT INTO alias (data_id, alias_name) VALUES (24, 'The Purple');
INSERT INTO alias (data_id, alias_name) VALUES (24, 'Purple Pride');
INSERT INTO alias (data_id, alias_name) VALUES (24, 'The Purple People Eaters');
INSERT INTO alias (data_id, alias_name) VALUES (24, 'The Purple and Gold');
INSERT INTO alias (data_id, alias_name) VALUES (24, 'Viqueens');
INSERT INTO alias (data_id, alias_name) VALUES (25, 'Dirty Birds');
INSERT INTO alias (data_id, alias_name) VALUES (25, 'Gritz Blitz');
INSERT INTO alias (data_id, alias_name) VALUES (26, 'Cardiac Cats');
INSERT INTO alias (data_id, alias_name) VALUES (27, 'Black and Gold');
INSERT INTO alias (data_id, alias_name) VALUES (27, 'The Who Dats');
INSERT INTO alias (data_id, alias_name) VALUES (27, 'The Bless You Boys');
INSERT INTO alias (data_id, alias_name) VALUES (27, 'The Cajun Kids');
INSERT INTO alias (data_id, alias_name) VALUES (27, 'Ain''ts');
INSERT INTO alias (data_id, alias_name) VALUES (27, 'Dome Patrol');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'Bay of Pigs');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'Tampa Bay Bucs');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'The Bucs');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'Pewter Pirates');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'Yucks');
INSERT INTO alias (data_id, alias_name) VALUES (28, 'Yuccaneers');
INSERT INTO alias (data_id, alias_name) VALUES (29, 'The Cards');
INSERT INTO alias (data_id, alias_name) VALUES (29, 'The Birds');
INSERT INTO alias (data_id, alias_name) VALUES (29, 'Big Red');
INSERT INTO alias (data_id, alias_name) VALUES (29, 'The Buzzsaw');
INSERT INTO alias (data_id, alias_name) VALUES (29, 'Cardiac Cardinals');
INSERT INTO alias (data_id, alias_name) VALUES (29, 'Cardiac Cards');
INSERT INTO alias (data_id, alias_name) VALUES (29, 'Air Coryell');
INSERT INTO alias (data_id, alias_name) VALUES (30, 'Bull Elephant backfield');
INSERT INTO alias (data_id, alias_name) VALUES (30, 'Greatest Show on Turf');
INSERT INTO alias (data_id, alias_name) VALUES (31, 'The Niners');
INSERT INTO alias (data_id, alias_name) VALUES (31, 'Million Dollar Backfield');
INSERT INTO alias (data_id, alias_name) VALUES (32, 'Ground Chuck');
INSERT INTO alias (data_id, alias_name) VALUES (32, 'Seagulls');
INSERT INTO alias (data_id, alias_name) VALUES (32, 'Seasquawks');
INSERT INTO alias (data_id, alias_name) VALUES (32, 'Squawks');


