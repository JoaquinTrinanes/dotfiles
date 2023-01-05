const log = (entry) => {
  const writeToStderr = (data) => {
    process.stderr.write(`${data}\n`);
  };

  const logTypes = {
    error: { format: chalk.bold.red, label: "ERROR" },
    warn: { format: chalk.bold.yellow, label: "WARN" },
    ok: { format: chalk.bold.green, label: " OK " },
    info: { format: chalk.bold.blue, label: "INFO" },
  };

  const formatError = ({ kind, data }) =>
    `${logTypes[kind].format(
      `[${logTypes[kind].label || kind.toUpperCase()}]`
    )} ${data}`;

  if (typeof entry === "string") {
    $.log({ kind: "info", data: entry });
    return;
  }

  switch (entry.kind) {
    case "error":
    case "warn":
    case "ok":
    case "info":
      writeToStderr(formatError(entry));
      break;
    default:
      originalLog(entry);
      break;
  }
};

const error = (data) => log({ kind: "error", data });
const warn = (data) => log({ kind: "warn", data });
const ok = (data) => log({ kind: "ok", data });
const debug = (data) => log({ kind: "info", data });

// export default log;
export { error, warn, ok, debug };
