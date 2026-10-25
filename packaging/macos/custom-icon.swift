// Original app icon for the PhotoCraft community build.
// Matches the rounded blue/violet tile style of the custom PdfCraft icon.
// SPDX-License-Identifier: MIT OR Apache-2.0
import AppKit
import Foundation
guard CommandLine.arguments.count == 2 else { fatalError("Usage: swift custom-icon.swift PNG_PATH") }
let n = 1024
guard let b = NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:n,pixelsHigh:n,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0),
      let ctx = NSGraphicsContext(bitmapImageRep:b) else { fatalError("Image buffer unavailable") }
func c(_ r:CGFloat,_ g:CGFloat,_ bl:CGFloat,_ alpha:CGFloat=1)->NSColor {
    NSColor(calibratedRed:r/255,green:g/255,blue:bl/255,alpha:alpha)
}
func p(_ coordinates:[CGPoint])->NSBezierPath {
    let path = NSBezierPath()
    path.move(to:coordinates[0])
    for v in coordinates.dropFirst() { path.line(to:v) }
    path.close()
    return path
}
func gradient(_ a:NSColor,_ b:NSColor,_ path:NSBezierPath,_ angle:CGFloat) {
    NSGradient(starting:a,ending:b)?.draw(in:path,angle:angle)
}
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = ctx
ctx.cgContext.clear(CGRect(x:0,y:0,width:n,height:n))
let tile = NSBezierPath(roundedRect:NSRect(x:48,y:48,width:928,height:928),xRadius:211,yRadius:211)
NSGraphicsContext.saveGraphicsState()
let shadow = NSShadow()
shadow.shadowColor = .black.withAlphaComponent(0.25)
shadow.shadowBlurRadius = 34
shadow.shadowOffset = NSSize(width:0,height:-15)
shadow.set()
c(33,72,185).setFill()
tile.fill()
NSGraphicsContext.restoreGraphicsState()
gradient(c(12,121,239),c(82,34,185),tile,-40)
NSGraphicsContext.saveGraphicsState()
tile.addClip()
c(165,215,255,0.16).setFill()
p([CGPoint(x:42,y:862),CGPoint(x:380,y:1014),CGPoint(x:695,y:1014),CGPoint(x:85,y:510)]).fill()
c(179,53,238,0.60).setFill()
p([CGPoint(x:500,y:20),CGPoint(x:1000,y:530),CGPoint(x:1000,y:20)]).fill()
NSGraphicsContext.restoreGraphicsState()
// A photographic landscape layered within a white image sheet, rather than the PDF page.
let sheet=NSBezierPath(roundedRect:NSRect(x:243,y:238,width:539,height:535),xRadius:56,yRadius:56)
NSGraphicsContext.saveGraphicsState()
let sh=NSShadow()
sh.shadowColor=c(17,31,76,0.35)
sh.shadowBlurRadius=38
sh.shadowOffset=NSSize(width:9,height:-15)
sh.set()
c(238,247,255).setFill()
sheet.fill()
NSGraphicsContext.restoreGraphicsState()
let interior=NSBezierPath(roundedRect:NSRect(x:272,y:270,width:481,height:475),xRadius:34,yRadius:34)
NSGraphicsContext.saveGraphicsState()
interior.addClip()
gradient(c(139,216,254),c(246,185,240),interior,90)
let sun=NSBezierPath(ovalIn:NSRect(x:574,y:560,width:108,height:108))
c(255,246,200).setFill()
sun.fill()
gradient(c(39,163,176),c(37,111,176),p([CGPoint(x:250,y:287),CGPoint(x:250,y:465),CGPoint(x:414,y:625),CGPoint(x:565,y:440),CGPoint(x:760,y:570),CGPoint(x:760,y:245)]),75)
gradient(c(32,127,175),c(40,65,158),p([CGPoint(x:251,y:270),CGPoint(x:251,y:365),CGPoint(x:407,y:475),CGPoint(x:529,y:351),CGPoint(x:630,y:438),CGPoint(x:762,y:325),CGPoint(x:762,y:260)]),95)
NSGraphicsContext.restoreGraphicsState()
c(255,255,255,0.72).setStroke()
sheet.lineWidth=8
sheet.stroke()
// A curved violet band links PhotoCraft with the PDF sibling visually.
NSGraphicsContext.saveGraphicsState()
tile.addClip()
gradient(c(153,52,244,0.94),c(72,34,188,0.95),p([CGPoint(x:575,y:49),CGPoint(x:975,y:440),CGPoint(x:975,y:242),CGPoint(x:780,y:49)]),-36)
NSGraphicsContext.restoreGraphicsState()
ctx.flushGraphics()
NSGraphicsContext.restoreGraphicsState()
guard let data=b.representation(using:.png,properties:[:]) else {fatalError("PNG encoding failed")}
try data.write(to:URL(fileURLWithPath:CommandLine.arguments[1]),options:.atomic)
