//
//  TodayViewController.swift
//  Month
//
//  Created by macsjh on 15/10/19.
//  Copyright © 2015年 TurboExtension. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {
	
    override var nibName: String? {
        return "TodayViewController"
    }
	/** enable this when test constraint
	override func viewDidLoad() {
		NSUserDefaults.standardUserDefaults().setBool(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
	}
	*/

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.NoData)
    }
	
	var weekdaySymbols = ["日", "一", "二", "三", "四", "五", "六"]
	var currentViewMonth:NSDate?
	var monthViewlines:[NSView] = []
	var monthLabel:NSTextField?
	var viewHeightConstraint:NSLayoutConstraint?
	
	override func viewWillAppear() {
		let thisMonth = NSDate()
		if(currentViewMonth == nil ||
			currentViewMonth!.dateStringByFormat("yyyy/MM")! == thisMonth.dateStringByFormat("yyyy/MM")!)
		{
			refresh(nil)
		}
	}
	
	func refresh(month: NSDate?)
	{
		if(monthViewlines.count > 0)
		{
			for (var i = monthViewlines.count - 1; i >= 0 ; --i)
			{
				monthViewlines[i].removeFromSuperview()
				monthViewlines.removeLast()
			}
		}
		
		if(monthViewlines.count == 0)
		{
			monthViewlines.append(makeDateSelectorLine(self.view.frame.width))
		}
		
		monthViewlines.append(addTitleLine(weekdaySymbols))
		monthViewlines.appendContentsOf(makeDateLines(getMonthDateStrings(month)))
		
		if(viewHeightConstraint == nil)
		{
			let height = CGFloat(monthViewlines.count * 30 + monthViewlines.count - 1)
			viewHeightConstraint = NSLayoutConstraint(item: self.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: height)
			self.view.addConstraint(viewHeightConstraint!)
		}
		
		for(var i = 0; i < monthViewlines.count; ++i)
		{
			self.view.addSubview(monthViewlines[i])
		}
		
		addRowViewConstraints(self.view, rowViews: monthViewlines)
	}
	
	func btn_Pressed(sender: NSButton)
	{
		var year = (currentViewMonth?.year)!
		var month = (currentViewMonth?.month)!
		switch sender.title
		{
		case "<<":
			--year
			break
		case "<":
			--month
			break
		case ">":
			++month
			break
		case ">>":
			++year
			break
		default:
			break
		}
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy年MM月"
		refresh(formatter.dateFromString("\(year)年\(month)月"))
		monthLabel?.stringValue = "\(year)年\(month)月"
	}
	
	func makeDateSelectorLine(superWidth: CGFloat) -> NSView
	{
		let line = NSView(frame: NSRect(x: 0, y: 0, width: superWidth, height: 17))
		line.translatesAutoresizingMaskIntoConstraints = false
		var cells:[NSView] = []
		
		for(var i = 0; i < 5; ++i)
		{
			switch i
			{
			case 0:
				cells.append(makeButton("<<"))
				break
			case 1:
				cells.append(makeButton("<"))
				break
			case 2:
				let current = NSDate()
				let monthString = current.dateStringByFormat("yyyy年MM月")!
				monthLabel = makeLable(monthString, backgroundColor: NSColor.clearColor(), textColor: NSColor.whiteColor())
				cells.append(monthLabel!)
				break
			case 3:
				cells.append(makeButton(">"))
				break
			case 4:
				cells.append(makeButton(">>"))
				break
			default:
				break
			}
			line.addSubview(cells[i])
			addCellTopConstraint(cells[i], superView: line)
			var widthConstraint : NSLayoutConstraint
			if(i == 2)
			{
				let width = CGFloat(superWidth - 4*26 - 10)
				widthConstraint = NSLayoutConstraint(item: cells[i], attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: width)
			}
			else
			{
				widthConstraint = NSLayoutConstraint(item: cells[i], attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25)
			}
			var leftConstraint:NSLayoutConstraint
			if(i == 0)
			{
				leftConstraint = NSLayoutConstraint(item: cells[i], attribute: .Left, relatedBy: .Equal, toItem: line, attribute: .Left, multiplier: 1.0, constant: 0)
			}
			else
			{
				leftConstraint = NSLayoutConstraint(item: cells[i], attribute: .Left, relatedBy: .Equal, toItem: cells[i - 1], attribute: .Right, multiplier: 1.0, constant: 1)
			}
			
			line.addConstraints([leftConstraint, widthConstraint])
		}
		
		
		return line
	}
	
	func addCellTopConstraint(fromView:NSView, superView:NSView)
	{
		let topConstraint = NSLayoutConstraint(item: fromView, attribute: .Top, relatedBy: .Equal, toItem: superView, attribute: .Top, multiplier: 1.0, constant: 0)
		let bottomConstraint = NSLayoutConstraint(item: fromView, attribute: .Bottom, relatedBy: .Equal, toItem: superView, attribute: .Bottom, multiplier: 1.0, constant: -1)
		superView.addConstraints([topConstraint, bottomConstraint])
	}
	
	func makeButton(title: String) -> NSButton
	{
		let button = NSButton(frame: NSRect(x: 0, y: 0, width: 17, height: 17))
		button.translatesAutoresizingMaskIntoConstraints = false
		button.bordered = false
		button.title = title
		button.alignment = NSTextAlignment.Center
		button.font = NSFont.systemFontOfSize(17)
		button.target = self
		button.action = "btn_Pressed:"
		return button
	}
	
	
	func addTitleLine(labelTexts: [String])->NSView
	{
		let titleLine = NSView(frame: CGRect(x: 0, y: 0, width: 125, height: 17))
		titleLine.translatesAutoresizingMaskIntoConstraints = false
		var labels:[NSTextField] = []
		for (var i = 0; i < labelTexts.count; ++i)
		{
			let backgroundColor = NSColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.2)
			let label = makeLable(labelTexts[i], backgroundColor: backgroundColor, textColor: NSColor.whiteColor())
			titleLine.addSubview(label)
			labels.append(label)
		}
		addCellViewConstraints(labels, superView: titleLine)
		return titleLine
	}
	
	func makeDateLines(dateStrings:[[String]])->[NSView]
	{
		var lines:[NSView] = []
		var isThisMonth = false
		for(var i = 0; i < dateStrings.count; ++i)
		{
			let line = NSView(frame: CGRect(x: 0, y: 0, width: 125, height: 17))
			line.translatesAutoresizingMaskIntoConstraints = false
			var labels:[NSTextField] = []
			for (var j = 0; j < dateStrings[i].count; ++j)
			{
				if(dateStrings[i][j] == "1")
				{
					isThisMonth = !isThisMonth
				}
				var backgroundColor:NSColor = NSColor.clearColor()
				var textColor:NSColor
				if(isThisMonth)
				{
					if("\(NSDate().dayOfMonth!)" == dateStrings[i][j]
						&& NSDate().month! == currentViewMonth!.month!)
					{
						backgroundColor = NSColor(white: 1, alpha: 0.8)
						textColor = NSColor.blackColor()
					}
					else
					{
						textColor = NSColor.whiteColor()
					}
				}
				else
				{
					textColor = NSColor.grayColor()
				}
				let label = makeLable(dateStrings[i][j], backgroundColor: backgroundColor, textColor: textColor)
				line.addSubview(label)
				labels.append(label)
			}
			addCellViewConstraints(labels, superView: line)
			lines.append(line)
		}
		return lines
	}
	
	func makeLable(labelText: String, backgroundColor: NSColor, textColor: NSColor) -> NSTextField
	{
		let label = NSTextField(frame: NSRect(x: 0, y: 0, width: 17, height: 17))
		label.cell = VerticalCenterCell()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.editable = false
		label.bordered = false
		label.font = NSFont.systemFontOfSize(17)
		label.backgroundColor = backgroundColor
		label.textColor = textColor
		label.stringValue = labelText
		label.alignment = NSTextAlignment.Center
		
		return label
	}
	
	func getMonthDateStrings(var date: NSDate?) -> [[String]]
	{
		var dateStrings:[[String]] = []
		if(date == nil)
		{
			date = NSDate()
		}
		currentViewMonth = date
		
		let firstDayOfMonth = date!.firstDayOfMonth!
		let lastDayOfLastMonth = NSDate(timeInterval: -24*60*60, sinceDate: firstDayOfMonth).dayOfMonth
		
		var line:[String] = []
		for (var i = firstDayOfMonth.dayOfWeek! - 1; i > 0; --i)
		{
			line.append("\(lastDayOfLastMonth! - i + 1)")
		}
		
		let lastDayOfMonth = date!.lastDayOfMonth!.dayOfMonth!
		for(var i = 1; i <= lastDayOfMonth; ++i)
		{
			if(line.count == 7)
			{
				dateStrings.append(line)
				line = []
			}
			line.append("\(i)")
		}
		
		var i = 1;
		while(line.count != 7)
		{
			line.append("\(i)")
			++i
		}
		dateStrings.append(line)

		return dateStrings
	}
	
	func addCellViewConstraints(views: [NSView], superView: NSView)
	{
		for (var i = 0; i < views.count; ++i)
		{
			let aView = views [i]
			
			let topConstraint = NSLayoutConstraint(item: aView, attribute: .Top, relatedBy: .Equal, toItem: superView, attribute: .Top, multiplier: 1.0, constant: 1)
			let bottomConstraint = NSLayoutConstraint(item: aView, attribute: .Bottom, relatedBy: .Equal,
				toItem: superView, attribute: .Bottom, multiplier: 1.0, constant: -1)
			
			var rightConstraint : NSLayoutConstraint!
			
			if i == views.count - 1
			{
				rightConstraint = NSLayoutConstraint(item: aView, attribute: .Right, relatedBy: .Equal, toItem: superView, attribute: .Right, multiplier: 1.0, constant: -1)
			}
			else
			{
				rightConstraint = NSLayoutConstraint(item: aView, attribute: .Right, relatedBy: .Equal, toItem: views[i+1], attribute: .Left, multiplier: 1.0, constant: -1)
			}
			var leftConstraint : NSLayoutConstraint!
			if i == 0
			{
				leftConstraint = NSLayoutConstraint(item: aView, attribute: .Left, relatedBy: .Equal, toItem: superView, attribute: .Left, multiplier: 1.0, constant: 0)
			}
			else
			{
				leftConstraint = NSLayoutConstraint(item: aView, attribute: .Left, relatedBy: .Equal, toItem: views[i-1], attribute: .Right, multiplier: 1.0, constant: 1)
				let widthConstraint = NSLayoutConstraint(item: views[0], attribute: .Width, relatedBy: .Equal, toItem: aView, attribute: .Width, multiplier: 1.0, constant: 0)
				superView.addConstraint(widthConstraint)
			}
			superView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
		}
	}
	
	func addRowViewConstraints(superView: NSView, rowViews: [NSView])
	{
		for (var i = 0; i < rowViews.count; ++i)
		{
			let rowView = rowViews[i]
			let rightSideConstraint = NSLayoutConstraint(item: rowView, attribute: .Right, relatedBy: .Equal, toItem: superView, attribute: .Right, multiplier: 1.0, constant: -10)
			
			let leftConstraint = NSLayoutConstraint(item: rowView, attribute: .Left, relatedBy: .Equal, toItem: superView, attribute: .Left, multiplier: 1.0, constant: 0)
			
			superView.addConstraints([leftConstraint, rightSideConstraint])
			
			var topConstraint: NSLayoutConstraint
			
			if i == 0 {
				topConstraint = NSLayoutConstraint(item: rowView, attribute: .Top, relatedBy: .Equal, toItem: superView, attribute: .Top, multiplier: 1.0, constant: 0)
				
			}else{
				
				let prevRow = rowViews[i - 1]
				topConstraint = NSLayoutConstraint(item: rowView, attribute: .Top, relatedBy: .Equal, toItem: prevRow, attribute: .Bottom, multiplier: 1.0, constant: 0)
				
				let firstRow = rowViews[0]
				let heightConstraint = NSLayoutConstraint(item: firstRow, attribute: .Height, relatedBy: .Equal, toItem: rowView, attribute: .Height, multiplier: 1.0, constant: 0)
				
				superView.addConstraint(heightConstraint)
			}
			superView.addConstraint(topConstraint)
			
			var bottomConstraint: NSLayoutConstraint
			
			if i == rowViews.count - 1 {
				bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .Bottom, relatedBy: .Equal, toItem: superView, attribute: .Bottom, multiplier: 1.0, constant: 0)
				
			}else{
				
				let nextRow = rowViews[i+1]
				bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .Bottom, relatedBy: .Equal, toItem: nextRow, attribute: .Top, multiplier: 1.0, constant: 0)
			}
			
			superView.addConstraint(bottomConstraint)
		}
	}
}

