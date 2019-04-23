type port_t = u16;

pub struct Config {
  port: u16,
}

impl Config {
  pub fn new() -> Result<Config, &'static str> {
    let cfg = Config {};
    return Ok(cfg);
  }
}

pub fn run(cfg: Config) -> Result<(), String> {
  let err: String = String::from("I am error");
  return Err(err);
}
