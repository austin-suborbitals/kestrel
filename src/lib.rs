#![no_std]
#![feature(start)]
#![feature(lang_items)]
#![crate_type="staticlib"]

//------------------------------------------------
//
// modules
//
//------------------------------------------------

extern crate peregrine;
use peregrine::mcus::kinetis::k64;

pub mod except;

#[allow(dead_code)] // TODO: temporary
const WDOG: k64::Watchdog = k64::Watchdog(0x1000 as *const u8);
