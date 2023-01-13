addpath("utils")
% Input language for this example is German
inputLanguage="de";

% Check if you already have the data set
if ~(isfile("text_data\questions_answers.mat"))
   downloadAndPreprocessDataset  
end

% Load the questions and answers
savedQuestionsAnswers = load("text_data\questions_answers.mat");
questions = savedQuestionsAnswers.questions;
answers = savedQuestionsAnswers.answers;

% Preprocess the questions before building the Knowledge Base
preProcessedQuestions = preprocessText(questions);

% Build the Knowledge Base containing the questions using TF-IDF with
% classic-BM25
bag = bagOfWords(preProcessedQuestions);
bag = removeInfrequentWords(bag,1);
questionsKB = tfidf(bag,preProcessedQuestions, IDFWeight="classic-bm25");

% Record audio from microphone, asking the question after you see the
% message 'Begin recording...'
tmpAudioFile = [tempname,'.wav'];
recordInputAudio(tmpAudioFile);

% Use speech2text to convert your question recording to text
speechObject = speechClient("Google","languageCode",inputLanguage);
[y,fs] = audioread(tmpAudioFile);
sound(y,fs)
pause(2)
tableOut = speech2text(speechObject,y,fs);
inputQuestion = tableOut.Transcript;

% Translate the question to English, the language of the KB
% Use the translate method from the Python file machine_translation.py
translatedQuery = py.utils.machine_translation.translate(sentence=tableOut.Transcript, source_language=inputLanguage, output_language="en");
englishQuery = string(translatedQuery(1));
disp("Your question in English was: " + englishQuery)

% Use your question to query the KB
query = preprocessText(englishQuery);
encodedQuery = tfidf(bag, query, IDFWeight="classic-bm25");
[Idx, ~] = knnsearch(questionsKB,encodedQuery, K=1);
retrievedAnswer = answers(Idx);
disp("Answer to your question in English: " + retrievedAnswer)

% Translate the question back to the input language, the language of the KB
translatedAnswer = py.utils.machine_translation.translate(sentence=answers(Idx), output_language=inputLanguage, source_language="en");

% Convert answer to speech using text2speech
[speech,fs] = text2speech(speechObject,string(translatedAnswer));
sound(speech,fs)