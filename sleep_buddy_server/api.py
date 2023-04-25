import fitbit
import matplotlib.pyplot as plt
import gather_keys_oauth2 as Oauth2
import numpy as np
from datetime import datetime, timedelta
import pandas as pd
import csv
import re
import seaborn as sns
from scipy.stats import linregress 

def accessData(watch_id, start_date):
    id_keys = {
        "ndsmarthealth3": ["2397F3", "e1646fb2b6c32b40b864c4db7d1c0857"]
    }
    USER_ID, CLIENT_SECRET = id_keys[watch_id]

    server = Oauth2.OAuth2Server(USER_ID, CLIENT_SECRET)
    server.browser_authorize()
    ACCESS_TOKEN = str(server.fitbit.client.session.token['access_token'])
    REFRESH_TOKEN = str(server.fitbit.client.session.token['refresh_token'])

    auth2_client = fitbit.Fitbit(USER_ID, CLIENT_SECRET, oauth2 = True, access_token = ACCESS_TOKEN, refresh_token = REFRESH_TOKEN)
    API_ENDPOINT = "https://api.fitbit.com"

    sd = datetime.strptime(start_date, "%m/%d/%Y")
    ed = sd + timedelta(days=13)
    request_url = f"{API_ENDPOINT}/1.2/user/-/sleep/date/{sd.year}-{sd.month:02}-{sd.day:02}/{ed.year}-{ed.month:02}-{ed.day:02}.json"
    print("https://api.fitbit.com/1.2/user/-/sleep/date/2020-01-01/2020-01-05.json")
    print(request_url)
    # date_list = [str(start_date_obj + timedelta(days=x)) for x in range(14)]
    sleep_data = auth2_client.make_request(request_url)["sleep"]
    for sleep in sleep_data:
        print(sleep)

if __name__ == "__main__":
    accessData("ndsmarthealth3", "03/21/2023")

