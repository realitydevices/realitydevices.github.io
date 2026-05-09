// One-shot TTF → three.js typeface.json converter.
// Mirrors the format produced by gero3/facetype.js (the standard tool
// behind three.js fonts). Uses opentype.js to walk glyph outlines.
//
// Usage: node convert.mjs <input.ttf> <output.json> [chars]

import opentype from 'opentype.js';
import fs from 'node:fs';

const [,, inputPath, outputPath, charsArg] = process.argv;
if (!inputPath || !outputPath) {
  console.error('usage: node convert.mjs <input.ttf> <output.json> [chars]');
  process.exit(1);
}

// Default char set: ASCII printable. Override with the third arg to keep
// the JSON small (we only need REALITY CONSTRUCTION DEVICES for now, but
// shipping the full alphabet keeps the file reusable).
const defaultChars =
  'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' +
  ' .,:;!?\'"-_/&@#%()[]';
const chars = charsArg || defaultChars;

const buf = fs.readFileSync(inputPath);
const font = opentype.parse(buf.buffer.slice(buf.byteOffset, buf.byteOffset + buf.byteLength));

// three.js typeface.json layout (per facetype.js):
//   { glyphs: { <char>: { ha, x_min, x_max, o: '<svg-pathlike-tokens>' } },
//     familyName, ascender, descender, underlinePosition, underlineThickness,
//     boundingBox: {yMin,xMin,yMax,xMax}, resolution, original_font_information,
//     cssFontWeight, cssFontStyle }
// The 'o' string is space-separated tokens describing the glyph outline:
//   m x y    moveTo
//   l x y    lineTo
//   q cx cy x y         quadraticCurveTo
//   b cx1 cy1 cx2 cy2 x y  bezierCurveTo
//   z        close (NB: facetype.js elides this; three.js TextGeometry doesn't need it)

function glyphToO(glyph) {
  const tokens = [];
  const path = glyph.getPath(0, 0, font.unitsPerEm);
  for (const cmd of path.commands) {
    switch (cmd.type) {
      case 'M': tokens.push('m', cmd.x, -cmd.y); break;
      case 'L': tokens.push('l', cmd.x, -cmd.y); break;
      case 'Q': tokens.push('q', cmd.x, -cmd.y, cmd.x1, -cmd.y1); break;
      case 'C': tokens.push('b', cmd.x, -cmd.y, cmd.x1, -cmd.y1, cmd.x2, -cmd.y2); break;
      case 'Z': /* skip */ break;
    }
  }
  return tokens.join(' ');
}

const glyphs = {};
for (const ch of chars) {
  const glyph = font.charToGlyph(ch);
  if (!glyph || glyph.index === 0) continue; // .notdef
  const bbox = glyph.getBoundingBox();
  glyphs[ch] = {
    ha: Math.round(glyph.advanceWidth),
    x_min: Math.round(bbox.x1),
    x_max: Math.round(bbox.x2),
    o: glyphToO(glyph),
  };
}

const out = {
  glyphs,
  familyName: font.names.fontFamily?.en || 'Unknown',
  ascender: font.ascender,
  descender: font.descender,
  underlinePosition: font.tables.post?.underlinePosition ?? -100,
  underlineThickness: font.tables.post?.underlineThickness ?? 50,
  boundingBox: {
    yMin: font.tables.head.yMin,
    xMin: font.tables.head.xMin,
    yMax: font.tables.head.yMax,
    xMax: font.tables.head.xMax,
  },
  resolution: font.unitsPerEm,
  original_font_information: font.tables.name,
  cssFontWeight: 'normal',
  cssFontStyle: 'normal',
};

fs.writeFileSync(outputPath, JSON.stringify(out));
console.log(`wrote ${outputPath} — ${Object.keys(glyphs).length} glyphs, ${(fs.statSync(outputPath).size/1024).toFixed(1)} KB`);
