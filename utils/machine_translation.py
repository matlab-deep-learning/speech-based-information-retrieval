from transformers import M2M100ForConditionalGeneration, M2M100Tokenizer
import torch

def translate(sentence, source_language, output_language):
    # Initial configuration
    device = "cuda:0" if torch.cuda.is_available() else "cpu"

    # Initialize the model
    model = M2M100ForConditionalGeneration.from_pretrained("facebook/m2m100_418M").to(device)

    # Initialize the tokenizer
    tokenizer = M2M100Tokenizer.from_pretrained("facebook/m2m100_418M")
    
    # Define source language
    tokenizer.src_lang = source_language

    tokenized_text = tokenizer(sentence, return_tensors='pt', padding=True, truncation=True, max_length=256).to(device)
    generated_tokens = model.generate(**tokenized_text, forced_bos_token_id=tokenizer.get_lang_id(output_language))
    translated_sentence = tokenizer.batch_decode(generated_tokens, skip_special_tokens=True)
    
    # Print translated sentences
    print(translated_sentence)
    return translated_sentence