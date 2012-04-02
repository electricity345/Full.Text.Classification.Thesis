import codecs
import logging
import json
import os
import unicodedata

import duplicateHash

class classifications:
    _FALSE = 0
    _MATCH = 1

    def __init__(self, gdbm_files, filter_file, category):
        self.category = category
        self.duplicate_hash = duplicateHash.duplicateHash()
        self.filter_file = filter_file
        self.gdbm_files = gdbm_files
        self.punctuation = {0x2018:0x27, 0x2019:0x27, 0x201C:0x22, 0x201D:0x22, 0x2014:0x2D}
        self.result_stack = []
        self.edit_hash = {}
        return  

    # Checks if the noun phrase is found in the classification word list. Returns the values corresponding to the noun phrase if the word is found. 
    # Otherwise, it returns -1. (Private Function)
    def determineExistanceInClassifyList(self, tag_word):
        log = logging.getLogger('classify')
        log.debug("classifications.determineExistanceInClassifyList()")
        log.debug("tag word = %s" % tag_word)

        matches = self.getValueFromKeyInClassifyList(tag_word)
        if matches:
            key = 'match.' + tag_word
            value = 'MATCH:1'
        else:
            key = 'false.' + tag_word
            value = 'FALSE:1'
 
        self.duplicate_hash.addWord(key, value)
        return matches

    # Returns the various other ambiguous answers that could occur from a single classification word entry
    def getEditHash(self):
        return self.edit_hash

    # Returns the phrases that match an entry in the classification word list
    def getResultStack(self):
        return self.result_stack

    # Returns the value from a given key. (Public Function)
    def getValueFromKeyInClassifyList(self, key):
        log = logging.getLogger('classify')
        log.debug("classifications.getValueFromKeyInClassifyList()")

        # gdbm_files contains a list of gdbm_file objects that contain [path, gdbm_obj]
        matches = []
        for gdbm_obj in self.gdbm_files:
            if key in gdbm_obj[1]:
                log.debug("key = %s" % key)

                # Ignore matches that are just numbers
                if key.isdigit():
                    log.debug("key contains only digits = %s" % key)
                    continue

                # Ignore matches that are found in the filter dbm file
                if self.category == "geography" and key in self.filter_file:
                    log.debug("key is in filter dbm = %s" % key)
                    continue

                values = json.loads(gdbm_obj[1][key])
                log.debug("values = %s" % values)
                for element in values:
                    log.debug("element = %s" % element)
                    element_value = json.loads(gdbm_obj[1][str(element)])
                    #log.debug("element value = %s" % element_value)

                    # Adds the category search path that the match was found under
                    path = gdbm_obj[0]
                    tail = ""
                    category = []
                    while tail != "gdbm":
                        (path, tail) = os.path.split(path)
                        category.append(tail)
 
                    category = category[1:len(category)-1]
                    log.debug("category = %s" % category)
                    category_phrase = ""
                    for word in category:
                        category_phrase += word + "."
   
                    category_phrase = category_phrase[:len(category_phrase)-1] # removes the last dot from the end
                    log.debug("category phrase = %s" % category_phrase)
                    for obj in element_value:
                        obj["category"] = category_phrase

                    #log.debug("new element value = %s" % element_value)
                    matches.append(element_value)

        return matches

    # Determines if the noun phrase is found in the classification word list. If the word is a duplicate (has already been seen before), then it 
    # updates that word in the duplicate words hash. Otherwise it looks into the classification word list to see if that word is a match. 
    # Returns 1 if the tagged word is a match. Otherwise, it returns a 0. (Public Function)
    def isMatch(self, tag_word):
        log = logging.getLogger('classify')
        log.debug("classifications.isMatch()")

        if self.category == "geography" and tag_word[0].isupper() == False:
            return classifications._FALSE

        tag_words = []

        # Converts Unicode Punctuation to ASCII equivalent - NEEDS MORE
        tag_word1 = tag_word.translate(self.punctuation).encode('ascii', 'ignore').rstrip().lstrip()
        log.debug("tag word translate = %s" % tag_word1)
        tag_words.append(tag_word1)

        # Converts Unicode to ASCII equivalent - If no equivalent is found, it ignores the unicode
        tag_word2 = unicodedata.normalize('NFKD', tag_word).encode('ascii', 'ignore').rstrip().lstrip()
        log.debug("tag word normalize = %s" % tag_word2)
        if tag_word1 != tag_word2:
            log.debug("tag word 1 != tag word 2")
            tag_words.append(tag_word2)

        log.debug("tag words = %s" % tag_words)

        match = classifications._FALSE
        for tag_word in tag_words:
            tag_word = tag_word.lower() # Forces the tag word to all lowercase

            # Ignore punctuation
            if tag_word == ".":
                continue
        
            duplicate_result = self.duplicate_hash.checkPossibleMatch(tag_word)
            if duplicate_result == 0: # False tag found
                continue
            elif duplicate_result > 0: # Match tag found
                list_values = self.getValueFromKeyInClassifyList(tag_word)
                #log.debug("list values = %s" % list_values)

                self.populateResults(tag_word, list_values)
                match = classifications._MATCH            
                continue

            # Word has not yet been encountered
            list_values = self.determineExistanceInClassifyList(tag_word)
            #log.debug("list_values - isMatch = %s" % list_values)
            if not list_values:
                continue
        
            self.populateResults(tag_word, list_values)
            match = classifications._MATCH

        return match

    # Populates the result and edit hashes with words that match the search criteria and their corresponding values 
    def populateResults(self, tag_word, list_values):
        log = logging.getLogger('classify')
        log.debug("classifications.populateResults()")
        log.debug("tag_word = %s" % tag_word)
        #log.debug("list_values = %s" % list_values)

        # Add the "match" field to the list_values. The "match" field is the actual tag word that was found in the text
        for key_dict in list_values:
            for option in key_dict:
                option["match"] = tag_word

        result_hash = {}
        result_hash[tag_word] = list_values[0][0]
        self.result_stack.append(result_hash)

        edit_values = []
        for element in list_values:
            edit_values.append(element[0])

        self.edit_hash[tag_word] = edit_values

        return

    
