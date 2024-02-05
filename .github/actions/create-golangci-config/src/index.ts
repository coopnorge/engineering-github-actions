import core from "@actions/core";
import * as fs from "fs";

try {
  const configs = ["yml", "yaml", "toml", "json"].map(
    (x) => `./.golangci.${x}`
  );

  configs.forEach((config) => {
    if (fs.existsSync(config) && fs.lstatSync(config).isFile()) {
      console.error(`Found existing config: ${config}`);
      process.exit(0);
    }
  });

  console.error(`Config not found. Writing default config to ${configs[0]}`);
  const defaultConfig = fs.readFileSync("./default_config.yaml", "utf8");
  fs.writeFileSync(configs[0], defaultConfig, "utf8");
} catch (e) {
  core.setFailed(`An unexpected error occurred: ${e}`);
}
