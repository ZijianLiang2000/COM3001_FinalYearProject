import pip
import sys
#
import aspect_based_sentiment_analysis as absa

from transformers import BertTokenizer

import spacy
spacy.prefer_gpu()

from flask import Flask, request
from transformers import BertTokenizer
import tensorflow as tf
from tensorflow.python.client import device_lib
from flask_restful import Resource, Api
from flask import jsonify

import sys

device_lib.list_local_devices()
print("Num GPUs Available: ", len(tf.config.experimental.list_physical_devices('GPU')))



text = "Lots of great stuff for really good prices. Huge variety too as it is a super store. Amazing range of vegan options I dont think I've seen that many in any other stores at all. Good for students too as there is lots of cheap ready meals, pot noodles, bulk and tinned stuff etc.//Another Asda. Great shop with great prices. It has a dedicated car park on top of its, so you won't need to worry about finding a place to park. It's also located near a shopping centre, so it's a great place to go to.//Happy shopping here always"
text += "since we used to live in erith now moved. Loads of selection to choose from I just use self checkout it’s very easy self service. Loads of tolls and options. But 4 stars not 5 is because bottled water by Asda is never in stock always shelf empty and I’ve been coming here since 2018…//I was in Asda, Bexleyheath today and to my dismay there were more staff not wearing masks than staff that were wearing masks. Most of those that were wearing masks had them over their chins and not covering their mouths or noses. There was also a large number of customers not wearing masks yet not challenged by staff. I understand they can be uncomfortable but when there are signs telling everyone to wear masks why do the staff feel it does not apply to them. It's very disappointing  to see this with the way  things are  at the moment, one thing that cheered me up was watching an Asda TV ad telling us how all their staff wear masks and ask customers to do the same.//Very lovely man called bamil made our pizza for us today been getting one made every Friday "
text += "normally for years now and never hand someone as helpful friendly and make us exactly what we have asked for happy to help and with a smile on his face/"
# text = input(sys.argv[1])
# get comments from user input args, so that call script from rails and inputting comments
# comment_arr = sys.argv[1]
text_arr = text.split("//")

print("Running script")

print(text_arr)
#
def absa_pred(text_arr):

    response = {}

    count = 0

    for text in text_arr:

        nlp = absa.load()
        text = (text)

        food, service, price, ambience = nlp(text, aspects=['food', 'service', 'price', 'ambience'])

        aspects = ['food', 'service', 'price', 'ambience']

        name = 'absa/classifier-rest-0.2'
        model = absa.BertABSClassifier.from_pretrained(name)
        tokenizer = BertTokenizer.from_pretrained(name)
        professor = absa.Professor()  # Explained in detail later on.
        text_splitter = absa.sentencizer()  # The English CNN model from SpaCy.
        nlp = absa.Pipeline(model, tokenizer, professor, text_splitter)

        # Break down the pipeline `call` method.
        task = nlp.preprocess(text=text, aspects=aspects)
        tokenized_examples = nlp.tokenize(task.examples)
        input_batch = nlp.encode(tokenized_examples)
        output_batch = nlp.predict(input_batch)
        predictions = nlp.review(tokenized_examples, output_batch)
        completed_task = nlp.postprocess(task, predictions)

        recognizer = absa.aux_models.BasicPatternRecognizer()
        nlp = absa.load(pattern_recognizer=recognizer)
        completed_task = nlp(text=text, aspects=aspects)
        food, service, price, ambience = completed_task.examples

        aspect_result = [food, service, price, ambience]

        for aspect in aspect_result:
            response[str(count)] = absa.summary(aspect)

        count += 1
    return response

# print(absa_pred(text_arr))

app = Flask(__name__)
api = Api(app)


class status(Resource):
    def get(self):
        try:
            return {'data': 'Api running'}
        except(error):
            return {'data': error}

class Sum(Resource):
    def get(self, a, b):
        return jsonify({'data': a+b})

api.add_resource(status, '/')
api.add_resource(Sum, '/add/<int:a>,<int:b>')

if __name__ == '__main__':
    app.run()



