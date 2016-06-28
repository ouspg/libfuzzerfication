#include "libxslt/libxslt.h"
#include "libxslt/xsltconfig.h"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include <libxml/xmlmemory.h>
#include <libxml/HTMLtree.h>
#include <libxml/xmlIO.h>
#include <libxml/parser.h>
#include <libxml/uri.h>

#include "libxslt/xslt.h"
#include "libxslt/transform.h"
#include "libxslt/xsltutils.h"
#include "libxslt/extensions.h"
#include "libxslt/security.h"

#undef DEBUG_PRNT

/*
 * Adapted from xsltproc/xsltproc.c in libxslt delivery.
 * xsltproc/xsltproc.c  header / copyright:
 * xsltproc.c: user program for the XSL Transformation 1.0 engine
 *
 * See Copyright for the status of this software.
 *
 * daniel@veillard.com
 */

/*
 * Input from environment variables:
 * - XSLT_RAND_SEED integer for srand() seed, otherwise 0
 * - XSLT_HTML if non-zero, HTML parser used for input instead of XML
 * - XSLT_STYLE_FILE file path for static stylesheet. If not provided,
 *   fuzzed input is used instead.
 * - XSLT_INPUT_FILE file path for input file. If not provided,
 *   fuzzed input is used instead.
 *
 * Output from XSLT process is suppressed.
 */

#define MAX_PARAMETERS 64

static const char *params[MAX_PARAMETERS + 1] = { NULL };
static int xml_options = XML_PARSE_NOERROR | XML_PARSE_NOWARNING;
static int options = XSLT_PARSE_OPTIONS;
static int html = 0;

static int errorno = 0;

void ignore(void *ctx, const char *msg, ...) {
  // Error handler to avoid spam of error messages from libxml parser.
}

void xsltProcess(xmlDocPtr doc, xsltStylesheetPtr cur) {
  xmlDocPtr res;
  xsltTransformContextPtr ctxt;

  ctxt = xsltNewTransformContext(cur, doc);
  if (ctxt == NULL)
    return;
  xsltSetCtxtParseOptions(ctxt, options);
  res = xsltApplyStylesheetUser(cur, doc, params, NULL,
				NULL, ctxt);

  if (ctxt->state == XSLT_STATE_ERROR)
    errorno = 9;
  else if (ctxt->state == XSLT_STATE_STOPPED)
    errorno = 10;

  xsltFreeTransformContext(ctxt);
  xmlFreeDoc(doc);
  if (res == NULL) {
#ifdef DEBUG_PRNT
    fprintf(stderr, "no result\n");
#endif
    return;
  }

  xmlFreeDoc(res);
}

static bool doInit() {
  char *seed = getenv("XSLT_RAND_SEED");
  srand(seed != NULL ? (unsigned int)strtoul(seed, NULL, 10) : 0);

  if(getenv("XSLT_HTML"))
    html++;
#ifdef DEBUG_PRNT
  fprintf(stderr, "Init Done\n");
#endif

  xmlSetGenericErrorFunc(NULL, &ignore);

  return true;
}

extern "C" int LLVMFuzzerTestOneInput(const unsigned char *data, size_t size) {
  static bool init = doInit();

  int i;
  
  xsltStylesheetPtr cur = NULL;
  xmlDocPtr doc, style;
  xsltSecurityPrefsPtr sec = NULL;

  errorno = 0;

  xmlInitMemory();

  LIBXML_TEST_VERSION

  sec = xsltNewSecurityPrefs();
  xsltSetDefaultSecurityPrefs(sec);

  const char *style_file = reinterpret_cast<const char *>(getenv("XSLT_STYLE_FILE"));
  const char *input_file = reinterpret_cast<const char *>(getenv("XSLT_INPUT_FILE"));

  if(style_file) {
    style = xmlReadFile(style_file, NULL, xml_options);
  } else {
    style = xmlReadMemory(reinterpret_cast<const char *>(data), size, "noname.xsl", NULL, xml_options);
  }
  if(style == NULL) {
#ifdef DEBUG_PRNT
    fprintf(stderr, "cannot parse %s\n", style_file);
#endif
    cur = NULL;
    errorno = 4;
    goto done;
  } else {
    cur = xsltLoadStylesheetPI(style);
    if (cur != NULL) {
      /* it is an embedded stylesheet */
      xsltProcess(style, cur);
      xsltFreeStylesheet(cur);
      cur = NULL;
      goto done;
    }
    cur = xsltParseStylesheetDoc(style);
    if (cur != NULL) {
      if (cur->errors != 0) {
	errorno = 5;
	goto done;
      }
      i++;
    } else {
      xmlFreeDoc(style);
      errorno = 5;
      goto done;
    }
  }

  if ((cur != NULL) && (cur->errors == 0)) {
    doc = NULL;
#ifdef LIBXML_HTML_ENABLED
    if (html)
      if(input_file)
	doc = htmlReadFile(input_file, NULL, options);
      else
	doc = htmlReadMemory(reinterpret_cast<const char *>(data), size, "noname.html", NULL, options);
    else
#endif
      if(input_file)
	doc = xmlReadFile(input_file, NULL, xml_options);
      else
	doc = xmlReadMemory(reinterpret_cast<const char *>(data), size, "noname.xml", NULL, xml_options);
    if (doc == NULL) {
#ifdef DEBUG_PRNT
      fprintf(stderr, "unable to parse\n");
#endif
      errorno = 6;
    } else {
      xsltProcess(doc, cur);
    }
  }

done:
#ifdef DEBUG_PRNT
  fprintf(stderr, "Done %d\n", errorno);
#endif
  if (cur != NULL)
    xsltFreeStylesheet(cur);

  xsltFreeSecurityPrefs(sec);
  xsltCleanupGlobals();
  xmlCleanupParser();
  xmlMemoryDump();

  return 0;
}
