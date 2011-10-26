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
new (sv)
    SV *sv
  CODE:
    RETVAL = new_anon_stash(gv_stashsv(sv, 0));
  OUTPUT:
    RETVAL

SV *
create (classname)
    char *classname
  CODE:
    RETVAL = new_anon_stash(gv_stashpvn(classname, strlen(classname), GV_ADD));
  OUTPUT:
    RETVAL

void
bless (stash, rv)
    SV *stash
    SV *rv
  PPCODE:
    sv_bless(rv, (HV *)SvRV(stash));
    PUSHs(rv);
