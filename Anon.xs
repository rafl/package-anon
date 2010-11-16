#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

static HV *stash_stash;

MODULE = Object::Anon  PACKAGE = Object::Anon

PROTOTYPES: DISABLE

void
_anon_bless (rv)
    SV *rv
  PREINIT:
    HV *stash;
    SV *stash_obj;
  PPCODE:
    stash = newHV();
    hv_name_set(stash, "__ANON__", 8, 0);
    stash_obj = newRV_noinc((SV *)stash);
    sv_bless(stash_obj, stash_stash);
    sv_bless(rv, stash);
    mPUSHs(stash_obj);

BOOT:
    stash_stash = gv_stashpvs("Object::Anon::Stash", 0);
    if (!stash_stash)
        croak("Object::Anon::Stash isn't loaded");
