#ifndef RESIMPLE_H_
#define RESIMPLE_H_

#include "jsapi.h"

class RESimple {
 public:
  RESimple();
  ~RESimple();
  char *exec(const char *name);

 private:
  JSRuntime *rt;
  JSContext *cx;
  JSObject  *global;
};

#endif
