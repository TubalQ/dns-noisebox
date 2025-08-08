#!/bin/bash

# DNS resolver to query (ex.Cloudflare or google)
RESOLVERS=("9.9.9.9" "1.1.1.1" "8.8.8.8" "94.140.14.14" "208.67.222.222")

# number of queries/run
NUM_QUERIES=15

# Wordlist for random domains
WORDLIST="/root/noise_box/words.txt"
# List of TLDs to randomize
TLDS=("com" "net" "org" "info" "biz" "io" "co" "app" "xyz" "se" "nu" "it" "ai" "me" "dev")

# Log file
LOGFILE="/var/log/dns_noise.log"
MAXSIZE=50000  # Max storlek i byte (~50 KB)

# Log rotation
if [[ -f "$LOGFILE" && $(stat -c%s "$LOGFILE") -gt $MAXSIZE ]]; then
  mv "$LOGFILE" "$LOGFILE.1"
  touch "$LOGFILE"
fi


# List of real domains
REAL_DOMAINS=(
  # Put your custom domains here

  # Italian Domains
  "google.it" "youtube.com" "facebook.com" "instagram.com" "amazon.it" "repubblica.it" "corriere.it" "gazzetta.it" \
  "ansa.it" "larepubblica.it" "lastampa.it" "ilsole24ore.com" "mediaworld.it" "esselunga.it" "coop.it" "eprice.it" \
  "subito.it" "immobiliare.it" "tripadvisor.it" "zalando.it" "ebay.it" "penna.it" "sky.it" "rai.it" "spotify.com" \
  "netflix.it" "tinder.com" "bakeca.it" "ilfattoquotidiano.it" "fanpage.it" "tgcom24.mediaset.it" "tg24.sky.it" \
  "rai.it" "mediaset.it" "calcio.com" "mondadori.it" "unieuro.it" "libreriauniversitaria.it" "mondadoristore.it" \
  "mondo.it" "ilgusto.it" "ristorante.it" "directory.it" "virgo.it" "terremoto.it" "idea.it" "blogspot.it" \
  "wordpress.com" "blog.it" "panoramio.com" "iltempo.it" "milanotoday.it" "romaoggi.it" "torinoggi.it" \
  "napolifree.it" "firenzeweb.it" "forlìtoday.it" "bolognatoday.it" "palermotoday.it" "genovatoday.it" \
  "toscana.it" "duedipuglia.it" "ilcentro.it" "abruzzo.it" "ilmessaggero.it" "tg1.it" "cronaca.it" "calcio24.it" \
  "cialdashop.it" "idee.it" "donnaoggi.it" "avis.it" "omegle.it" "universitaly.it" "registro.it" \
  "ministerodellauniversita.it" "anime.it" "videomedicina.it" "salute.it" "farmacia.it" "territorio.it" \
  "comuni-italiani.it" "ailm.com" "mio.it" "studiareinitalia.it" "consob.it" "torino.it"

  # English / American domains
  "google.com" "youtube.com" "facebook.com" "instagram.com" "reddit.com" "amazon.com" "wikipedia.org" "nytimes.com" \
  "cnn.com" "foxnews.com" "nbcnews.com" "abcnews.go.com" "washingtonpost.com" "latimes.com" "hulu.com" \
  "netflix.com" "disneyplus.com" "hbo.com" "spotify.com" "apple.com" "microsoft.com" "espn.com" "weather.com" \
  "accuweather.com" "usatoday.com" "forbes.com" "businessinsider.com" "techcrunch.com" "cnet.com" "pcmag.com" \
  "wired.com" "theverge.com" "mashable.com" "lifehacker.com" "medium.com" "buzzfeed.com" "vice.com" "rollingstone.com" \
  "people.com" "npr.org" "pbs.org" "time.com" "politico.com" "theatlantic.com" "axios.com" "vox.com" \
  "independent.co.uk" "bloomberg.com" "reuters.com" "gatech.edu" "stanford.edu" "mit.edu" "harvard.edu" \
  "cbsnews.com" "techtarget.com" "quora.com" "stackoverflow.com" "github.com" "bitbucket.org" "linkedin.com" \
  "indeed.com" "monster.com" "glassdoor.com" "airbnb.com" "booking.com" "trulia.com" "zillow.com" \
  "realtor.com" "craigslist.org" "hackernews.com" "privacytools.io" "duckduckgo.com" "startpage.com" "qwant.com" \
  "tiktok.com"
) 


# Create log if not existing 
touch "$LOGFILE"
chmod 600 "$LOGFILE"

# Run queries
for i in $(seq 1 $NUM_QUERIES); do
  TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

  if (( RANDOM % 10 < 7 )); then
    # Jabberish-Domains
    WORD=$(shuf -n 1 "$WORDLIST" | tr -d "'")
    TLD=$(shuf -n 1 -e "${TLDS[@]}")
    DOMAIN="${WORD}.${TLD}"
    TYPE="NONSENSE"
  else
    # Real domains
    BASE_DOMAIN=$(shuf -n 1 -e "${REAL_DOMAINS[@]}")
    if (( RANDOM % 4 == 0 )); then
      SUB=$(shuf -n 1 -e "${SUBDOMAINS[@]}")
      DOMAIN="${SUB}.${BASE_DOMAIN}"
    else
      DOMAIN="$BASE_DOMAIN"
    fi
    TYPE="REAL"
  fi

  RESOLVER=$(shuf -n 1 -e "${RESOLVERS[@]}")
  dig @"$RESOLVER" "$DOMAIN" +timeout=2 +tries=1 +short > /dev/null
  echo "$TIMESTAMP [$TYPE] ($RESOLVER) $DOMAIN" >> "$LOGFILE"
  sleep $(awk -v min=0.5 -v max=2.5 'BEGIN{srand(); print min+rand()*(max-min)}')
done


  # Choose a random resolver
  RESOLVER=$(shuf -n 1 -e "${RESOLVERS[@]}")

  # hit via selected resolver
  dig @"$RESOLVER" "$DOMAIN" +timeout=2 +tries=1 +short > /dev/null

  # log
  echo "$TIMESTAMP [$TYPE] ($RESOLVER) $DOMAIN" >> "$LOGFILE"

  # randomize delay
  sleep $(awk -v min=0.5 -v max=2.5 'BEGIN{srand(); print min+rand()*(max-min)}')
done
