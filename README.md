DNS Noise

DNS Noise is a simple Bash script that generates realistic DNS traffic to create background noise. It randomly queries a mix of real popular domains and fake domains using multiple public resolvers (DoH-compatible), making traffic analysis and profiling more difficult.
Features

    Sends randomized DNS queries (real + fake)

    Rotates logs automatically

    Uses multiple public DNS resolvers of your choice. (e.g. Quad9, Cloudflare, Google)

    Adjustable query volume and delay

    Use with a wordlist for mixed "real" and fake querys.

