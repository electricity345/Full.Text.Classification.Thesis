CREATE TABLE IF NOT EXISTS data (
  col1 INTEGER PRIMARY KEY,
  col2 varchar(200) NOT NULL,
  col3 varchar(100) NOT NULL,
  col4 varchar(200) NOT NULL,
  col5 INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS data_column_description (
  id INTEGER PRIMARY KEY,
  col_name varchar(200) NOT NULL,
  col_type varchar(50) NOT NULL, 
  match_level INTEGER NOT NULL
);

INSERT INTO data_column_description (id, col_name, col_type, match_level) VALUES (1, 'Id', 'id', 0);
INSERT INTO data_column_description (id, col_name, col_type, match_level) VALUES (2, 'Name', 'people', 1);
INSERT INTO data_column_description (id, col_name, col_type, match_level) VALUES (3, 'Company', 'data', 2);
INSERT INTO data_column_description (id, col_name, col_type, match_level) VALUES (4, 'Headquarters', 'geography', 2);
INSERT INTO data_column_description (id, col_name, col_type, match_level) VALUES (5, 'Rank', 'data', 2);

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

INSERT INTO description (name, description) VALUES ('data', 'Contains Fortune 500 CEOs for 2011');

INSERT INTO data (col2, col3, col4, col5) VALUES ('Duke, Michael T.', 'Walmart', 'Bentonville, Arkansas, USA', 1);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Tillerson, Rex W.', 'ExxonMobil', 'Irving, Texas, USA', 2);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Watson, John S.', 'Chevron', 'San Ramon, California, USA', 3);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Mulva, James J.', 'ConocoPhillips', 'Houston, Texas, USA', 4);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Williams, Michael J.', 'Fannie Mae', 'Washington, D.C., USA', 5);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Immelt, Jeffrey R.', 'General Electric', 'Schenectady, New York, USA', 6);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Buffett, Warren E.', 'Berkshire Hathaway', 'Omaha, Nebraska, USA', 7);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Akerson, Daniel F.', 'General Motors', 'Detroit, Michigan, USA', 8);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Moynihan, Brian T.', 'Bank of America', 'Charlotte, North Carolina, USA', 9);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Mulally, Alan R.', 'Ford', 'Dearborn, Michigan, USA', 10);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Apotheker, Léo', 'Hewlett-Packard', 'Palo Alto, California, USA', 11);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Stephenson, Randall L.', 'AT&T', 'Dallas, Texas, United States', 12);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Dimon, James', 'JPMorgan Chase', 'New York City, New York, USA', 13);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Pandit, Vikram S.', 'Citigroup', 'New York City, New York, USA', 14);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Hammergren, John H.', 'McKesson', 'San Francisco, California, USA', 15);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Seidenberg, Ivan G.', 'Verizon', 'New York City, New York, USA', 16);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Benmosche, Robert H.', 'American International Group', 'New York, NY, USA', 17);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Palmisano, Samuel J.', 'IBM', 'Armonk, New York, USA', 18);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Barrett, George S.', 'Cardinal Health', 'Dublin, Ohio, USA', 19);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Haldeman Jr., Charles E.', 'Freddie Mac', 'Tysons Corner, Virginia, USA', 20);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Merlo, Larry J.', 'CVS Caremark', 'Woonsocket, Rhode Island, USA', 21);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Hemsley, Stephen J.', 'UnitedHealth Group', 'Minnetonka, Minnesota, USA', 22);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Stumpf, John G.', 'Wells Fargo', 'San Francisco, California, USA', 23);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Klesse, William R.', 'Valero', 'San Antonio, Texas, USA', 24);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Dillon, David B.', 'Kroger', 'Cincinnati, Ohio, USA', 25);
INSERT INTO data (col2, col3, col4, col5) VALUES ('McDonald, Robert A.', 'Procter & Gamble', 'Cincinnati, Ohio, USA', 26);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Yost, R. David', 'AmerisourceBergen', 'Chesterbrook, Pennsylvania, USA', 27);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Sinegal, James D.', 'Costco', 'Issaquah, Washington, USA', 28);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Cazalot Jr., Clarence P.', 'Marathon Oil', 'Houston, Texas, USA', 29);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Blake, Francis S.', 'Home Depot', 'Marietta, GA, USA', 30);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Read, Ian C.', 'Pfizer', 'New York City, New York, USA', 31);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Wasson, Gregory D.', 'Walgreen', 'Deerfield, Illinois, USA', 32);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Steinhafel, Gregg W.', 'Target', 'Minneapolis, Minnesota, USA', 33);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Snow Jr., David B.', 'Medco Health Solutions', 'Franklin Lakes, New Jersey, USA', 34);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Jobs, Steven P.', 'Apple', 'Cupertino, California, USA', 35);
INSERT INTO data (col2, col3, col4, col5) VALUES ('McNerney Jr., W. James', 'Boeing', 'Chicago, Illinois, USA', 36);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Rust Jr., Edward B.', 'State Farm Insurance', 'Bloomington, Illinois, USA', 37);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Ballmer, Steven A.', 'Microsoft', 'Redmond, Washington, USA', 38);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Woertz, Patricia A.', 'Archer Daniels Midland', 'Decatur, Illinois, USA', 39);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Weldon, William C.', 'Johnson & Johnson', 'New Brunswick, New Jersey, USA', 40);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Dell, Michael S.', 'Dell', 'Round Rock, Texas, USA', 41);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Braly, Angela F.', 'WellPoint', 'Indianapolis, IN, USA', 42);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Nooyi, Indra K.', 'PepsiCo', 'Purchase, New York, USA', 43);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Chênevert, Louis R.', 'United Technologies', 'Hartford, Connecticut, USA', 44);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Liveris, Andrew N.', 'Dow', 'Midland, Michigan, USA', 45);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Kandarian, Steven A.', 'MetLife', 'New York City, New York, USA', 46);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Dunn, Brian J.', 'Best Buy', 'Richfield, Minnesota, USA', 47);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Davis, D. Scott', 'UPS', 'Sandy Springs, Georgia, USA', 48);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Rosenfeld, Irene B.', 'Kraft Foods', 'Northfield, Illinois, USA', 49);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Niblock, Robert A.', 'Lowe''s', 'Mooresville, North Carolina, USA', 50);
INSERT INTO data (col2, col3, col4, col5) VALUES ('O''Connor, Sean M.', 'INTL FCStone', 'New York, New York, USA', 51);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Stevens, Robert J.', 'Lockheed Martin', 'Bethesda, Maryland, USA', 52);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Frazier, Kenneth C.', 'Merck', 'Whitehouse Station, New Jersey, USA', 53);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Blankfein, Lloyd C.', 'Goldman Sachs', 'New York, NY, USA', 54);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Paz, George', 'Express Scripts', 'St. Louis, Missouri, USA', 55);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Otellini, Paul S.', 'Intel', 'Santa Clara, California, USA', 56);
INSERT INTO data (col2, col3, col4, col5) VALUES ('D''Ambrosio, Louis J.', 'Sears Holdings', 'Hoffman Estates, Illinois, USA', 57);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Oberhelman, Douglas R.', 'Caterpillar', 'Peoria, Illinois, USA', 58);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Marchionne, Sergio', 'Chrysler', 'Auburn Hills, Michigan, USA', 59);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Burd, Steven A.', 'Safeway', 'Pleasanton, California, USA', 60);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Herkert, Craig R.', 'SuperValu', 'Eden Prairie, Minnesota, USA', 61);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Chambers, John T.', 'Cisco', 'San Jose, California, USA', 62);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Gorman, James P.', 'Morgan Stanley', 'New York City, New York, USA', 63);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Strangfeld Jr., John R.', 'Prudential', 'Newark, New Jersey, USA', 64);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Iger, Robert A.', 'Disney', 'Burbank, California, USA', 65);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Roberts, Brian L.', 'Comcast', 'Philadelphia, Pennsylvania, USA', 66);
INSERT INTO data (col2, col3, col4, col5) VALUES ('DeLaney III, William J.', 'Sysco', 'Houston, Texas, USA', 67);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Elsenhans, Lynn L.', 'Sunoco', 'Philadelphia, Pennsylvania, USA', 68);
INSERT INTO data (col2, col3, col4, col5) VALUES ('White, Miles D.', 'Abbott', 'North Chicago, Illinois, USA', 69);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Kent, Muhtar', 'Coca-Cola', 'Atlanta, Georgia, USA', 70);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Mathas, Theodore A.', 'New York Life Insurance', 'New York, New York, USA', 71);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Bush, Wesley G.', 'Northrop Grumman', 'Falls Church, Virginia, USA', 72);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Smith, Frederick W.', 'FedEx', 'Memphis, Tennessee, USA', 73);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Hess, John B.', 'Hess', 'New York City, New York, USA', 74);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Spierkel, Gregory M.E.', 'Ingram Micro', 'Santa Ana, CA, USA', 75);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Roell, Stephen A.', 'Johnson Controls', 'Milwaukee, Wisconsin, USA', 76);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Bertolini, Mark', 'Aetna', 'Hartford, CT, USA', 77);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Bezos, Jeffrey P.', 'Amazon', 'Seattle, WA, USA', 78);
INSERT INTO data (col2, col3, col4, col5) VALUES ('McCallister, Michael B.', 'Humana', 'Louisville, Kentucky, USA', 79);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Creel, Michael A.', 'Enterprise Products Partners', 'Houston, Texas, USA', 80);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Cote, David M.', 'Honeywell', 'Morristown, New Jersey, USA', 81);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Kelly, Edmund F.', 'Liberty Mutual', 'Boston, Massachusetts, USA', 82);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Murdoch, K. Rupert', 'News Corp.', 'New York City, NY, USA', 83);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Kullman, Ellen J.', 'DuPont', 'Wilmington, Delaware, USA', 84);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Hesse, Daniel R.', 'Sprint', 'Overland Park, Kansas, USA', 85);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Johnson, Jay L.', 'General Dynamics', 'West Falls Church, Virginia, USA', 86);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Ferguson Jr., Roger W.', 'TIAA-CREF', 'New York City, New York, USA', 87);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Anderson, Richard H.', 'Delta', 'Atlanta, Georgia, USA', 88);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Wilson, Thomas J.', 'Allstate', 'Northfield Township, Illinois, USA', 89);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Bracken, Richard M.', 'HCA Holdings', 'Nashville, TN, USA', 90);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Chenault, Kenneth I.', 'American Express', 'New York City, New York, USA', 91);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Page, Larry', 'Google', 'Mountain View, California, USA', 92);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Smith, Donnie', 'Tyson Foods', 'Springdale, Arkansas, USA', 93);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Camilleri, Louis C.', 'Philip Morris International', 'New York City, NY, USA', 94);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Bewkes, Jeffrey L.', 'Time Warner', 'New York, NY, USA', 95);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Ellison, Lawrence J.', 'Oracle', 'Redwood City, California, USA', 96);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Buckley, George W.', '3M', 'Maplewood, Minnesota, USA', 97);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Allen, Samuel R.', 'John Deere', 'Moline, Illinois, USA', 98);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Armstrong, Greg L.', 'Plains All American Pipeline', 'Houston, Texas, USA', 99);
INSERT INTO data (col2, col3, col4, col5) VALUES ('Standley, John T.', 'Rite Aid', 'East Pennsboro Township, Pennsylvania, USA', 100);


