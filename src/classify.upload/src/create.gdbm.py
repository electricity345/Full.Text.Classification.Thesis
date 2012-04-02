import gdbm
import getopt
import json
import logging
import logging.handlers
import os
import sqlite3
import sys
import unicodedata 

# Each value consists of a list of ids that correspond to the actual data
def storeKeyValuePair(potential_key, id_value, gdbm_database):
    log = logging.getLogger('create.gdbm')
    key = potential_key.lower()
 
    log.debug("potential key = %s" % key)
    log.debug("id value = %s" % id_value)
 
    # Ignores keys that are digits
    if key.isdigit():
        log.debug("potential key is a digit")
        return

    keys = []
    keys.append(key)

    # Creates another entry with the word "The" stripped from it, if it is found in the beginning of the key
    # (Ex) The BoSox => BoSox
    if key.find("the") == 0:
        log.debug("potential key has THE at the beginning of it")
        key = key.replace("the", "", 1).lstrip()
        log.debug("key = %s ;; length = %s" % (key, len(key)))
        if len(key) > 1:        
            keys.append(key)

    # Creates another entry with the word "'" stripped from it, if it is found in the beginning of the key
    # (Ex) 'Canes => Canes
    if key.find("\'") == 0:
        log.debug("potential key has \' at the beginning of it")
        key = key.replace("\'", "", 1).lstrip()
        keys.append(key)

    for key in keys:
        log.debug("key = %s" % key)
        if key in gdbm_database:
            list_values = json.loads(gdbm_database[key])
            log.debug("list values = %s" % list_values)
        
            # Iterates through all values corresponding to the key found in the database. If the id_value is found, that means that the value
            # is already there and thus nothing should be done.
            for element in list_values:
                if int(id_value) == int(element):
                    return
            
            list_values.append(int(id_value))
            gdbm_database[key] = json.dumps(list_values)
            log.debug("Added gdbm_database[%s] = %s" % (key, list_values))
        else:
            list_values = []
            list_values.append(int(id_value))
            gdbm_database[key] = json.dumps(list_values)
            log.debug("Added gdbm_database[%s] = %s" % (key, list_values))

    return

# Finds all geography references in the sports key word
def splitSportsColumnType(potential_key, id_value, geo_cursor, gdbm_database):
    log = logging.getLogger('create.gdbm')
    log.debug("splitSportsColumnType()")

    word_list = potential_key.split()
    length = len(word_list) - 1
    leftmost_words = []
    geo_locations = []
    sports_teams = []

    # Assumes that the last word in the word list is the name of the sports team and then looks at the previous words before to see if they
    # form a geographical location name. 
    while (length > 0):
        geo_list = word_list[:length]
        geo_word = ' '.join(geo_list)
        sport_list = word_list[length:]
        sports_word = ' '.join(sport_list)

        log.debug("first loop - geo_word = %s" % geo_word)
        log.debug("first loop - sports_word = %s" % sports_word)

        my_cmd = "SELECT DISTINCT name FROM geonames WHERE name = '%s' ORDER BY population DESC;" % (geo_word)
        geo_cursor.execute(my_cmd)
        row = geo_cursor.fetchone()
        if row is None:
            length -= 1
            continue

        storeKeyValuePair(geo_word, id_value, gdbm_database)        
        storeKeyValuePair(sports_word, id_value, gdbm_database)
        return

    # If team cannot be found from first method, we then break down the word phrase by removing the leftmost word after each iteration
    # (Ex) Sporting Kansas City => Kansas City and FC Dallas => Dallas
    while (len(word_list) > 1):
        single_word = word_list[0]
        
        if not leftmost_words:
            leftmost_words.append([word_list[0]])
        else:
            for i in range(len(leftmost_words)):
                leftmost_words[i].append(word_list[0])
        
        word_list = word_list[1:]

        log.debug("second loop - single word = %s" % single_word)
        log.debug("second loop - leftmost_words = %s" % leftmost_words)

        my_cmd = "SELECT DISTINCT name FROM geonames WHERE name = '%s' ORDER BY population DESC;" % (single_word)
        geo_cursor.execute(my_cmd)
        row = geo_cursor.fetchone()
        if row is not None:
            geo_locations.append(single_word)
            leftover_words = " ".join(word_list)
            sports_teams.append(leftover_words)

        if len(leftmost_words) > 1:
            for i in range(len(leftmost_words)):
                words = " ".join(leftmost_words[i])
                my_cmd = "SELECT DISTINCT name FROM geonames WHERE name = '%s' ORDER BY population DESC;" % (words)
                geo_cursor.execute(my_cmd)
                row = geo_cursor.fetchone()
                if row is not None:
                    geo_locations.append(words)
                    leftover_words = " ".join(word_list)
                    sports_teams.append(leftover_words)

        words = " ".join(word_list)
        my_cmd = "SELECT DISTINCT name FROM geonames WHERE name = '%s' ORDER BY population DESC;" % (words)
        geo_cursor.execute(my_cmd)
        row = geo_cursor.fetchone()
        if row is not None:
            geo_locations.append(words)
            leftover_words = " ".join(leftmost_words[-1])
            sports_teams.append(leftover_words)

    if not geo_locations:
        log.debug("No Locations Found")
        return

    desired_word_length = 0
    desired_word_index = 0
    for index in range(len(geo_locations)):
        if len(geo_locations[index]) > desired_word_length:
            desired_word_length = len(geo_locations[index])
            desired_word_index = index

    geo_word = geo_locations[desired_word_index]
    sports_word = sports_teams[desired_word_index]

    log.debug("geo_locations = %s" % geo_locations)
    log.debug("sports_teams = %s" % sports_teams)
    log.debug("geo_word = %s" % geo_word)
    log.debug("sports_word = %s" % sports_word)

    storeKeyValuePair(geo_word, id_value, gdbm_database)        
    storeKeyValuePair(sports_word, id_value, gdbm_database)
    
    return

