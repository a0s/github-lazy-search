Simple asyncronous interface to search on github. EventMachine + Sinatra + WebSocket + Redis. 
Also, it uses handmade background jobs with minimal latency on start (instead of big and slow Sidekiq). 

# How it works

![Github Lazy Searcher](https://user-images.githubusercontent.com/418868/62869015-a1574e00-bd1f-11e9-8a71-6d809031310a.png)

# How to run in Docker

```bash
git clone https://github.com/a0s/github-lazy-search.git
cd github-lazy-search
docker build --tag github-lazy-search .
export GITHUB_TOKEN=% YOUR GITHUB TOKEN HERE % 
docker docker run --rm -it --env GITHUB_TOKEN=${GITHUB_TOKEN} -p 9000:9000 github-lazy-search
# open http://localhost:9000 in browser
```

# Know issues
## libffi.la

If you have macOS Mojave you may got this on `bundle install`:

```
ld: library not found for -lgcc_s.10.4
clang: error: linker command failed with exit code 1 (use -v to see invocation)
make[3]: *** [libffi.la] Error 1
make[2]: *** [all-recursive] Error 1
make[1]: *** [all] Error 2
```

Use `LDFLAGS` and `PKG_CONFIG_PATH` to override this bug:

```bash
brew install libffi
export LDFLAGS="-L/usr/local/opt/libffi/lib"
export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"
bundle install
```
