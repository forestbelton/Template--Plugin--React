#include "RESimple.h"
#include <stdexcept>
#include "jsapi.h"

/* The class of the global object. */
static JSClass global_class = { "global",
                                JSCLASS_NEW_RESOLVE | JSCLASS_GLOBAL_FLAGS,
                                JS_PropertyStub,
                                JS_PropertyStub,
                                JS_PropertyStub,
                                JS_StrictPropertyStub,
                                JS_EnumerateStub,
                                JS_ResolveStub,
                                JS_ConvertStub,
                                NULL,
                                JSCLASS_NO_OPTIONAL_MEMBERS
};

/* The error reporter callback. */
static void reportError(JSContext *cx, const char *message, JSErrorReport *report) {
  fprintf(stderr, "%s:%u:%s\n",
          report->filename ? report->filename : "[no filename]",
          (unsigned int) report->lineno,
          message);
}

static JSObject *buildGlobalObject(JSContext *cx) {
  /* Enter a request before running anything in the context */
  JSAutoRequest ar(cx);

  /* Create the global object in a new compartment. */
  JSObject *global = JS_NewCompartmentAndGlobalObject(cx, &global_class, NULL);
  if (global == NULL)
    return NULL;

  /* Set the context's global */
  JS_SetGlobalObject(cx, global);

  /* Populate the global object with the standard globals, like Object and Array. */
  if (!JS_InitStandardClasses(cx, global))
    return NULL;

  return global;
}

RESimple::RESimple() {
  /* Create a JS runtime. */
  this->rt = JS_NewRuntime(8L * 1024L * 1024L);
  if(this->rt == NULL)
    throw std::runtime_error("JS_NewRuntime failed");

  /* Create a context. */
  this->cx = JS_NewContext(rt, 8192);
  if(this->cx == NULL)
    throw std::runtime_error("JS_NewContext failed");

  JS_SetOptions(cx, JSOPTION_VAROBJFIX);
  JS_SetErrorReporter(cx, reportError);

  this->global = buildGlobalObject(this->cx);
  if(this->global == NULL)
    throw std::runtime_error("JS_NewCompartmentAndGlobalObject failed");
}

char *RESimple::exec(const char *data) {
  jsval  rval;
  JSBool ok;
  char   *s = NULL;

  ok = JS_EvaluateScript(this->cx, this->global, data, strlen(data),
                         "inline", 0, &rval);

  if(ok) {
    JSString *jss = JS_ValueToString(this->cx, rval);

    if(jss) {
      s = JS_EncodeString(this->cx, jss);
    }
  }

  return s;
}

RESimple::~RESimple() {
  JS_DestroyContext(this->cx);
  JS_DestroyRuntime(this->rt);
}
