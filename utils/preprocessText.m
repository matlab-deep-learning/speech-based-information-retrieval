function documents = preprocessText(textData)
    documents = tokenizedDocument(textData);
    documents = lower(documents);
    documents = addPartOfSpeechDetails(documents);
    documents = normalizeWords(documents,'Style','lemma');
    documents = erasePunctuation(documents);
end