addpath("utils")

% Input language for this example is English
inputLanguage="en";

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
speechObjectS2T = speechClient("wav2vec2.0");
[y,fs] = audioread(tmpAudioFile);
sound(y,fs)
pause(2)
tableOut = speech2text(speechObjectS2T,y,fs);
inputQuestion = join(tableOut.Transcript');
disp("Your question was: " + inputQuestion)

% Use your question to query the KB
query = preprocessText(inputQuestion);
encodedQuery = tfidf(bag, query, IDFWeight="classic-bm25");
[Idx, ~] = knnsearch(questionsKB,encodedQuery, K=1);
retrievedAnswer = answers(Idx);
disp("Answer to your question: " + retrievedAnswer)

% Convert answer to speech using text2speech
speechObjectT2S = speechClient('Google','languageCode',inputLanguage);
[speech,fs] = text2speech(speechObjectT2S,string(retrievedAnswer));
sound(speech,fs)
