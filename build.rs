use std::{env, error::Error, ffi::OsString, path::PathBuf};

fn main() -> Result<(), Box<dyn Error>> {
    let out_dir = PathBuf::from(
        get_target_dir()
            .or_else(get_default_target_dir)
            .ok_or("Output directory not found")?,
    );

    let kernel_path = PathBuf::from(
        env::var_os("CARGO_BIN_FILE_KERNEL_kernel").ok_or("Compiled kernel image not found")?,
    );
    let mut img_path = out_dir;
    img_path.push("os.img");

    let img_path = img_path
        .to_str()
        .ok_or("Final OS image path cantains invalid (non UTF-8) characters")?;

    bootloader::BiosBoot::new(&kernel_path).create_disk_image(img_path.as_ref())?;
    println!("cargo::rustc-env=OS_IMG_PATH={img_path}");
    Ok(())
}

fn get_target_dir() -> Option<OsString> {
    env::var_os("CARGO_TARGET_DIR")
}

fn get_default_target_dir() -> Option<OsString> {
    env::var_os("CARGO_MANIFEST_DIR").map(|dir| {
        let mut dir = PathBuf::from(dir);
        dir.push("target");
        dir.into_os_string()
    })
}
