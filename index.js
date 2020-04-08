// const opentype = require('opentype.js')

// See https://stackoverflow.com/a/27863181/6184698
const ANCHOR_DISTANCE_RATIO = 0.552284749831
const anchorDistance = Math.round(ANCHOR_DISTANCE_RATIO * 35)

const anchorPoints = [
	{
		point: [35, 70],
		ctrl1: [0, 35 + anchorDistance],
		ctrl2: [35 - anchorDistance, 70],
	},
	{
		point: [70, 35],
		ctrl1: [35 + anchorDistance, 70],
		ctrl2: [70, 35 + anchorDistance],
	},
	{
		point: [35, 0],
		ctrl1: [70, 35 - anchorDistance],
		ctrl2: [35 + anchorDistance, 0],
	},
	{
		point: [0, 35],
		ctrl1: [35 - anchorDistance, 0],
		ctrl2: [0, 35 - anchorDistance],
	}
]
const startPoint = {
	point: [0, 35],
}

// The coordinates above are relative to 0, 0 but we want
// the circles to be centered a bit. Add some space to x, y
// coordinates to achieve that.
// const shift = [10, Math.round(250/2 - 70)]
// for (const a of [...anchorPoints, startPoint]) for (const [, values] of Object.entries(a)) {
// 	values[0] += shift[0]
// 	values[1] += shift[1]
// }

// console.log(JSON.stringify([startPoint, ...anchorPoints], null, 2))

// Make coords relative
let prev = startPoint.point
for (const anchor of anchorPoints) {
	const [x, y] = prev
	const [ctrl1X, ctrl1Y] = anchor.ctrl1
	prev = [...anchor.point]
	anchor.ctrl1[0] -= x
	anchor.ctrl1[1] -= y
	const [ctrl2X, ctrl2Y] = anchor.ctrl2
	anchor.ctrl2[0] -= ctrl1X
	anchor.ctrl2[1] -= ctrl1Y
	anchor.point[0] -= ctrl2X
	anchor.point[1] -= ctrl2Y
}

console.log(
	anchorPoints.map(_ => `${_.ctrl1.concat(_.ctrl2, _.point).map(_ => _ * 4).join(' ')} rrcurveto`).join('\n')
)

// const path = new opentype.Path()

// path.moveTo(startPoint.point[0], startPoint.point[1])
// for (const a of anchorPoints) {
// 	path.bezierCurveTo(
// 		a.ctrl1[0],
// 		a.ctrl1[1],
// 		a.ctrl2[0],
// 		a.ctrl2[1],
// 		a.point[0],
// 		a.point[1]
// 	)
// }

// const box = new opentype.BoundingBox()
// box.addPoint(250, 250)
// path.extend(box)

// const glyphOptions = {
// 	path,
// 	advanceWidth: 100,
// 	xMin: 0, yMin: 0,
// 	xMax: 250, yMax: 250,
// }

// const specialNameMap = new Map([
// 	[0, '.notdef'],
// ])

// const codepoints = 0x10f7be
// const glyphs = []
// for (let i = 0; i < 100; i++) {
// 	const name = specialNameMap.get(i) || String.fromCodePoint(i)
// 	const glyph = new opentype.Glyph({
// 		...glyphOptions,
// 		name,
// 		unicode: i,
// 	})
// 	glyphs.push(glyph)
// }

// Math.max.apply =
// /**
//  * @param {any} _ctx
//  * @param {number[]} args
//  */
//  function mockMinApply(_ctx, args) {
// 	let max = args[0]
// 	for (let i = 1, n = args.length; i < n; i++) {
// 		const val = args[1]
// 		if (max < val) max = val
// 	}
// 	return max
// }

// Math.min.apply =
// /**
//  * @param {any} _ctx
//  * @param {number[]} args
//  */
//  function mockMinApply(_ctx, args) {
// 	let min = args[0]
// 	for (let i = 1, n = args.length; i < n; i++) {
// 		const val = args[1]
// 		if (min > val) min = val
// 	}
// 	return min
// }

// const font = new opentype.Font({
// 	familyName: 'Test',
// 	styleName: 'Medium',
// 	unitsPerEm: 265,
// 	ascender: 10,
// 	descender: -10,
// 	glyphs,
// })

// font.substitution.addSingle('aalt', {sub: 100, by: 5})


// font.download()