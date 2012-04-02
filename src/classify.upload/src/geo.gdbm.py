import gdbm
import getopt
import json
import logging
import logging.handlers
import os
import re
import sqlite3
import sys
import unicodedata 

# Each value consists of a list of ids that correspond to the actual data
def storeKeyValuePair(potential_key, id_value, gdbm_database):
    log = logging.getLogger('geo.gdbm')
    key = potential_key.lower().lstrip()
 
    log.debug("potential key = %s" % key)
    log.debug("id value = %s" % id_value)
 
    if key in gdbm_database:
        list_values = json.loads(gdbm_database[key])
        log.debug("list values = %s" % list_values)
        
        # Ignores keys that are digits and are already in the table
        if key.isdigit():
            log.debug("potential key is a digit")
            return

        # Iterates through all values corresponding to the key found in the database. If the id_value is found, that means that the value
        # is already there and thus nothing should be done.
        for element in list_values:
            if int(id_value) == int(element):
                return
            
        list_values.append(int(id_value))
        gdbm_database[key] = json.dumps(list_values)
    else:
        list_values = []
        list_values.append(int(id_value))
        gdbm_database[key] = json.dumps(list_values)

    return

# Key = string representation of uniquely numbered id column in data table; Value = dictionary of values corresponding to the data in the data table
# Stores the full information as stored in the database using the primary key (uniquely numbered id column) as the key into the gdbm file
def storeFullKeyValuePair(key, values, gdbm_database):
    log = logging.getLogger('geo.gdbm')
    key = str(key)

    if key in gdbm_database:
        #list_values = json.loads(gdbm_database[key])
        log.debug("storeFullKeyValuePair - key (should be an id value) already in gdbm")
        
    list_values = []
    list_values.append(values)
    gdbm_database[key] = json.dumps(list_values)

    return

# Determines which column type data should be included as keys for the gdbm file
def determineColumnType(col_type, potential_key, id_value, values, gdbm_database):
    if col_type == "id":
        storeFullKeyValuePair(potential_key, values, gdbm_database)
    elif col_type == "name":
        storeKeyValuePair(potential_key, id_value, gdbm_database)
    
    return

# Creates the information about the columns in the database that will be converted to a gdbm file 
def createColumnData():
    col_list = []
    col_list.append("id")
    col_list.append("name")
    col_list.append("latitude")
    col_list.append("longitude")
    col_list.append("feature_class")
    col_list.append("feature_code")
    col_list.append("country_code")
    col_list.append("admin1_code")
    col_list.append("admin2_code")
    col_list.append("admin3_code")
    col_list.append("admin4_code")
    col_list.append("population")

    return col_list

# Retrieves all english or abbreviation entries in the alternatename table for each entry in the geonames table
def addAlternateGeonames(cursor, gdbm_database, feature_class):
    log = logging.getLogger('geo.gdbm')
    log.debug("addAlternateGeonames()")

    my_cmd = "SELECT DISTINCT g.geonameid, an.alternateName, g.latitude, g.longitude, g.feature_class, g.feature_code, g.country_code, g.admin1_code, g.admin2_code, g.admin3_code, g.admin4_code, g.population FROM alternatename an, geonames g WHERE g.geonameid = an.geonameid AND g.feature_class = '%s' AND (an.isoLanguage = 'en' OR an.isoLanguage = 'abbr') ORDER BY g.geonameid DESC;" % (feature_class)
    cursor.execute(my_cmd)
    rows = cursor.fetchall()

    col_list = createColumnData()
    for row in rows:
        # Stores the information of each row in a dictionary
        values = {}
        index = 0
        for col in col_list:
            values[col] = row[index]
            index += 1

        id_value = row[0]
        name = row[1]
        log.debug("id value = %s" % id_value)
        log.debug("name = %s" % name)

        if not re.search("[\w\d]+", name):
            log.debug("Name is Empty String")
            potential_key = str(id_value)
            determineColumnType(col_list[0], potential_key, id_value, values, gdbm_database)
            continue
 
        # The id key value should already be in the gdbm file from the addGeonames() function
        potential_key = unicodedata.normalize('NFKD', name).encode('ascii', 'ignore')        
        determineColumnType(col_list[1], potential_key, id_value, values, gdbm_database)

    return

