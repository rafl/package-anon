#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

static SV *
new_anon_stash (HV *klass)
{
    SV *obj;
    HV *stash = newHV();
    hv_name_set(stash, "__ANON__", 8, 0);
    obj = newRV_noinc((SV *)stash);
    sv_bless(obj, klass);
    return obj;
}

MODULE = Package::Anon  PACKAGE = Package::Anon

PROTOTYPES: DISABLE

SV *
new (klass)
    SV *klass
  CODE:
    RETVAL = new_anon_stash(gv_stashsv(klass, 0));
  OUTPUT:
    RETVAL

void
bless (stash, rv)
    SV *stash
    SV *rv
  PPCODE:
    sv_bless(rv, (HV *)SvRV(stash));
    PUSHs(rv);