# Splits the person's name into first, middle, last, and suffix. These will be inputted as keys into the gdbm file
# Format: (Last [Suffix], First [Middle]) OR (First [Middle] Last [Suffix]) 
def splitPeopleColumnType(potential_key, id_value, geo_cursor, gdbm_database):
    log = logging.getLogger('create.gdbm')
    log.debug("splitPeopleColumnType()")
    word_list = potential_key.split(",")

    if len(word_list) > 1: # Format: (Last [Suffix], First [Middle])
        last_list = word_list[0].strip().split()
        log.debug("last list = %s" % last_list)

        first_list = word_list[1].strip().split()
        log.debug("first list = %s" % first_list)

        full_name = ""
        first_name = ""
        last_name = ""
        middle = ""
        suffix = ""
        if len(last_list) == 2:
            last_name = last_list[0]
            suffix = last_list[1]    
        elif len(last_list) == 1:
            last_name = last_list[0]

        if len(first_list) == 2:
            first_name = first_list[0]
            middle = first_list[1]
        elif len(first_list) == 1:
            first_name = first_list[0]
  
        if middle == "" and suffix == "":
            full_name = "%s %s" % (first_name, last_name)
        elif middle == "":
            full_name = "%s %s %s" % (first_name, last_name, suffix)
        elif suffix == "":
            full_name = "%s %s %s" % (first_name, middle, last_name)
        else:
            full_name = "%s %s %s %s" % (first_name, middle, last_name, suffix)
    
        log.debug("full_name = %s" % full_name)
        storeKeyValuePair(full_name, id_value, gdbm_database)
        storeKeyValuePair(first_name, id_value, gdbm_database)
        storeKeyValuePair(last_name, id_value, gdbm_database)
    else:
        log.debug("word list length = %s" % len(word_list))

    return

# Finds the longitude and latitude given a location name in a column that is designated as "location"
def splitLocColumnType(potential_key, id_value, geo_cursor, gdbm_database):
    log = logging.getLogger('create.gdbm')
    log.debug("splitLocColumnType()")

    # Checks if location is in the geonames table
    my_cmd = "SELECT DISTINCT latitude, longitude FROM geonames WHERE name = \"%s\" COLLATE NOCASE;" % (potential_key)
    geo_cursor.execute(my_cmd)
    row = geo_cursor.fetchone()
    if row is None:
        log.debug("my_cmd - geonames = %s" % my_cmd)

        # Checks if location is in the alternate names table
        my_cmd = "SELECT DISTINCT g.latitude, g.longitude FROM alternatename an, geonames g WHERE an.geonameid = g.geonameid AND an.alternateName = \"%s\" COLLATE NOCASE" % (potential_key)
        geo_cursor.execute(my_cmd)
        row = geo_cursor.fetchone()
        if row is None:
            log.debug("my_cmd - alternatename = %s" % my_cmd)
            log.debug("location does not exist = %s" % potential_key)
            storeKeyValuePair(potential_key, id_value, gdbm_database)
            return
    
    if str(id_value) in gdbm_database:
        list_values = json.loads(gdbm_database[str(id_value)])
        log.debug("list values = %s" % list_values)

        if list_values[0]["latitude"] == 0:
            list_values[0]["latitude"] = row[0]
            list_values[0]["longitude"] = row[1]
            log.debug("list values - after = %s" % list_values)
            gdbm_database[str(id_value)] = json.dumps(list_values)
        else:
            log.debug("list values has already been altered before")

    else:
        log.debug("id value does not exist in gdbm database = %s" % id_value)

    storeKeyValuePair(potential_key, id_value, gdbm_database)
    return

