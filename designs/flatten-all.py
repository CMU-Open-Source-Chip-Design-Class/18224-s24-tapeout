import glob
import subprocess
import yaml
import sys

# Usage: pass a list of designs as args
# If no args passed, will flatten all designs in the current directory

def yosys_script(name, files):
    files = " ".join([f"{name}/src/{fn}" for fn in files])

    return f"read_verilog -sv {files}; synth -flatten -top toplevel_chip; setundef -undriven -zero; setundef -zero; async2sync; synth -top toplevel_chip; rename toplevel_chip {name}; write_verilog -attr2comment {name}/flattened.v; check; stat;"

def run_yosys(name, files):
    out_raw = subprocess.check_output(["yosys", "-p", yosys_script(name, files)]).decode()
    out = out_raw.split("Printing statistics.")[-1].split("End of script")[0].split("Warnings")[0].strip()
    cells = [x for x in out.splitlines() if "Number of cells:" in x][0]
    cells = int(cells.split(":")[-1].strip())
    print(f"cell count: {cells}")
    with open(f"{name}/flattened_stats.txt", "w+") as f:
        f.write(out+"\n")

    with open(f"{name}/flatten-log.txt", "w+") as f:
        f.write(out_raw+"\n")

    return cells

if len(sys.argv) > 1:
    g = sys.argv[1]
else:
    g = "d*"

total = 0
for des in sorted(list(glob.glob(g))):
    with open(f"{des}/info.yaml") as f:
        data = yaml.load(f, Loader=yaml.Loader)

    print(f"Processing design (standard format) {des}... ", end="", flush=True)
    assert data["project"]["top_module"] == "toplevel_chip"
    sources = data["project"]["source_files"]

    total += run_yosys(des, sources)

print("Total cell count", total)
