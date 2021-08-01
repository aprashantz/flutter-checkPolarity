from textblob import TextBlob


def getPolarity(data):
    sentiment_data = TextBlob(data).sentiment
    clean_polarity = str(float("{0:.4f}".format(sentiment_data.polarity)))
    return clean_polarity
