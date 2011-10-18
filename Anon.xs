#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

MODULE = Package::Anon  PACKAGE = Package::Anon

PROTOTYPES: DISABLE

SV *
_new_anon_stash (klass, name=NULL)
    SV *klass
    SV *name
  PREINIT:
    SV *obj;
    HV *stash, *ourstash;
    STRLEN len;
    char *namestr;
  PPCODE:
    stash = newHV();
    ourstash = gv_stashsv(klass, 0);

    if (name && SvOK(name)) {
        namestr = SvPV(name, len);
    }
    else {
        namestr = "__ANON__";
        len = 8;
    }

    hv_name_set(stash, namestr, len, 0);
    obj = newRV_noinc((SV *)stash);
    sv_bless(obj, ourstash);

    mPUSHs(obj);

void
bless (stash, rv)
    SV *stash
    SV *rv
  PPCODE:
    sv_bless(rv, (HV *)SvRV(stash));
    PUSHs(rv);
