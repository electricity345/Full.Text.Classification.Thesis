import codecs
import htmlentitydefs
import json
import logging
import nltk # Uses NLTK Version 2.0b9
import os
import re

import classifications

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
        self.classifications = classifications.classifications(gdbm_files, filter_file, category)
        self.path = path

        return  

    # Breaks the noun_buffer into various noun phrases by eliminating any tags that are not nouns
    # Returns a list of noun phrases and a list of tags that match each noun phrase
    def breakNounPhrase(self, noun_buffer, tag_buffer, offset_match):
        log = logging.getLogger('classify')
        log.debug("text.breakNounPhrase()")

        all_noun_phrases = []
        all_noun_phrases_tags = []
        all_offset_matches = []
        noun_phrase = []
        noun_phrase_tags = []
        noun_phrase_offsets = []
        for index in range(len(noun_buffer)):
            if tag_buffer[index] == "NNP" or tag_buffer[index] == "NNPS" or tag_buffer[index] == "NN" or tag_buffer[index] == "NNS" or tag_buffer[index] == ".":
                noun_phrase.append(noun_buffer[index])
                noun_phrase_tags.append(tag_buffer[index])
                noun_phrase_offsets.append(offset_match[index])
            elif noun_phrase: # If not a noun, it checks if noun_phrase is empty and if it's not, it adds the content to the list of noun phrases found
                all_noun_phrases.append(noun_phrase)
                all_noun_phrases_tags.append(noun_phrase_tags)
                all_offset_matches.append(noun_phrase_offsets)
                noun_phrase = []
                noun_phrase_tags = []
                noun_phrase_offsets = []

        # If the last word in the noun buffer is a noun, it then adds the entire noun_phrase accumulated to the list of noun phrases found
        if noun_phrase: 
            all_noun_phrases.append(noun_phrase)
            all_noun_phrases_tags.append(noun_phrase_tags)
            all_offset_matches.append(noun_phrase_offsets)
                
        log.debug("all noun phrases = %s" % all_noun_phrases)
        log.debug("all noun phrases tags = %s" % all_noun_phrases_tags)
        log.debug("all noun phrases offsets = %s" % all_offset_matches)
        return all_noun_phrases, all_noun_phrases_tags, all_offset_matches

    # Creates a json file containing the editible options for an entry found in the classification list
    def createEditJSONFile(self):
        # Path = self.path/edits.json
        path = os.path.join(self.path, 'edits.json')
        json_file = codecs.open(path, mode='w', encoding='utf-8')

        edit_hash = self.classifications.getEditHash()
        json.dump(edit_hash, json_file)

        return

    # Creates a string out of the words stored in the noun_buffer - DONE
    def createNounPhrase(self, noun_buffer, tag_buffer):
        log = logging.getLogger('classify')
        log.debug("text.createNounPhrase()")
        possible_match = ""
        counter = 0

        for word in noun_buffer:
            # First word in buffer does not have a space before it, and "POS" and "." symbol should not have a space between it and the previous word
            if counter != 0 and tag_buffer[counter] != "POS" and tag_buffer[counter] != ".":
                word = ' ' + word
        
            possible_match += word
            counter += 1 

        log.debug("possible match = %s" % possible_match)
        return possible_match

    # Creates a json file containing the best result found for an entry found in the classification list
    def createResultJSONFile(self):
        # Path = self.path/edits.json
        path = os.path.join(self.path, 'results.json')
        json_file = codecs.open(path, mode='w', encoding='utf-8')

        result_list = []
        result_stack = self.classifications.getResultStack()
        for element in result_stack:
            for key in element.keys():
                result_list.append(element[key])

        json.dump(result_list, json_file)

        return

    def processText(self, tokens):
        log = logging.getLogger('classify')
        log.debug("text.processText()")
        log.debug("tokens = %s" % tokens)

        pos_tagged = nltk.pos_tag(tokens)
        log.debug("pos tagged = %s" % pos_tagged)

        grammar = """
                   NP: 
                      {<NNP>+ <IN> <DT>? <NNP>* <NNPS>*}
                      {<NNP>+ <.> <NNP|.>*}
                      {<NNP>+ <CC> <NNP>+ <NNPS>*}
                      {<NNP>+ <CC> <NNPS>+ <NNP>*}
                      {<NNP>+ <NN>+ <NNS>*}
                      {<NNP>+ <NNS>+ <NN>*}
                      {<NNP>+ <NNPS>+ <IN>* <NNP>*}
                      {<NNPS>+ <NNP>+ <NNPS>*}
                      {<NNP>+}
                      {<NNPS>+}
                      {<NN>+}
                      {<NNS>+}
        """
        geo_chunking = nltk.RegexpParser(grammar)
        geo_tree = geo_chunking.parse(pos_tagged)
        new_pos_tagged = nltk.chunk.tree2conlltags(geo_tree)
        log.debug("new pos tagged = %s" % new_pos_tagged)

        noun_flag = 0 # Used to distinguish the end of a noun phrase
        matches = []
        noun_buffer = []
        tag_buffer = []
        offset_match = []

        for index in range(len(new_pos_tagged)):
            tag_word = new_pos_tagged[index]

            if (tag_word[2] == 'B-NP' and noun_flag == 0) or (tag_word[2] == 'I-NP' and noun_flag == 1):
                noun_flag = 1
                noun_buffer.append(tag_word[0])
                tag_buffer.append(tag_word[1])
                offset_match.append(index)
            # B-NP indicates the start of a new noun phrase
            elif (tag_word[2] == 'B-NP' and noun_flag == 1): 
                log.debug("noun buffer - end of noun phrase = %s" % noun_buffer)
                log.debug("tag_buffer - end of noun phrase = %s" % tag_buffer)

                match_list = self.processNounBuffer(noun_buffer, tag_buffer, offset_match)
                if match_list:
                    matches.extend(match_list) # concatenates lists

                # Clears the old noun buffer and adds new word to noun buffer
                noun_buffer = []
                tag_buffer = []
                offset_match = []
                noun_flag = 1
                noun_buffer.append(tag_word[0])
                tag_buffer.append(tag_word[1])
                offset_match.append(index)
            # Indicates that the current word is not a noun and now the noun buffer should be evaluated
            elif noun_flag == 1: 
                log.debug("noun buffer - end of noun phrase = %s" % noun_buffer)
                log.debug("tag_buffer - end of noun phrase = %s" % tag_buffer)
                      
                match_list = self.processNounBuffer(noun_buffer, tag_buffer, offset_match)
                if match_list:
                    matches.extend(match_list) # concatenates lists

                noun_buffer = []
                tag_buffer = []
                offset_match = []
                noun_flag = 0

        # Indicates that the current word is not a noun and now the noun buffer should be evaluated
        if noun_flag == 1: 
            log.debug("noun buffer - end of noun phrase = %s" % noun_buffer)
            log.debug("tag_buffer - end of noun phrase = %s" % tag_buffer)

            match_list = self.processNounBuffer(noun_buffer, tag_buffer, offset_match)
            if match_list:
                matches.extend(match_list) # concatenates lists

            noun_buffer = []
            tag_buffer = []
            offset_match = []
            noun_flag = 0

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
            initial_offset = match_offset[0]
            all_matches_offset = all_matches[-1].getOffset()
            log.debug("all matches offset = %s" % all_matches_offset)
            for index in all_matches_offset:
                # The case where the offset is found in the previous stored entry and the current match has MORE words than the previous match
                # (Ex) chicago and offset = [923] versus chicago bears and offset = [923, 924]
                if len(match_offset) > len(all_matches_offset) and index == initial_offset:
                    found = 1
                    break
                # The case where the offset is found in the previous stored entry and the current match has LESS words than the previous match
                # (Ex) baltimore ravens and offset = [880, 881] versus ravens and offset = [881]
                elif len(match_offset) < len(all_matches_offset) and index == initial_offset:
                    found = 2
                    break

                # The case where the offset is found in the previous stored entry and the current match has the SAME number of words as the previous match
                # (Ex) dallas and offset = [24] versus dallas and offset = [24]
                elif len(match_offset) == len(all_matches_offset) and index == initial_offset:
                    found = 2
                    break

            if found == 0: # The offsets have not been seen yet
                all_matches.append(match)
            elif found == 1:
                all_matches[-1] = match
            elif found == 2:
                continue

        return all_matches

    # Takes a noun phrase and sees if it matches a word in the given classification words list - DONE
    # Returns a list of matches in the noun buffer
    def processNounBuffer(self, noun_buffer, tag_buffer, offset_match):
        log = logging.getLogger('classify')
        log.debug("text.processNounBuffer()")

        # If the chosen category is "geography", we optimize it so that it looks for words that have their first letter upper-cased.
        # This helps to reduce the number of false positives found.
        if self.category == "geography" and noun_buffer[0][0].isupper() == False:
            return []

        matches = []
        possible_match = self.createNounPhrase(noun_buffer, tag_buffer)
        match_value = self.classifications.isMatch(possible_match)
        log.debug("match value = %s" % match_value)

        if match_value == 1: # Match Found
            match_offset = offset_match[:] # Makes copy of offset_match
            match_found = positive_match(possible_match, match_offset)
            matches.append(match_found)
            return matches
                
        original_noun_buffer_length = len(noun_buffer)
        all_noun_phrases, all_noun_phrases_tags, all_offset_matches = self.breakNounPhrase(noun_buffer, tag_buffer, offset_match)

        # Iterates through all of the noun phrases created from breaking the initial noun phrase and sees if any of them are matches
        for index in range(len(all_noun_phrases)):
            noun_buffer = all_noun_phrases[index]
            tag_buffer = all_noun_phrases_tags[index]
            offset_match = all_offset_matches[index]
            match_value = 0

            # Checks to see if there were changes made to the initial noun_buffer
            if original_noun_buffer_length != len(all_noun_phrases):
                possible_match = self.createNounPhrase(noun_buffer, tag_buffer)
                match_value = self.classifications.isMatch(possible_match)
             
            if match_value == 1: # Match Found
                match_offset = offset_match[:] # Makes copy of offset_match
                match_found = positive_match(possible_match, match_offset)
                matches.append(match_found)
                continue

            leftmost_nouns = [] 
            leftmost_tags = [] 
            leftmost_noun_offset = [] 
            while (match_value == 0 and len(noun_buffer) > 1):
                single_noun = noun_buffer[0]
                single_noun_offset = [offset_match[0]]
 
                # Combination of all possible left nouns [[the st louis], [st louis], [louis]]
                # (Ex) The St. Louis Blues
                if not leftmost_nouns:
                    leftmost_nouns.append([noun_buffer[0]])
                    leftmost_tags.append([tag_buffer[0]])
                    leftmost_noun_offset.append([offset_match[0]])
                else:
                    for i in range(len(leftmost_nouns)):
                        leftmost_nouns[i].append(noun_buffer[0])
                        leftmost_tags[i].append(tag_buffer[0])
                        leftmost_noun_offset[i].append(offset_match[0])

                    leftmost_nouns.append([noun_buffer[0]])
                    leftmost_tags.append([tag_buffer[0]])
                    leftmost_noun_offset.append([offset_match[0]])
                
                noun_buffer = noun_buffer[1:] # Removes the first word of the noun buffer
                tag_buffer = tag_buffer[1:] # Removes the first word of the tag buffer
                offset_match = offset_match[1:]

                log.debug("single_noun = %s" % single_noun)
                log.debug("single noun offset = %s" % single_noun_offset)
                log.debug("leftmost nouns = %s" % leftmost_nouns)
                log.debug("leftmost tags = %s" % leftmost_tags)
                log.debug("leftmost noun offset = %s" % leftmost_noun_offset)
                log.debug("noun_buffer = %s" % noun_buffer)
                log.debug("tag_buffer = %s" % tag_buffer)
                log.debug("offset match = %s" % offset_match)
            
                # Checks the first word in the noun buffer
                match_value = self.classifications.isMatch(single_noun)
                log.debug("match_value - single noun = %s" % match_value)

                if match_value == 1: # Match Found
                    match_offset = single_noun_offset[:] # Makes copy of offset_match
                    match_found = positive_match(single_noun, match_offset)
                    matches.append(match_found)

                # Checks the left most nouns accumulated from discarding the left most word in the noun buffer after each iteration
                if len(leftmost_nouns) > 1:
                    for i in range(len(leftmost_nouns)):
                        possible_match = self.createNounPhrase(leftmost_nouns[i], leftmost_tags[i])
                        match_value = self.classifications.isMatch(possible_match)
                        log.debug("match_value - leftmost noun = %s" % match_value)

                        if match_value == 1: # Match Found
                            match_offset = leftmost_noun_offset[i][:] # Makes copy of offset_match
                            match_found = positive_match(possible_match, match_offset)
                            matches.append(match_found)

                # Checks the rest of the words in the noun buffer
                possible_match = self.createNounPhrase(noun_buffer, tag_buffer)
                match_value = self.classifications.isMatch(possible_match)
                log.debug("match_value - noun buffer = %s" % match_value)

                if match_value == 1: # Match Found
                    match_offset = offset_match[:] # Makes copy of offset_match
                    match_found = positive_match(possible_match, match_offset)
                    matches.append(match_found)

        return matches

    # Processes a text file. Assumes that text file contains unescaped unicode literals. 
    # Function decodes text into unicode, tokenizes the entire text, and sends it for processing.
    def processUTFString(self, string):
        log = logging.getLogger('classify')
        log.debug("text.processUTFString()")

        string_utf = string.decode("utf-8")
        log.debug("string utf = %s" % string_utf)
        
        token = nltk.wordpunct_tokenize(string_utf)
        matches = self.processText(token)
    
        return matches

    # Processes an html file. Assumes the html file contains html entities that need to be escaped and converted to unicode. 
    # Function escapes html entities to unicode, tokenizes the entire text, and sends it for processing.
    def processUnicodeString(self, string):
        log = logging.getLogger('classify')
        log.debug("text.processUnicodeString()")

        # Html entities consist of the format &...; What we want is the ... portion. That is why we separated into a group in the RE. 
        string_unicode = re.sub("&(#?\\w+);", self.substituteEntity, string)
        log.debug("string unicode = %s" % string_unicode)
        
        token = nltk.wordpunct_tokenize(string_unicode)
        matches = self.processText(token)

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


