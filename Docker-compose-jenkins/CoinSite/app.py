import requests
from flask import Flask, render_template
from redis import Redis

app = Flask(__name__)
redis = Redis(host='redis', port=6379)

API_KEY = "YOUR_ALPHA_VANTAGE_API_KEY"

coins = [
    {'name': 'Tesla', 'symbol': 'TSLA', 'worth': ''},
    {'name': 'Amazon', 'symbol': 'AMZN', 'worth': ''},
    {'name': 'Apple', 'symbol': 'AAPL', 'worth': ''},
    {'name': 'Microsoft', 'symbol': 'MSFT', 'worth': ''},
    {'name': 'Google', 'symbol': 'GOOGL', 'worth': ''},
    {'name': 'Twitter', 'symbol': 'TWTR', 'worth': ''},
    {'name': 'Netflix', 'symbol': 'NFLX', 'worth': ''},
    {'name': 'Adobe', 'symbol': 'ADBE', 'worth': ''}
]


def get_realtime_price(symbol):
    url = f"https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol={symbol}&apikey={API_KEY}"
    response = requests.get(url)
    data = response.json()

    if 'Global Quote' in data and '05. price' in data['Global Quote']:
        return data['Global Quote']['05. price']
    else:
        return 'N/A'


@app.route('/')
def index():
    for coin in coins:
        coin['worth'] = get_realtime_price(coin['symbol'])

    redis.hincrby('entrance_count', 'total', 1)
    count = redis.hget('entrance_count', 'total').decode('utf-8')

    return render_template("index.html", count=int(count), coins=coins)


@app.route('/get_price/<symbol>')
def get_price(symbol):
    return get_realtime_price(symbol)


if __name__ == '__main__':
    app.run(debug=True)
