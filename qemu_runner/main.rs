// TODO: make a proper cli

use std::{error::Error, process::Command};

fn main() -> Result<(), Box<dyn Error>> {
    let image_path = env!("OS_IMG_PATH");
    dbg!(image_path);
    let qemu_exe = "qemu-system-x86_64";
    let misc_flags = "-accel kvm -cpu host -monitor stdio";
    let drive_flags = "format=raw,index=0,media=disk";

    Command::new(qemu_exe)
        .args(misc_flags.split_whitespace())
        .arg("-drive")
        .arg(format!("file={image_path},{drive_flags}"))
        .spawn()?
        .wait()?;

    Ok(())
}
