# Note: This script is supposed to be run inside the Docker container specified
# in Dockerfile, which is why all the file names here are absolute.

import os
import time
import subprocess

# Available in the Docker container.
import cssmin # pylint: disable=import-error

from pathlib import Path

watch_mode = "--watch" in os.sys.argv

shape_files = os.listdir("/src/shapes")
config_files = os.listdir("/src/font-config")
font_template = Path("/src/font-template.ps").read_text()
css_template = Path("/src/style-template.css").read_text()

css_file_contents = []

def get_shape_file_path(shape_file):
  return f"/src/shapes/{shape_file}"

def get_shape_mtime(shape_file):
  return os.path.getmtime(get_shape_file_path(shape_file))

def get_shape_name(shape_file):
  return os.path.splitext(shape_file)[0]

def prepare_font_config_file(shape_file):
  shape_name = get_shape_name(shape_file)
  shape = Path(get_shape_file_path(shape_file)).read_text()
  font_name = f"text-security-{shape_name}"
  font_template_compiled = font_template.replace("<<SHAPE>>", shape).replace("text-security", font_name)
  Path(f"/tmp/{shape_name}-font.txt").write_text(font_template_compiled)

def generate_font_for_shape(shape_name, skip_compatibility_fonts=False):
  extra_arg = "--no-compat" if skip_compatibility_fonts else ""
  subprocess.call(["/src/generate-fonts.sh", shape_name, extra_arg])

def build_all():
  for shape_file in shape_files:
    shape_name = get_shape_name(shape_file)
    font_name = f"text-security-{shape_name}"
    prepare_font_config_file(shape_file)
    # Replace <<SPACE>> placeholder in the font template with shape definition.
    shape_css = css_template.replace("text-security", f"text-security-{shape_name}")
    css_file_contents.append(shape_css)
    # Replace font name in font configuration files
    for config_file in config_files:
      config = Path(f"/src/font-config/{config_file}").read_text()
      config_with_corrected_name = config.replace("text-security", font_name)
      Path(f"/tmp/{shape_name}-{config_file}").write_text(config_with_corrected_name)
    
    generate_font_for_shape(shape_name)

  Path("/output/text-security.css").write_text(cssmin.cssmin("\n".join(css_file_contents)))


# Really simple polling-based watch mode implementation.
# Not super elegant but good enough for our needs.
def watch():
  file_mtimes = dict(zip(shape_files, map(get_shape_mtime, shape_files)))
  while True:
    try: time.sleep(2)
    except KeyboardInterrupt: break
    for shape_file in shape_files:
      mtime = get_shape_mtime(shape_file)
      if mtime != file_mtimes[shape_file]:
        file_mtimes[shape_file] = mtime
        prepare_font_config_file(shape_file)
        generate_font_for_shape(get_shape_name(shape_file), True)
        
build_all()
if watch_mode:
  watch()