# Finds the longitude and latitude given a location in a column that is designated as "geography".
# Format: (city, state, country) OR (city, country)
def splitGeoColumnType(potential_key, id_value, geo_cursor, gdbm_database):
    log = logging.getLogger('create.gdbm')
    log.debug("splitGeoColumnType()")
    word_list = potential_key.split(",")
    
    if len(word_list) == 3:
        city = word_list[0].strip()
        state = word_list[1].strip()
        country = word_list[2].strip()

        # Verifies whether or not country exists
        my_cmd = "SELECT DISTINCT g.country_code FROM alternatename an, geonames g WHERE g.geonameid = an.geonameid AND g.feature_code = 'PCLI' AND an.alternateName = '%s' COLLATE NOCASE;" % (country)
        geo_cursor.execute(my_cmd)
        row = geo_cursor.fetchone()
        if row is None:
            log.debug("my_cmd = %s" % my_cmd)
            log.debug("country does not exist = %s" % country)
            return
       
        country_code = row[0]
 
        # Verifies whether or not us state exists
        my_cmd = "SELECT DISTINCT g.admin1_code FROM alternatename an, geonames g WHERE g.geonameid = an.geonameid AND g.feature_code = 'ADM1' AND an.alternateName = '%s' COLLATE NOCASE;" % (state)
        geo_cursor.execute(my_cmd)
        row = geo_cursor.fetchone()
        if row is None:
            log.debug("my_cmd = %s" % my_cmd)
            log.debug("state does not exist = %s" % state)
            return

        admin1_code = row[0]

        # Verifies whether or not city exists - given country and state
        my_cmd = "SELECT DISTINCT latitude, longitude FROM geonames WHERE country_code = '%s' AND admin1_code = '%s' AND name = '%s' COLLATE NOCASE;" % (country_code, admin1_code, city)
        geo_cursor.execute(my_cmd)
        row = geo_cursor.fetchone()
        if row is None:
            log.debug("my_cmd = %s" % my_cmd)
            log.debug("city does not exist - given country and state = %s" % city)
            return

        if str(id_value) in gdbm_database:
            list_values = json.loads(gdbm_database[str(id_value)])
            log.debug("list values = %s" % list_values)

            list_values[0]["latitude"] = row[0]
            list_values[0]["longitude"] = row[1]
            log.debug("list values - after = %s" % list_values)
            gdbm_database[str(id_value)] = json.dumps(list_values)
        else:
            log.debug("id value does not exist in gdbm database = %s" % id_value)

        storeKeyValuePair(city, id_value, gdbm_database)
    elif len(word_list) == 2:
        city = word_list[0].strip()
        country = word_list[1].strip()

        # Verifies whether or not country exists
        my_cmd = "SELECT DISTINCT g.country_code FROM alternatename an, geonames g WHERE g.geonameid = an.geonameid AND g.feature_code = 'PCLI' AND an.alternateName = '%s' COLLATE NOCASE;" % (country)
        geo_cursor.execute(my_cmd)
        row = geo_cursor.fetchone()
        if row is None:
            log.debug("my_cmd = %s" % my_cmd)
            log.debug("country does not exist = %s" % country)
            return

        country_code = row[0]

        # Verifies whether or not city exists - given country only
        my_cmd = "SELECT DISTINCT latitude, longitude FROM geonames WHERE country_code = '%s' AND name = '%s' COLLATE NOCASE;" % (country_code, city)
        geo_cursor.execute(my_cmd)
        row = geo_cursor.fetchone()
        if row is None:
            log.debug("my_cmd = %s" % my_cmd)
            log.debug("city does not exist - given country only = %s" % city)
            return

        if str(id_value) in gdbm_database:
            list_values = json.loads(gdbm_database[str(id_value)])
            log.debug("list values = %s" % list_values)

            list_values[0]["latitude"] = row[0]
            list_values[0]["longitude"] = row[1]
            log.debug("list values - after = %s" % list_values)
            gdbm_database[str(id_value)] = json.dumps(list_values)
        else:
            log.debug("id value does not exist in gdbm database = %s" % id_value)

        storeKeyValuePair(city, id_value, gdbm_database)
    else:
        log.debug("Word length does not match limit restriction = %s" % len(word_list))

    return

