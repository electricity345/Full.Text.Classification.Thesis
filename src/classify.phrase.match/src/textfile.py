import BeautifulSoup
from BeautifulSoup import Comment, Tag, NavigableString
import logging
import os
import re

import text

class textfile:
    def __init__(self, gdbm_files, filter_file, path, category):
        self.category = category
        self.filter_file = filter_file
        self.gdbm_files = gdbm_files
        self.path = path

        return
 
    def processHTMLFile(self, filename):
        log = logging.getLogger('classify')
        log.debug("texfile.processHTMLFile()")    

        text_obj = text.text(self.gdbm_files, self.filter_file, self.path, self.category)
        htmlfile = open(filename, "r")
        html = htmlfile.read()
        htmlfile.close()

        soup = BeautifulSoup.BeautifulSoup(html)
        # Removes <!-- --> comments from html
        comments = soup.findAll(text=lambda text:isinstance(text, Comment))
        [comment.extract() for comment in comments]

        #visible_text = soup.findAll(text=lambda text: text.parent.name != "script" and text.parent.name != "style" and text.parent.name != "[document]" and text.parent.name != "head" and text.parent.name != "title")
        #log.debug("visible text = %s" % visible_text)

        visible_entries = []

        # Filters out all visible content from the web page excluding text from the script, style, document, head, and title tags
        for element in soup.findAll(text=lambda text: text.parent.name != "script" and text.parent.name != "style" and text.parent.name != "[document]" and text.parent.name != "head" and text.parent.name != "title"):
            # Removes any matches that don't have any words or numbers in it
            if re.search("[\w\d]+", element): 
                log.debug("element = %s" % element)
                visible_entries.append(element)

        log.debug("visible entries = %s" % visible_entries)
        visible_string = " ".join(visible_entries)
        log.debug("visible string = %s" % visible_string)

        all_matches = text_obj.processUnicodeString(visible_string)

        log.debug("  All Matches:")
        log.debug("Number of Matches Found = %s" % len(all_matches))
        all_matches = sorted(all_matches, key=lambda positive_match: positive_match.offset)

        for item in all_matches:
            item.printMatch()
      
        return

    # Processes the utf file by first reading the file and then determining if any of the words in the text is a match to the chosen category 
    def processUTFFile(self, filename):
        log = logging.getLogger('classify')
        log.debug("texfile.processUTFFile()")    

        text_obj = text.text(self.gdbm_files, self.filter_file, self.path, self.category)
        textfile = open(filename, "r")
        excerpt = textfile.read()
        textfile.close()

        all_matches = text_obj.processUTFString(excerpt)

        log.debug("  All Matches:")
        log.debug("Number of Matches Found = %s" % len(all_matches))
        all_matches = sorted(all_matches, key=lambda positive_match: positive_match.offset)

        for item in all_matches:
            item.printMatch()

        return


