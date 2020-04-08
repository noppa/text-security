import os
import subprocess
from pathlib import Path

Path("/build-artifacts").mkdir(exist_ok=True)

# /shapes directory should be "bind mounted" from host when creating the container.
shape_files = os.listdir("/shapes")
font_template = Path("/workdir/font-template.ps").read_text()
# cidfontinfo = Path("/workdir/cidfontinfo").read_text()

for shape_file in shape_files:
  shape = Path(shape_file).read_text()
  shape_name = os.path.splitext(shape_file)[0]
  font_template_compiled = font_template.replace('<<SHAPE>>', shape)
  Path(f"/build-artifacts/font-{shape_name}.txt").write_text(font_template_compiled)
  subprocess.run("/workdir/generate-fonts.sh")

