from flask import Flask, render_template
import os
import random

app = Flask(__name__)

# list of alpaca images
images = [
    
    "https://media3.giphy.com/media/QoncgdHL9TDm0ePySn/giphy.gif?cid=ecf05e47eqnn1ipow6vxu4crrsdhd46t2za1sh2bmgyvp0y6&ep=v1_gifs_search&rid=giphy.gif&ct=g",
    "https://media2.giphy.com/media/c8pTpUed78PSg/giphy.gif?cid=ecf05e473chqondqlden75jnqclpmstfpdwqkgxlshn134oo&ep=v1_gifs_related&rid=giphy.gif&ct=g",
    "https://media4.giphy.com/media/xT1XGDKwOxacd92rYI/giphy.gif?cid=ecf05e47e7yh3uq69oehvlgd2ubcycp6y0pa8c319uoxk5e0&ep=v1_gifs_related&rid=giphy.gif&ct=g",
    "https://media.tenor.com/YOFx5Hvx4IgAAAAC/alpaca-cute.gif",
    "https://media3.giphy.com/media/lMC3CNFmxmlNo7TmeP/giphy.gif",
    
]



@app.route("/")
def index():
    url = random.choice(images)
    return render_template("index.html", url=url)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))
