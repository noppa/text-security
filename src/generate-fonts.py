import os
import subprocess
from pathlib import Path

# /shapes directory should be "bind mounted" from host when creating the container.
shape_files = os.listdir("/src/shapes")
config_files = os.listdir("/src/font-config")
font_template = Path("/src/font-template.ps").read_text()

for shape_file in shape_files:
  (shape_name, ext) = os.path.splitext(shape_file)
  # Replace <<SPACE>> placeholder in the font template with shape definition.
  shape = Path(f"/src/shapes/{shape_file}").read_text()
  font_name = f"text-security-{shape_name}"
  font_template_compiled = font_template.replace("<<SHAPE>>", shape).replace("text-security", font_name)
  Path(f"/tmp/{shape_name}-font.txt").write_text(font_template_compiled)

  # Replace font name in font configuration files
  for config_file in config_files:
    config = Path(f"/src/font-config/{config_file}").read_text()
    config_with_corrected_name = config.replace("text-security", font_name)
    Path(f"/tmp/{shape_name}-{config_file}").write_text(config_with_corrected_name)
    subprocess.call(["/src/generate-fonts.sh", shape_name])
