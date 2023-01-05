import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const packages = YAML.parse(
  fs.readFileSync(path.join(__dirname, "../../packages.yaml"), "utf-8")
);

export { packages };
