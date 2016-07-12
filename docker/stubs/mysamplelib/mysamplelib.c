#include <stdio.h>
#include <string.h>

const char *_mytarget = "Fuzzing in Style ..............";

inline int _cmp(const char *buf, size_t len) {
  if (len > strlen(_mytarget))
    return 1;
  if (strncmp(buf, _mytarget, len))
    return 1;

  printf("%c", _mytarget[len-1]);
  return 0;
}


int fuzzinginstyle(const char *buf) {

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


/*
int main(int argc, char *argv[]) {

  if (argc != 2) {
    fprintf(stderr, "Usage: %s <test input string>\n", argv[0]);
    return 1;
  }

  return fuzzinginstyle(argv[1]);
}
*/ 
