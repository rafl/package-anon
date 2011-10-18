#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

static SV *
new_anon_stash (HV *klass, SV *name)
{
    SV *obj;
    HV *stash = newHV();
    STRLEN len;
    char *namestr;

    if (name && SvOK(name)) {
        namestr = SvPV(name, len);
    }
    else {
        namestr = "__ANON__";
        len = 8;
    }

    hv_name_set(stash, namestr, len, 0);
    obj = newRV_noinc((SV *)stash);
    sv_bless(obj, klass);
    return obj;
}

MODULE = Package::Anon  PACKAGE = Package::Anon

PROTOTYPES: DISABLE

SV *
new (klass, name=NULL)
    SV *klass
    SV *name
  CODE:
    RETVAL = new_anon_stash(gv_stashsv(klass, 0), name);
  OUTPUT:
    RETVAL

void
bless (stash, rv)
    SV *stash
    SV *rv
  PPCODE:
    sv_bless(rv, (HV *)SvRV(stash));
    PUSHs(rv);
