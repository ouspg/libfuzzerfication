# libxml2

# Purpose

Libxml2 is the XML C parser and toolkit. It is developed for the Gnome project but is also used outside it. The fuzzer parses an XML in-memory document and builds a tree. Then it frees memory used by document and then it cleans up memory allocated by the library itself.

# Building

## Building container

```console
docker-compose build libxml2
```

# Running

## Starting the container

```console
docker-compose run libxml2
```

# Samples

Samples.tar.gz contains samples from [XML test suite](https://www.w3.org/XML/Test/).