# Key = string representation of uniquely numbered id column in data table; Value = dictionary of values corresponding to the data in the data table
# Stores the full information as stored in the database using the primary key (uniquely numbered id column) as the key into the gdbm file
def storeFullKeyValuePair(key, values, gdbm_database):
    log = logging.getLogger('create.gdbm')
    key = str(key)

    if key in gdbm_database:
        #list_values = json.loads(gdbm_database[key])
        log.debug("storeFullKeyValuePair - key already in gdbm")
        
    list_values = []
    list_values.append(values)
    gdbm_database[key] = json.dumps(list_values)

    return

# Determines the match type of a column and ascertains whether or not the data in the column needs to be broken down to create more keys
# for the gdbm file    
def determineColumnType(col_type, potential_key, id_value, values, geo_cursor, gdbm_database):
    if col_type == "id":
        storeFullKeyValuePair(potential_key, values, gdbm_database)
    elif col_type == "geography":
        splitGeoColumnType(potential_key, id_value, geo_cursor, gdbm_database)
    elif col_type == "location": 
        splitLocColumnType(potential_key, id_value, geo_cursor, gdbm_database)
    elif col_type == "latitude": # No matching is done for field
        return
    elif col_type == "longitude": # No matching is done for field
        return
    elif col_type == "data":
        storeKeyValuePair(potential_key, id_value, gdbm_database)
    elif col_type == "people":
        splitPeopleColumnType(potential_key, id_value, geo_cursor, gdbm_database)
    elif col_type == "sports":
        storeKeyValuePair(potential_key, id_value, gdbm_database)
        splitSportsColumnType(potential_key, id_value, geo_cursor, gdbm_database)
    
    return

# Gets alias' for entires in the data table and adds them to the dbm file
def addAlias(col_list, database_cursor, geo_cursor, gdbm_database):
    log = logging.getLogger('create.gdbm')
    log.debug("addAlias()")

    # Determines if there is a column type named location. If so, then it will check if the alias names can be locations found in the geonames database
    found = 0 
    for col in col_list:
        col_type = col[1]
        if col_type == "location":
            found = 1

    my_cmd = "SELECT data_id, alias_name FROM alias;"
    database_cursor.execute(my_cmd)
    rows = database_cursor.fetchall()
    if rows is None:
        log.debug("my_cmd = %s" % my_cmd)
        log.debug("No data in the alias table")
        return
    
    for row in rows:
        data_id = row[0]
        alias = row[1]
        
        alias = unicodedata.normalize('NFKD', alias).encode('ascii', 'ignore')
        if found == 1:
            splitLocColumnType(alias, data_id, geo_cursor, gdbm_database)
        else:
            storeKeyValuePair(alias, data_id, gdbm_database)

    return

# Select statement will need to change to match each new sqlite file
def addData(col_list, database_cursor, geo_cursor, gdbm_database):
    log = logging.getLogger('create.gdbm')
    
    my_cmd = "SELECT * FROM data;"
    database_cursor.execute(my_cmd)
    rows = database_cursor.fetchall()

    for row in rows:
        # Stores the information of each row in a dictionary
        values = {}

        # Sets default latitude and longitude values to 0
        values["latitude"] = 0
        values["longitude"] = 0

        index = 0
        for col in col_list:
            name = col[0]
            values[name] = row[index]
            index += 1

        id_value = row[0]
        index = 0
        for col in col_list:
            col_type = col[1]
            potential_key = ""
            if type(row[index]) is int or type(row[index]) is float:
                potential_key = str(row[index])
            else:
                potential_key = unicodedata.normalize('NFKD', row[index]).encode('ascii', 'ignore')

            determineColumnType(col_type, potential_key, id_value, values, geo_cursor, gdbm_database)
            index += 1

    return

