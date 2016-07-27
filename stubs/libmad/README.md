# libmad

# Purpose

Libmad is MPEG audio decoder library. Libmad can be used to minimize mp3-sample collection but it cannot be currently used for fuzzing libmad because it's not currenlty in active development.

# Building

## Building container

```console
docker-compose build libmad
```

# Running

## Starting the container

```console
docker-compose run libmad
```
# Samples

Currently samples.tar.gz contains one self made sample.

# Warning!

Libmad is not currently under active development but it's still widely in use.

Bug has been found from it:
* Invalid memory read in mad_bit_skip, @attekett tried to find active developer, but all contact channels seem inactive.

* Website at http://www.underbit.com/products/mad/ has contact info for licensing and couple of links to mailing-lists that haven't been used in ages(for anything else than spam).

* MAD also has a SourceForge project at https://sourceforge.net/projects/mad/.
* Last update 2013 and last release update 2004. All 40 bugs reported to SourceForge are with status "open" and no activity from developer side.

* @attekett decided to report this issue to Ubuntu Launchpad. https://bugs.launchpad.net/ubuntu/+source/libmad/+bug/1494164 (restricted view)

Timeline:
```
2015-09-10 - Reported to launchpad
2015-10-29 - Status update New->Confirmed
forgotten
2016-07-07 - Requested info about current state
2016-07-07 - Got reply that no one is "actively" looking at the issue. Also got recommendation to contact oss-security mailing-list, if someone over there would be interested.
```
