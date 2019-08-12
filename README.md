Simple asyncronous interface to search on github. EventMachine + Sinatra + WebSocket + Redis. 
Also, it uses handmade background jobs with minimal latency on start (instead of big and slow Sidekiq). 

# How it works

![Github Lazy Searcher](https://user-images.githubusercontent.com/418868/62869015-a1574e00-bd1f-11e9-8a71-6d809031310a.png)

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