# Gets information about the columns in the database that will be converted to a gdbm file.
# Returns an array that stores the column information
def getColumnData(database_cursor):
    log = logging.getLogger('create.gdbm')
    my_cmd = "SELECT col_name, col_type, match_level FROM data_column_description;"
    database_cursor.execute(my_cmd)
    rows = database_cursor.fetchall()
    
    col_list = []
    for row in rows:
        col_info = []
        for element in row:
            col_info.append(str(element).lower())            

        col_list.append(col_info)

    log.debug("columns = %s" % col_list)
    return col_list


def printkeyValuePairs(gdbm_database):
    key_list = []
    key = gdbm_database.firstkey()
    while key != None:
        key_list.append(key)
        key = gdbm_database.nextkey(key)

    for key in sorted(key_list):
        print "key = %s and value = %s" % (key, gdbm_database[key])

    return


def createFile(database_cursor, geo_cursor, gdbm_database):
    col_list = getColumnData(database_cursor)
    addData(col_list, database_cursor, geo_cursor, gdbm_database)
    addAlias(col_list, database_cursor, geo_cursor, gdbm_database)
    printkeyValuePairs(gdbm_database)    

    return


def beginProcess(database, gdbm_filename):
    # Connect to desired database that will be used to be converted to a gdbm file
    # Path = ../../../config/database/[filename]
    path = os.path.join(os.path.dirname(__file__), '..', '..', '..', 'config', 'database', database) 
    conn = sqlite3.connect(path)
    database_cursor = conn.cursor()

    # Connect to databases that will always be necessary for categorization tagging
    # Connect to Geography database 
    # Path = ../../../config/database/[filename]
    path = os.path.join(os.path.dirname(__file__), '..', '..', '..', 'config', 'database', 'geonames.sdb') 
    conn1 = sqlite3.connect(path)
    geo_cursor = conn1.cursor()

    # Connect to gdbm database - name should be changed to meet the name of the category
    # Path = ../../../config/gdbm/gdbm_filename    
    path = os.path.join(os.path.dirname(__file__), '..', '..', '..', 'config', 'gdbm', gdbm_filename)
    gdbm_database = gdbm.open(path, 'c')

    createFile(database_cursor, geo_cursor, gdbm_database)

    # Closes connection to database
    gdbm_database.close()
    conn.close()
    conn1.close()
    
    return

# Sets the logger
def setupLogger():
    # Path = ../log/create.gdbm.log
    path = os.path.join(os.path.dirname(__file__), '..', 'log', 'create.gdbm.log') 
    LOG_FILENAME = path

    # Set up a specific logger with our desired output level
    logger = logging.getLogger('create.gdbm')
    logger.setLevel(logging.DEBUG)

    # Add the log message handler to the logger
    handler = logging.handlers.RotatingFileHandler(LOG_FILENAME, maxBytes=1000000, backupCount=5)

    # Prints timestamp next to each logged message
    formatter = logging.Formatter('%(asctime)-6s: %(name)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)

    logger.addHandler(handler)

    return

# Used to signify that the user is not using the command-line right
# Sample: time python create.gdbm.py -d nfl.sdb -g nfl.dbm > nfl.kv.txt
  # Database = nfl.sdb and GDBM filename = nfl.dbm
def usage():
    print "Usage: python create.gdbm.py -d DATABASE -g GDBM_FILENAME"

# Handles the command-line for the program.
def main(argv=None):
    if argv is None:
        argv = sys.argv

    if len(argv) != 5:
        usage()
        sys.exit(2)

    try:
        opts, args = getopt.getopt(sys.argv[1:], "d:g:", ["database=", "gdbm="])
    except getopt.GetoptError, err:
        print str(err)
        usage()
        sys.exit(2)

    database = ""
    gdbm_filename = ""
    for o, a in opts:
        if o in ("-d", "--database"):
            database = a
        elif o in ("-g", "--gdbm"):
            gdbm_filename = a
        else:
            usage()
            sys.exit(2)

    setupLogger()
    beginProcess(database, gdbm_filename)

if __name__ == '__main__':
  sys.exit(main())
