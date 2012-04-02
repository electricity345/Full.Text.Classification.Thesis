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
        
        soup = BeautifulSoup.BeautifulSoup(html)
        # Removes <!-- --> comments from html
        comments = soup.findAll(text=lambda text:isinstance(text, Comment))
        [comment.extract() for comment in comments]

        all_matches = [] # List of all matches found in text in order they are found
        id_count = 1 # Specifies the id count number that will be inserted into the id attribute
        previous_element_parent = {} # Stores previously seen parent tree (key = previously seen parent tree ; value = last modified index in tree)

        # Filters out all visible content from the web page excluding text from the script, style, document, head, and title tags
        for element in soup.findAll(text=lambda text: text.parent.name != "script" and text.parent.name != "style" and text.parent.name != "[document]" and text.parent.name != "head" and text.parent.name != "title"):
            # Removes any matches that don't have any words or numbers in it
            if re.search("[\w\d]+", element): 
                log.debug("element = %s" % element)

                matches = text_obj.processUnicodeString(element)
                if matches: # Match is found
                    log.debug("matches = %s" % matches)

                    all_matches.extend(matches) # concatenates lists
                    phrase = element
                    match_index = []
                    # Finds if the given visible text entry contains any matches and stores the words that come before it
                    for match in matches:
                        index = phrase.find(match.getMatch())
                        if index != -1:
                            match_index.append(phrase[:index]) 
                            phrase = phrase[index+len(match.getMatch()):] 

                    log.debug("match_index = %s" % match_index)
                    log.debug("phrase = %s" % phrase)
                    
                    span_tags = []
                    # Creates the span tag objects 
                    for match in matches:
                        span = Tag(soup, "span") # Creates a span tag
                        span["id"] = id_count # Add the id attribute to the span tag
                        span["style"] = "background-color: #ffff00" # Add the background color to the span tag
                        span.insert(0, match.getMatch()) # Inserts the matched key word in between the span tag
                        span_tags.append(span)
                        id_count += 1

                    log.debug("element.parent.contents = %s" % element.parent.contents)

                    count = 0
                    # Checks if the parent tree has been previously seen. If so, it gets that index + 1 in the tree  
                    if element.parent in previous_element_parent:
                        log.debug("element.parent in previous_element_parent")
                        count = previous_element_parent[element.parent]
                        # If the current index is a Tag object, skip it and go onto the next index
                        while(count < len(element.parent.contents) and type(element.parent.contents[count]) == Tag):
                            log.debug("incrementing count because of tag")
                            count += 1
                    else:
                        # Checks if an object in the tree has already been previouly seen. If so, it gets that index + 1 in the tree
                        for index in range(len(element.parent.contents)):
                            if element.parent.contents[index] in previous_element_parent:
                                log.debug("Current index has been previously seen - set count to index")
                                count = index + 1
                
                    # Inserts the span tags and strings in their right order
                    for index in range(len(match_index)):
                        element.parent.insert(count, match_index[index])
                        element.parent.insert(count+1, span_tags[index])
                        count += 2

                    element.parent.insert(count, phrase)
                    log.debug("element.parent - before extract = %s" % element.parent)
                    element.extract() # Removes the element from the tree
                    previous_element_parent[span_tags[0].parent] = count + 1 # Stores the last modified index in the tree
                    log.debug("element.parent - after extract = %s" % element.parent) 
                    log.debug("span_tags[].parent = %s" % span_tags[0].parent)

        # Closes the html file and overwrites it with the key words highlighted
        htmlfile.close()
        htmlfile = open(filename, "w")
        htmlfile.write(str(soup))

        log.debug("final id count = %s" % id_count)
        #log.debug("soup = %s" % soup)
        log.debug("  All Matches:")
        log.debug("Number of Matches Found = %s" % len(all_matches))

        for item in all_matches:
            item.printMatch()

        text_obj.createResultJSONFile()
        text_obj.createEditJSONFile()

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

        text_obj.createResultJSONFile()
        text_obj.createEditJSONFile()

        return


