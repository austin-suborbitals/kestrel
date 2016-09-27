#![no_std]
#![no_main]

extern crate peregrine;                         // include OS building blocks
use peregrine::mcus::cortexm4::kinetis::k64;    // include the cpu definition and initialization


//------------------------------------------------
// constants
//------------------------------------------------

pub const WDOG_TICKS: u32 = 120_000;            // 120MHz * 1ms == we have 1 ms to finish a loop    // TODO: is 1ms a reasonable constraint?

//------------------------------------------------
// entry
//------------------------------------------------

/// Sets the watchdog values to the settings we will run under. Watchdog is not enabled here.
///
/// The Watchdog assumes it has been unlocked via either `WachDog::init()` during initial booting
/// or manual calling afterwards.
fn setup_wdog(wdog: &k64::wdog::Watchdog) {
    wdog.enable_in_debug();             // we always want to debug, especially in release
    wdog.set_timeout(WDOG_TICKS);
}

/// Main entry to the program.
#[no_mangle]
pub fn entry(mcu: k64::K64) -> ! {
    // initialize the watchdog with our runtime settings
    setup_wdog(&mcu.wdog);

    // now that we have finished startup, get governed
    // TODO: should we lock the watchdog too?
    mcu.wdog.enable();

    // and start the processing loop
    loop {
        mcu.wdog.refresh();                     // always refresh at the end of the loop
    }

    loop {} // TODO: we can do better
}
