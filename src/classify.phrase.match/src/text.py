import codecs
import htmlentitydefs
import json
import logging
import nltk # Uses NLTK Version 2.0b9
import os
import re
import unicodedata

class positive_match:
    def __init__(self, match, offset):
        self.match = match
        self.offset = offset

    def getMatch(self):
        return self.match

    def getOffset(self):
        return self.offset

    def printMatch(self):
        log = logging.getLogger('classify')
        log.debug("match = %s ;; offset = %s" % (self.match, self.offset))


class text:
    def __init__(self, gdbm_files, filter_file, path, category):
        self.category = category
        self.filter_file = filter_file
        self.gdbm_files = gdbm_files
        self.path = path

        return  

    def processUnicodeText(self, tokens):
        log = logging.getLogger('classify')
        log.debug("text.processUnicodeText()")
        log.debug("tokens = %s" % tokens)

        symbols = [".", "\&", "'", "-", "/", ","] # Punctuation that will be removed individually from each token
        punctuation = {0x2018:0x27, 0x2019:0x27, 0x201C:0x22, 0x201D:0x22, 0x2014:0x2D} # Unicode to ASCII equivalent
        matches = [] # All matches found in the document

        # Takes a list of tokenized words and adds them into a hash with the key = token and value = location of token in text (offset) 
        for index in range(len(tokens)):
            token_possibilities = []
            log.debug("unmodifed token = %s ;; index = %s" % (tokens[index], index))
  
            # Converts Unicode Punctuation to ASCII equivalent - ADD ENTRIES AS NECESSARY
            token = tokens[index].translate(punctuation).encode('ascii', 'ignore')
            log.debug("token translate = %s" % token)
            token_possibilities.append(token)

            # Converts Unicode to ASCII equivalent - If no equivalent is found, it ignores the unicode
            token1 = unicodedata.normalize('NFKD', tokens[index]).encode('ascii', 'ignore')
            log.debug("token normalize = %s" % token1)
            if token != token1:
                log.debug("token != token1")
                token_possibilities.append(token1)

            log.debug("token possibilities = %s" % token_possibilities)

            for token in token_possibilities:
                potential_match = []
                offset_match = []

                token = re.sub("[^\&/\w\d.',-]", "", token) # Removes all characters that aren't words, digits, ', ".", "-", "/", "&", or ","
                token = token.lower()
                log.debug("token = %s ;; index = %s" % (token, index))

                if token == "":
                    log.debug("token is empty string")
                    continue
                
                # If the chosen category is "geography", we optimize it so that it looks for the inital word to have their first letter upper-cased.
                # This helps to reduce the number of false positives found. 
                # Case: City of Industry ;; (London)
                if self.category == "geography" and tokens[index][0].isupper() == False:
                    if len(tokens[index]) > 1 and tokens[index][1].isupper() == False:
                        continue

                # Peeks at the next 4 words to the current key's location and appends each word one at a time to see if it forms a word that
                # is found in a related category dbm file
                for offset in range(5):
                    if index + offset >= len(tokens):
                        break 
   
                    single_word_possibilities = [] # Possible variants for a given word
   
                    # Gets word from text without any modifications to it
                    word = tokens[index + offset].lower()
                    word1 = word.translate(punctuation).encode('ascii', 'ignore')
                    log.debug("word 1 translate = %s" % word1)
                    if word1 != "":
                        single_word_possibilities.append(word1)

                    word2 = unicodedata.normalize('NFKD', word).encode('ascii', 'ignore')
                    log.debug("word 2 normalize = %s" % word2)
                    if word1 != word2:
                        log.debug("word1 != word2")
                        single_word_possibilities.append(word2)

                    offset_match.append(index + offset)
                    log.debug("word = %s ;; offset = %s" % (word, index + offset))

                    possible_words = single_word_possibilities[:] # Copies list

                    for word in single_word_possibilities:
                        # Removes all symbols except ".", ', "/", "-", and "," from the word in question
                        new_word = re.sub("[^\&/\w\d.',-]", "", word)
                        if new_word != word:
                            log.debug("[new_word != word] = %s" % new_word)
                            possible_words.append(new_word)

                        # Checks if the word has any punctuation specified. If it does, it removes each one of the punctutation individually and
                        # adds the newly created word back to the single_word_possiblities list for re-evalualtion. 
                        if re.search("[\&/.',-]", new_word):
                            for element in symbols:
                                regular_expression = "[%s]" % element
                                if re.search(regular_expression, new_word):
                                    new_words = re.split(regular_expression, new_word)
                                    log.debug("new words = %s ;; re = %s" % (new_words, regular_expression))

                                    for w in new_words:
                                        new_word1 = w.rstrip().lstrip()

                                        if new_word1 == "":
                                            log.debug("new word is empty string")
                                            continue
                                        elif len(new_word1) < 2:
                                            log.debug("new word has less than 2 characters = %s" % new_word1)
                                            continue

                                        element_seen = 0
                                        for e in possible_words:
                                            if new_word1 == e:
                                                element_seen = 1
                                                break

                                        if element_seen == 0:
                                            possible_words.append(new_word1)
                                            single_word_possibilities.append(new_word1)

                    single_word_possibilities = possible_words[:]
                    log.debug("potential match - before = %s" % potential_match)
                    if not potential_match:
                        for word in single_word_possibilities:
                            potential_match.append(word)                  
                    elif single_word_possibilities:
                        tmp = []
                        for phrase in potential_match:
                            for word in single_word_possibilities:
                                potential_word = phrase + " " + word
                                tmp.append(potential_word)

                        potential_match = tmp

                    log.debug("potential match - after = %s" % potential_match)
       
                    # Iterates through all of the related category dbm files and sees if the potential match is found in any of them
                    # gdbm_files contains a list of gdbm_file objects that contain [path, gdbm_obj]
                    for gdbm_obj in self.gdbm_files:
                        for phrase in potential_match:
                            if phrase in gdbm_obj[1]:
                                log.debug("phrase matches = %s" % phrase)
                                log.debug("match offset = %s" % offset_match)

                                # Ignore matches that are just numbers
                                if phrase.isdigit():
                                    log.debug("phrase match are digits = %s" % phrase)
                                    continue

                                # If the chosen category is "geography," ignore matches that are found in the filter dbm file
                                if self.category == "geography" and phrase in self.filter_file:
                                    log.debug("phrase match is in filter dbm = %s" % phrase)
                                    continue

                                match_offset = offset_match[:] # Makes copy of offset_match
                                match_found = positive_match(phrase, match_offset)
                                matches.append(match_found)

        # Eliminates duplicates found in the all matches by making sure that no two matches have the same offset
        matches = sorted(matches, key=lambda positive_match: positive_match.offset)
        all_matches = []
        for match in matches:
            found = 0
            if not all_matches:
                all_matches.append(match)
                continue

            match_offset = match.getOffset()
            log.debug("match offset = %s" % match_offset)

            for element in all_matches:
                element_offset = element.getOffset()

                for index in element_offset:
                    if match_offset[0] == index:
                        # The case where the offset is found in the previous stored entry and the current match has MORE words than the previous match
                        # (Ex) chicago and offset = [923] versus chicago bears and offset = [923, 924]
                        if len(match_offset) > len(element_offset):
                            found = 1

                        # The case where the offset is found in the previous stored entry and the current match has LESS words than the previous match
                        # (Ex) baltimore ravens and offset = [880, 881] versus ravens and offset = [881]
                        elif len(match_offset) < len(element_offset):
                            found = 2

                        # The case where the offset is found in previous stored entry and current match has the SAME number of words as the previous match
                        # (Ex) dallas and offset = [24] versus dallas and offset = [24]
                        elif len(match_offset) == len(element_offset) and match.getMatch() == element.getMatch():
                            found = 2

            if found == 0: # The offsets have not been seen yet
                all_matches.append(match)
            elif found == 1:
                all_matches[-1] = match
            elif found == 2:
                continue
 
        return all_matches

    # Processes an html file. Assumes the html file contains html entities that need to be escaped and converted to unicode. 
    # Function escapes html entities to unicode, tokenizes the entire text, and sends it for processing.
    def processUnicodeString(self, string):
        log = logging.getLogger('classify')
        log.debug("text.processUnicodeString()")

        # Html entities consist of the format &...; What we want is the ... portion. That is why we separated into a group in the RE. 
        string_unicode = re.sub("&(#?\\w+);", self.substituteEntity, string)
        log.debug("string unicode = %s" % string_unicode)
        
        token = nltk.tokenize.WhitespaceTokenizer().tokenize(string_unicode)
        #token = nltk.wordpunct_tokenize(string_unicode)
        matches = self.processUnicodeText(token)

        return matches

    # Processes a text file. Assumes that text file contains unescaped unicode literals. 
    # Function decodes text into unicode, tokenizes the entire text, and sends it for processing.
    def processUTFString(self, string):
        log = logging.getLogger('classify')
        log.debug("text.processUTFString()")

        log.debug("string = %s" % string)
        string_utf = string.decode("utf-8")
        log.debug("string utf = %s" % string_utf)

        token = nltk.tokenize.WhitespaceTokenizer().tokenize(string_utf)
        #token = nltk.wordpunct_tokenize(string_ascii)
        matches = self.processUnicodeText(token)
    
        return matches

    # Function escapes all html entities and converts it to unicode
    def substituteEntity(self, match):
        log = logging.getLogger('classify')

        name = match.group(1)
        if name in htmlentitydefs.name2codepoint:
            return unichr(htmlentitydefs.name2codepoint[name])
        elif name.startswith("#"):
            try:
                return unichr(int(name[1:]))
            except:
                pass

        log.debug("Cannot replace html entities with corresponding UTF-8 characters")
        return '?'


