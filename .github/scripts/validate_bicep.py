import json
import subprocess
from pathlib import Path


root = Path(__file__).resolve().parents[2]
output = root / "build"
output.mkdir(exist_ok=True)
sources = sorted(root.glob("[0-9]*/*/main.bicep"))
if not sources:
    raise SystemExit("No Bicep entry points found.")
failed = []
for source in sources + sorted(root.glob("[0-9]*/*/*.bicepparam")):
    relative = source.relative_to(root)
    target = output / (str(relative).replace("/", "__") + ".json")
    command = "build-params" if source.suffix == ".bicepparam" else "build"
    result = subprocess.run(
        ["az", "bicep", command, "--file", str(source), "--outfile", str(target)],
        cwd=root,
        text=True,
        capture_output=True,
        timeout=120,
    )
    print(result.stdout, end="")
    print(result.stderr, end="")
    if result.returncode or "warning " in result.stderr.lower():
        failed.append(str(relative))
        continue
    document = json.loads(target.read_text(encoding="utf-8-sig"))
    if "$schema" not in document:
        failed.append(str(relative))
    print(f"Compiled and linted: {relative}")
if failed:
    raise SystemExit("Bicep errors or warnings: " + ", ".join(failed))
print(f"Verified {len(sources)} Bicep entry points and parameter files; no Azure deployment performed.")
