import gdbm
import getopt
import logging
import logging.handlers
import nltk # Uses NLTK Version 2.0b9
import os
import re
import sys

import textfile
import url

def beginProcess(info, identifier, gdbm_files, filter_file, path, category):
    log = logging.getLogger('classify')
    log.debug("classify.beginProcess()")

    if identifier == "w":
        url_obj = url.url(gdbm_files, filter_file, path, category)
        url_obj.processHTML(info)
    elif identifier == "f":
        textfile_obj = textfile.textfile(gdbm_files, filter_file, path, category)
        textfile_obj.processUTFFile(info)
    elif identifier == "h":
        textfile_obj = textfile.textfile(gdbm_files, filter_file, path, category)
        textfile_obj.processHTMLFile(info)
    else:
        log.debug("identifier value is not valid")
        return

    log.debug("program terminated")
    return

# Opens the filter dbm file
def getFilter():
    log = logging.getLogger('all.positives')
    log.debug("classify.getFilter()")

    path = os.path.join(os.path.dirname(__file__), "..", "..", "..", "config", "gdbm", "filter", "filter.dbm")
    filter_file = gdbm.open(path, "c")

    return filter_file

# Opens all valid gdbm files that relate to the given category
def selectCategory(category):
    log = logging.getLogger('classify')
    log.debug("classify.selectCategory()")

    # Category variable will represent the path to the directory that contains the chosen category
    category_list = category.split("/")
    log.debug("category_list = %s" % category_list)

    # The gdbm file(s) to be opened will be based off of the last argument in the path
    category_match = category
    if len(category_list) > 1:
        category_match = category_list[len(category_list) - 1]

    log.debug("category_match = %s" % category_match)
    path = os.path.join(os.path.dirname(__file__), "..", "..", "..", "config", "gdbm", category)
    gdbm_matches = []
    # Traverse gdbm directory and finds files that contain the category field as a substring
    for root, dirs, files in os.walk(path):
        for filename in files:
            new_path = os.path.join(root, filename)
            if new_path.find(category_match) != -1:
                gdbm_matches.append(new_path)

    # Each element contains [path, gdbm_obj]
    gdbm_files = []
    for path in gdbm_matches:
        gdbm_obj = gdbm.open(path, "c")
        gdbm_file = []
        gdbm_file.append(path)
        gdbm_file.append(gdbm_obj)
        gdbm_files.append(gdbm_file)

    for element in gdbm_files:
        log.debug("element = %s" % element)

    return gdbm_files

# Sets up the logger
def setupLogger():
    # Path = ../log/classify.log
    path = os.path.join(os.path.dirname(__file__), '..', 'log', 'classify.log') 
    LOG_FILENAME = path

    # Set up a specific logger with our desired output level
    logger = logging.getLogger('classify')
    logger.setLevel(logging.DEBUG)

    # Add the log message handler to the logger
    handler = logging.handlers.RotatingFileHandler(LOG_FILENAME, maxBytes=1000000, backupCount=5)

    # Prints timestamp next to each logged message
    formatter = logging.Formatter('%(asctime)-6s: %(name)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)

    logger.addHandler(handler)

    return

# Used to signify that the user is not using the command-line right
# Sample: time python classify.py -c sports -p ../uploads -w www.espn.com
def usage():
    print "Usage: python classify.py -c CATEGORY -p /PATH.TO.STORE.FILE -f FILE -w URL -h HTML"

# Handles the command-line for the program.
def main(argv=None):
    if argv is None:
        argv = sys.argv

    if(len(argv) != 7):
        usage()
        sys.exit(2)

    try:
        opts, args = getopt.getopt(sys.argv[1:], "c:p:w:f:h:", ["cat=", "path=", "web=", "file=", "html="])
    except getopt.GetoptError, err:
        print str(err)
        usage()
        return

    setupLogger()
    log = logging.getLogger('classify')

    category = ""
    path = ""
    info = ""
    identifier = ""
    for o, a in opts:
        if o in ("-c", "--cat"):
            category = a
        elif o in ("-p", "--path"):
            path = a
        elif o in ("-w", "--web"):
            info = a     # link location
            identifier = "w"
        elif o in ("-f", "--file"):
            info = a     # file path
            identifier = "f"
        elif o in ("-h", "--html"):
            info = a     # file path
            identifier = "h"
        else:
            log.debug("ERROR - Argument input does not exist")
            return

    gdbm_files = selectCategory(category)
    if not gdbm_files:
        log.debug("ERROR - No entries found for category")
        return
    
    filter_file = getFilter()
    beginProcess(info, identifier, gdbm_files, filter_file, path, category)

    # Closes connection to all gdbm files
    for gdbm_obj in gdbm_files:
        gdbm_obj[1].close()

    filter_file.close()

if __name__ == '__main__':
  sys.exit(main())
