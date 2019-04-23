mod app;
use http::{Request, Response};
use std::env;

fn main() {
  match app::Config::new() {
    Ok(cfg) => {
      app::run(cfg);
      println!("ok");
    }
    Err(err) => println!("error: {}", err),
  }
}
