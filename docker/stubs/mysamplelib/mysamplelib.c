#include <stdio.h>
#include <stdint.h>
#include <string.h>

const char *_mytarget = "Fuzzing in Style ..............";


int _cmp(const uint8_t *buf, size_t len) {
  if (len > strlen(_mytarget))
    return 1;
  if (memcmp(buf, _mytarget, len))
    return 1;

  printf("%c", _mytarget[len-1]);
  return 0;
}


int mysamplefunction(const uint8_t *buf, size_t len) {

  int index = 0;
  int ret = 1;

  if (!_cmp(buf, index++))
    if (!_cmp(buf, index++))
      if (!_cmp(buf, index++))
        if (!_cmp(buf, index++))
          if (!_cmp(buf, index++))
            if (!_cmp(buf, index++))
              if (!_cmp(buf, index++))
                if (!_cmp(buf, index++))
                  if (!_cmp(buf, index++))
                    if (!_cmp(buf, index++))
                      if (!_cmp(buf, index++))
                        if (!_cmp(buf, index++))
                          if (!_cmp(buf, index++))
                            if (!_cmp(buf, index++))
                              if (!_cmp(buf, index++))
                                if (!_cmp(buf, index++))
                                  if (!_cmp(buf, index++))
                                    if (!_cmp(buf, index++))
                                      if (!_cmp(buf, index++))
                                        if (!_cmp(buf, index++))
                                          if (!_cmp(buf, index++))
                                            if (!_cmp(buf, index++))
                                              if (!_cmp(buf, index++))
                                                if (!_cmp(buf, index++))
                                                  if (!_cmp(buf, index++))
                                                    if (!_cmp(buf, index++))
                                                      if (!_cmp(buf, index++))
                                                        ret = 0;

  if (ret) {
    printf("\nYou fail.\n");
  } else {
    printf("\nGrant success!\n");
  }

  return ret;
}
