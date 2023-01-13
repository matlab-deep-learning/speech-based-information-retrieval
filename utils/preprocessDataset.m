function preprocessDataset(datasetLocation)
    % For this example use only the train split
    fileName = fullfile(datasetLocation,"train.jsonl"); 
    qaEntries = readlines(fileName);

    questions = strings(1, length(qaEntries));
    answers = strings(1, length(qaEntries));
    for i=1:length(qaEntries)-1
        qaEntry = jsondecode(qaEntries(i));
        question = qaEntry.question;
        choicesText = {question.choices(:).text};
        choicesKey = [question.choices(:).label];
        correctAnswer = choicesKey == qaEntry.answerKey;
        questions(i) = string(qaEntry.question.stem);
        answers(i) = string(choicesText{correctAnswer});
    end

    mkdir text_data;
    save('text_data/questions_answers.mat', "questions", "answers");