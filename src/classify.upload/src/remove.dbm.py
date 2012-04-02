import gdbm
import getopt
import json
import logging
import logging.handlers
import os
import sys
import unicodedata 

def removeKeyFromDBM(gdbm_database, key):
    log = logging.getLogger('remove.dbm')
    log.debug("key = %s and value = %s" % (str(key), gdbm_database[str(key)]))
  
    if str(key) in gdbm_database:
        del gdbm_database[str(key)]

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

def beginProcess(gdbm_filename, key):
    gdbm_database = gdbm.open(gdbm_filename, 'c')

    removeKeyFromDBM(gdbm_database, key)
    printkeyValuePairs(gdbm_database)
    
    gdbm_database.close() # Closes connection to database
    
    return

# Sets the logger
def setupLogger():
    # Path = ../log/create.gdbm.log
    path = os.path.join(os.path.dirname(__file__), '..', 'log', 'remove.dbm.log') 
    LOG_FILENAME = path

    # Set up a specific logger with our desired output level
    logger = logging.getLogger('remove.dbm')
    logger.setLevel(logging.DEBUG)

    # Add the log message handler to the logger
    handler = logging.handlers.RotatingFileHandler(LOG_FILENAME, maxBytes=1000000, backupCount=5)

    # Prints timestamp next to each logged message
    formatter = logging.Formatter('%(asctime)-6s: %(name)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)

    logger.addHandler(handler)

    return

# Used to signify that the user is not using the command-line right
# Sample: time python remove.dbm.py -g us.news.100.11.dbm -k M.I.T. > us.colleges.kv.txt
  # GDBM filename = us.news.100.11.dbm ; key = m.i.t. ; value = 6
def usage():
    print "Usage: python remove.dbm.py -g /location.of.gdbm/GDBM_FILENAME -k KEY"

# Handles the command-line for the program.
def main(argv=None):
    if argv is None:
        argv = sys.argv

    if len(argv) != 5:
        usage()
        sys.exit(2)

    try:
        opts, args = getopt.getopt(sys.argv[1:], "g:k:", ["gdbm=", "key="])
    except getopt.GetoptError, err:
        print str(err)
        usage()
        sys.exit(2)

    gdbm_filename = ""
    key = ""
    for o, a in opts:
        if o in ("-g", "--gdbm"):
            gdbm_filename = a
        elif o in ("-k", "--key"):
            key = a
        else:
            usage()
            sys.exit(2)

    setupLogger()
    beginProcess(gdbm_filename, key)

if __name__ == '__main__':
  sys.exit(main())
