#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

MODULE = Package::Anon  PACKAGE = Package::Anon

PROTOTYPES: DISABLE

SV *
_new_anon_stash (klass, name)
    SV *klass
    SV *name
  PREINIT:
    HV *stash;
    STRLEN namelen;
    char *namestr;
  CODE:
    stash = newHV();
    namestr = SvPV(name, namelen);
    hv_name_set(stash, namestr, namelen, 0);
    RETVAL = newRV_noinc((SV *)stash);
    sv_bless(RETVAL, gv_stashsv(klass, 0));
  OUTPUT:
    RETVAL

void
bless (stash, rv)
    SV *stash
    SV *rv
  PPCODE:
    sv_bless(rv, (HV *)SvRV(stash));
    PUSHs(rv);
