# Building from source

## Prerequisites
The build uses a Docker container to handle build dependencies,
so you'll need to have Docker installed.

## Cloning the repository
The repository has submodules, so you need to clone with `--recursive` flag
```sh
git clone --recursive https://github.com/noppa/text-security.git
```

## Building the Docker container
Running
```sh
./build-container.sh
```
will build a Docker container named "text-security-font-builder" with all the build dependencies.
This step only needs to be done once if you don't need to modify Dockerfile.  
Some warnings are expected and OK, as long as the process ends with message like
"Successfully built ...".

## Building the font
After you have built the container, running
```sh
./build-font.sh
```
will generate fonts for shapes in `src/shapes` folder.
The generated fonts and css will appear in `output` folder.  
Some warnings are expected and OK, as long as the process ends with message like
"Font file ... generated."

## Modifying and adding new shapes
The shape files live in `src/shapes`. They are defined using [Adobe Type 1 Font Format](https://www.adobe.com/content/dam/acom/en/devnet/font/pdfs/T1_SPEC.pdf),
which similar to what OpenType uses.
I know it's not exactly the easiest and most familiar format to specify shapes,
but that's what's consumed by the Adobe font tools that this project uses, so we'll just have to live with it.  
[disc.ps](src/shapes/disc.ps) and [circle.ps](src/shapes/circle.ps) have
some comments that might give you a good starting point to your own shapes.

## Watch mode
Developing a shape will likely involve lots of trial and error, so it's could be useful
if you didn't have to run the build command manually after every change.

Building the fonts with
```sh
./build-font.sh --watch
```
starts monitoring changes to the shape files and will automatically build the woff2 font
for your modified shape. Modify [text-security.html](text-security.html) to include your
font (if you are creating a new shape) and open it in a browser (modern browser, not IE)
to see the results.
