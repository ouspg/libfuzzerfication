#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "mysamplelib.h"

const char *_mytarget = "Fuzz in Style!";


int _cmp(const uint8_t *buf, size_t len, size_t size) {
  if ((size < 1) || (len > size))
    return 1;
  if (memcmp(buf, _mytarget, len))
    return 1;

  printf("%c", _mytarget[len-1]);
  return 0;
}


int mysamplefunction(const uint8_t *buf, size_t len) {

  int index = 1;
  int ret = 1;

  if (!_cmp(buf, index++, len))
    if (!_cmp(buf, index++, len))
      if (!_cmp(buf, index++, len))
        if (!_cmp(buf, index++, len))
          if (!_cmp(buf, index++, len))
            if (!_cmp(buf, index++, len))
              if (!_cmp(buf, index++, len))
                if (!_cmp(buf, index++, len))
                  if (!_cmp(buf, index++, len))
                    if (!_cmp(buf, index++, len))
                      if (!_cmp(buf, index++, len))
                        if (!_cmp(buf, index++, len))
                          if (!_cmp(buf, index++, len))
                            if (!_cmp(buf, index++, len))
                              if (!_cmp(buf, index++, len))
                                if (!_cmp(buf, index++, len))
                                  if (!_cmp(buf, index++, len))
                                    if (!_cmp(buf, index++, len))
                                      if (!_cmp(buf, index++, len))
                                        if (!_cmp(buf, index++, len))
                                          if (!_cmp(buf, index++, len))
                                            if (!_cmp(buf, index++, len))
                                              ret = 0;

  if (index > (strlen(_mytarget) + 1))
    ret = 0;

  if (ret) {
    printf("\n--- You fail ---\n");
  } else {
    printf("\n*** Grand success ***\n");
  }

  return ret;
}
