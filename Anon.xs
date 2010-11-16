#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

static HV *stash_stash;

static SV *
new_anon_stash ()
{
    SV *obj;
    HV *stash = newHV();
    hv_name_set(stash, "__ANON__", 8, 0);
    obj = newRV_noinc((SV *)stash);
    sv_bless(obj, stash_stash);
    return obj;
}

MODULE = Object::Anon  PACKAGE = Object::Anon::Stash

PROTOTYPES: DISABLE

SV *
new (class)
  CODE:
    RETVAL = new_anon_stash();
  OUTPUT:
    RETVAL

void
bless (stash, rv)
    SV *stash
    SV *rv
  PPCODE:
    sv_bless(rv, (HV *)SvRV(stash));
    PUSHs(rv);

BOOT:
    stash_stash = gv_stashpvs("Object::Anon::Stash", 0);
    if (!stash_stash)
        croak("Object::Anon::Stash isn't loaded");
