import tweepy
import json

with open("apikeys.json") as f:
    apikeys = json.load(f)

CONSUMER_KEY = apikeys["CONSUMER_KEY"]
CONSUMER_SECRET = apikeys["CONSUMER_SECRET"]
ACCESS_TOKEN = apikeys["ACCESS_TOKEN"]
ACCESS_TOKEN_SECRET = apikeys["ACCESS_TOKEN_SECRET"]

# Authenticate to Twitter
auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.set_access_token(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

# Create API object
api = tweepy.API(auth)

api.verify_credentials()
print("Authentication OK")

#api.update_status("Test tweet from Tweepy Python")
