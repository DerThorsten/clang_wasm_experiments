import os
from pathlib import Path

this_dir = Path(os.path.dirname(os.path.abspath(__file__)))
clang_resource_dir = this_dir /'deploy_dedicated'/ 'clang_resources'


# recursively get all files in the clang_resource_dir
files = []
for root, dirs, fs in os.walk(clang_resource_dir):
    for f in fs:
        full = Path(root) / f

        # relaive to clang_resource_dir
        rel = full.relative_to(clang_resource_dir)
        files.append(rel)
     

# write the list of files to a json file
import json
with open(this_dir /'deploy_dedicated'/'clang_resource_files.json', 'w') as f:
    json.dump([str(f) for f in files], f, indent=4)
