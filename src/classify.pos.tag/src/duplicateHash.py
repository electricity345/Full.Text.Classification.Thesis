import logging

class duplicateHash:
    _FALSE = 0
    _MATCH = 1

    def __init__(self):
        self.duplicate_matches = {} # Key = tag + word; Value = 'Type:Frequency'
        return  

    # Adds a new word to the duplicate hash
    def addWord(self, tag_word, value):
        self.duplicate_matches[tag_word] = value
        return

    # Checks if the word has already been seen before. If it has, it updates that word in the duplicate matches hash and returns 0 or 1 depending 
    # on whether or not the word is considered a match or not. Otherwise, it returns -1 to indicate that the word is not a duplicate.
    def checkPossibleMatch(self, tag_word):
        result = -1
        if 'false.' + tag_word in self.duplicate_matches:
            self.updateDuplicateMatches('false.' + tag_word)
            result = duplicateHash._FALSE
        elif 'match.' + tag_word in self.duplicate_matches:
            self.updateDuplicateMatches('match.' + tag_word)
            result = duplicateHash._MATCH

        return result

    # Updates the frequency of a specific word found in the duplicate matches matches by 1.
    def updateDuplicateMatches(self, tag_word):
        word_description = self.duplicate_matches[tag_word].split(":")
        word_frequency = int(word_description[1]) + 1
        word_description[1] = str(word_frequency)
        self.duplicate_matches[tag_word] = ":".join(word_description)

        return

    
