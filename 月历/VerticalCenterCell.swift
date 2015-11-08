//
//  VerticalCenterCell.swift
//  The Month
//
//  Created by macsjh on 15/10/20.
//  Copyright © 2015年 TurboExtension. All rights reserved.
//

import Cocoa

class VerticalCenterCell: NSTextFieldCell {
	func verticallyCenterRect(frame:NSRect) -> NSRect
	{
		let  offset = floor((NSHeight(frame) - (self.font!.ascender - self.font!.descender)) / 2)
		return NSInsetRect(frame, 4.0, offset)
	}
	
	override func drawInteriorWithFrame(cellFrame: NSRect, inView controlView: NSView)
	{
		self.backgroundColor?.set()
		NSRectFill(NSInsetRect(cellFrame, 2.0, 0.0))
		self.attributedStringValue.drawInRect(verticallyCenterRect(cellFrame))
	}
}
