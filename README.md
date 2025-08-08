## dns-noise

1. Clone this repo.
2. Add your wordlist to `words.txt`.
3. Edit both scripts:

**In `dns_noise.sh`:**


WORDLIST="/your/path/words.txt"


**In `noisebox-crontab.sh`:**


/your/path/dns_noise.sh


You can then add the random-time script to crontab (as root or user):


crontab -e


Example:


@reboot /your/path/noisebox-crontab.sh




### What it does

The script generates DNS traffic to make your real network activity harder to profile. It mixes nonsense domain queries with real, popular domains. Each run logs to `/var/log/dns_noise.log`, which is auto-rotated after 50KB.

Especially useful if you're using DNS-over-HTTPS (DoH) and want to further mask your real profile by mixing in cleartext DNS traffic.

You can edit:

* `NUM_QUERIES` – number of queries per run
* `REAL_DOMAINS` – popular domains
* `TLDS` – fake TLDs used for nonsense domains
* Delay range (0.5–2.5 seconds)

---

### Important

This tool is experimental and should be used responsibly. Don’t abuse public resolvers. Don't do anything illegal. It's intended to enhance privacy through traffic obfuscation, not to attack or spam others.





