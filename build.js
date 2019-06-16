const fs = require('fs')
const childProcess = require('child_process')
const {promisify} = require('util')
const SvgPath = require('svgpath')
const svg = require('svg2ttf/lib/svg')
const sfnt = require('svg2ttf/lib/sfnt')
const svgson = require('svgson')

const codepoints = 0x10f7be
const names = ['disc']
const br = '\n'
const readFile = promisify(fs.readFile)
const writeFile = promisify(fs.writeFile)
const joinWith = (list, fn) => list.map(fn).join('')
const tmpDir = './tmp'
const distDir = './bin'

for (const dir of [tmpDir, distDir]) {
	if (!fs.existsSync(dir)) {
		fs.mkdirSync(dir)
	}
}

const promises = names.map(async symbolName => {
	const fontName = `text-security-${symbolName}`
	const results = []
	for (let i = 0; i < codepoints; i++) {
		results.push(
			`<map code="0x${i.toString(16)}" name="${fontName}" />`
		)
	}

	const svgInfo = await readFile(`./assets/${symbolName}.svg`, 'utf8').then(svgson.parse)
	const {d} = svgInfo.children[0].attributes
	const [, , width, height] = svgInfo.attributes.viewBox.split(' ').map(_ => parseInt(_))

	const contours = joinWith(
		svgToContours({width, height, d}),
		contour => `
		<contour>
			${joinWith(contour.points, pt => `
				<pt x="${pt.x}" y="${pt.y}" on="${Number(pt.onCurve)}" />`)}
		</contour>
	`)

	const ttglyph = `
	<TTGlyph name="${fontName}" xMin="0" yMin="0" xMax="${width}" yMax="${height}">
	${contours}
	<instructions />
	</TTGlyph>
`

	const lines = br + results.join(br) + br
	const tmpFile = `${tmpDir}/${fontName}.ttx`
	const distFile = `${distDir}/${fontName}.woff`

	// Take template.ttx and replace placehodlers with actual values.
	const ttxFile = (await readFile('./template.ttx', 'utf8'))
		.replace(/{{cmap}}/g, lines)
		.replace(/{{ttglyph}}/g, ttglyph)
		.replace(/{{name}}/g, fontName)
		.replace(/{{width}}/g, width)
	
	// Generate intermediate ttx file
	await writeFile(tmpFile, ttxFile)
	// Generate woff file from the ttx
	await spawn('ttx', ['-f', '-o', distFile, '--flavor', 'woff', tmpFile])
})

Promise.all(promises)
	.then(() => readFile('./style-template.css', 'utf8'))
	.then(styleTemplate => {
		const css = names.map(name => styleTemplate.replace(/{{name}}/g, name)).join(br)
		return writeFile('./bin/text-security.css', css)
	})
	.then(
		() => console.log('Done!'),
		(e) => console.error('Build failed.', e))


/**
 * Creates a list of "contour" objects that are later
 * used for the TTGlyph section of the ttx file, wich
 * describes the actual shape of the glyph.
 * 
 * This function is inspired by / taken from a script by Vitaly Puzrin and Sergey Batishchev
 * https://github.com/fontello/svg2ttf/blob/c33a126920f46b030e8ce960cc7a0e38a6946bbc/index.js
 * and modified to better fit the code style of this script.
 * 
 * Original license:
 * MIT https://github.com/fontello/svg2ttf/blob/c33a126920f46b030e8ce960cc7a0e38a6946bbc/LICENSE
 * 
 * Copyright for the original source: Vitaly Puzrin
 * Author of the original source: Sergey Batishchev
 *
 */
function svgToContours({width, height, d}) {
	const accuracy = Math.max(width, height) * 0.0006
	const svgPath = new SvgPath(d)
		.abs()
		.unshort()
		.unarc()
		.iterate((segment, index, x, y) => svg.cubicToQuad(segment, index, x, y, accuracy))

	const sfntContours = svg.toSfntCoutours(svgPath)

	return sfntContours.map(sfntContour => {
		const contour = new sfnt.Contour()

		contour.points = sfntContour.map(sfntPoint => {
			const point = new sfnt.Point()

			point.x = sfntPoint.x
			point.y = sfntPoint.y
			point.onCurve = sfntPoint.onCurve
			return point
		})

		return contour
	})
}

function spawn(cmd, args) {
	return new Promise((resolve, reject) => {
		childProcess.spawn(cmd, args, {stdio: 'inherit'})
			.on('exit', _ => _ === 0 ? resolve() : reject(_))
	})
}