# Retrieves all entries in the geonames table
def addGeonames(cursor, gdbm_database, feature_class):
    log = logging.getLogger('geo.gdbm')
    log.debug("addGeonames()")

    my_cmd = "SELECT DISTINCT geonameid, ansiname, latitude, longitude, feature_class, feature_code, country_code, admin1_code, admin2_code, admin3_code, admin4_code, population FROM geonames WHERE feature_class = '%s' ORDER BY geonameid DESC;" % (feature_class)
    cursor.execute(my_cmd)
    rows = cursor.fetchall()

    col_list = createColumnData()
    for row in rows:
        # Stores the information of each row in a dictionary
        values = {}
        index = 0
        for col in col_list:
            values[col] = row[index]
            index += 1

        id_value = row[0]
        name = row[1]
        log.debug("id value = %s" % id_value)
        log.debug("name = %s" % name)

        if not re.search("[\w\d]+", name):
            log.debug("Name is Empty String")
            potential_key = str(id_value)
            determineColumnType(col_list[0], potential_key, id_value, values, gdbm_database)
            continue
        
        # The geonameid
        potential_key = str(id_value)
        determineColumnType(col_list[0], potential_key, id_value, values, gdbm_database)

        # The name of the location
        potential_key = unicodedata.normalize('NFKD', name).encode('ascii', 'ignore')
        determineColumnType(col_list[1], potential_key, id_value, values, gdbm_database)

    return

def printkeyValuePairs(gdbm_database):
    key_list = []
    key = gdbm_database.firstkey()
    while key != None:
        key_list.append(key)
        key = gdbm_database.nextkey(key)

    for key in sorted(key_list):
        print "key = %s and value = %s" % (key, gdbm_database[key])

    return

def createFile(cursor, gdbm_database):
    # A = country, state, region, ...
    # H = stream, lake, ...
    # L = parks, area, ...
    # P = city, village, ...
    # R = road, railroad, ...
    # S = spot, building, farm, ...
    # T = mountain, hill, rock, ...
    # U = undersea
    # V = forest, heath, ... 
    feature_class = "P"

    #gdbm_database['60484'] = json.dumps("Hello World!!!")

    addGeonames(cursor, gdbm_database, feature_class)
    addAlternateGeonames(cursor, gdbm_database, feature_class)
    #printkeyValuePairs(gdbm_database)    

    return


def beginProcess(database, gdbm_filename):
    # Connect to desired database that will be used to be converted to a gdbm file
    # Path = ../../../config/database/[filename]
    path = os.path.join(os.path.dirname(__file__), '..', '..', '..', 'config', 'database', database) 
    conn = sqlite3.connect(path)
    database_cursor = conn.cursor()

    # Connect to gdbm database - name should be changed to meet the name of the category
    # Path = ../../../config/gdbm/gdbm_filename    
    path = os.path.join(os.path.dirname(__file__), '..', '..', '..', 'config', 'gdbm', gdbm_filename)
    gdbm_database = gdbm.open(path, 'c')

    createFile(database_cursor, gdbm_database)

    # Closes connection to database
    gdbm_database.close()
    conn.close()
    
    return

# Sets the logger
def setupLogger():
    # Path = ../log/geo.gdbm.log
    path = os.path.join(os.path.dirname(__file__), '..', 'log', 'geo.gdbm.log') 
    LOG_FILENAME = path

    # Set up a specific logger with our desired output level
    logger = logging.getLogger('geo.gdbm')
    logger.setLevel(logging.DEBUG)

    # Add the log message handler to the logger
    handler = logging.handlers.RotatingFileHandler(LOG_FILENAME, maxBytes=1000000, backupCount=5)

    # Prints timestamp next to each logged message
    formatter = logging.Formatter('%(asctime)-6s: %(name)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)

    logger.addHandler(handler)

    return

# Used to signify that the user is not using the command-line right
# Sample: time python geo.gdbm.py -d geonames.sdb -g geonames.dbm > geonames.kv.txt
def usage():
    print "Usage: python geo.gdbm.py -d DATABASE -g GDBM_FILENAME"

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

    category = ""
    database = ""
    gdbm_filename = ""
    subcategory = ""
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
