This is the generator repository for my apkovl.
I outlined how this works in [a blog post](https://nero.github.io/2018/04/16/automated-provisioning-using-apkovl.html).

## Building an docker image

```
make $HOST.apkovl.tar.gz
docker build --build-arg apkovl=$HOST.apkovl.tar.gz .
```
