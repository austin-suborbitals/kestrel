#![no_std]
#![feature(start)]
#![feature(lang_items)]
#![crate_type="staticlib"]

//------------------------------------------------
//
// modules
//
//------------------------------------------------

#![cfg(vendor = "kinetis")]
#[cfg(mcu = "k64")]

extern crate peregrine;
use peregrine::mcus::kinetis::k64;

pub mod except;


static WDOG: k64::Watchdog = k64::Watchdog(0x1000 as *const u8);
