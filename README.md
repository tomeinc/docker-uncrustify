# Docker containers for every* verison of [uncrustify](https://github.com/uncrustify/uncrustify)

## versions
Versions are named for uncrustify tags
* tomeinc/uncrustify:0.54
* tomeinc/uncrustify:0.56
* tomeinc/uncrustify:0.57
* tomeinc/uncrustify:0.58
* tomeinc/uncrustify:0.59
* tomeinc/uncrustify:0.60
* tomeinc/uncrustify:0.61
* tomeinc/uncrustify:0.62
* tomeinc/uncrustify:0.63
* tomeinc/uncrustify:0.64
* tomeinc/uncrustify:0.65
* tomeinc/uncrustify:0.66
* tomeinc/uncrustify:0.66.1
* tomeinc/uncrustify:0.67
* tomeinc/uncrustify:0.68
* tomeinc/uncrustify:0.68.1
* tomeinc/uncrustify:0.69.0
* tomeinc/uncrustify:0.70.0
* tomeinc/uncrustify:0.70.1
* tomeinc/uncrustify:0.71.0
* tomeinc/uncrustify:0.72.0
* tomeinc/uncrustify:0.73.0
* tomeinc/uncrustify:latest (last release)
* tomeinc/uncrustify:dev (master branch)

*except 0.55, I can't make it build

## usage
```
docker run \
    --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD":/workdir \
    -w /workdir  \
    "tomeinc/uncrustify:0.68" \
    uncrustify --check -c mystyle.cfg somefile.c
```


## credits
The organization and scripts are heavily based on [silkeh/docker-clang](https://github.com/silkeh/docker-clang)
