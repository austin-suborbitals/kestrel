#![no_std]
#![no_main]

//------------------------------------------------
//
// local modules
//
//------------------------------------------------


//------------------------------------------------
//
// entry
//
//------------------------------------------------

extern crate peregrine;                         // include OS building blocks
use peregrine::mcus::cortexm4::kinetis::k64;    // include the cpu definition and initialization


#[no_mangle]
pub fn entry(_: k64::K64) -> ! {
    loop { } // TODO: call for reset followed by an explicit halt to gate it from failure
}
