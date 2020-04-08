import os
import subprocess
from pathlib import Path

Path("/build-artifacts").mkdir(exist_ok=True)

# /shapes directory should be "bind mounted" from host when creating the container.
shape_files = os.listdir("/src/shapes")
font_template = Path("/src/font-template.ps").read_text()
# cidfontinfo = Path("/workdir/cidfontinfo").read_text()

for shape_file in shape_files:
  (shape_name, ext) = os.path.splitext(shape_file)
  if ext != ".ps": continue
  shape = Path(f"/src/shapes/{shape_file}").read_text()
  font_template_compiled = font_template.replace('<<SHAPE>>', shape)
  Path(f"/build-artifacts/font-{shape_name}.txt").write_text(font_template_compiled)
  subprocess.call(["/src/generate-fonts.sh"])
