//
//  NSDateExtension.swift
//  The Month
//
//  Created by macsjh on 15/10/19.
//  Copyright © 2015年 TurboExtension. All rights reserved.
//

import Foundation

extension NSDate
{
	var year:Int?
		{
		get
		{
			let formatter = NSDateFormatter()
			formatter.dateFormat = "yyyy"
			let yearString = formatter.stringFromDate(self)
			return NSNumberFormatter().numberFromString(yearString)?.integerValue
		}
	}
	
	var month:Int?
		{
		get
		{
			let formatter = NSDateFormatter()
			formatter.dateFormat = "MM"
			let monthString = formatter.stringFromDate(self)
			return NSNumberFormatter().numberFromString(monthString)?.integerValue
		}
	}
	
	var dayOfMonth:Int?
		{
		get
		{
			let formatter = NSDateFormatter()
			formatter.dateFormat = "dd"
			let dayString = formatter.stringFromDate(self)
			return NSNumberFormatter().numberFromString(dayString)?.integerValue
		}
	}
	
	var dayOfWeek:Int?
		{
		get
		{
			let formatter = NSDateFormatter()
			formatter.dateFormat = "e"
			let dayString = formatter.stringFromDate(self)
			return NSNumberFormatter().numberFromString(dayString)?.integerValue
		}
	}
	
	var hour:Int?
		{
		get
		{
			let formatter = NSDateFormatter()
			formatter.dateFormat = "HH"
			let hourString = formatter.stringFromDate(self)
			return NSNumberFormatter().numberFromString(hourString)?.integerValue
		}
	}
	
	var minute:Int?
		{
		get
		{
			let formatter = NSDateFormatter()
			formatter.dateFormat = "mm"
			let minuteString = formatter.stringFromDate(self)
			return NSNumberFormatter().numberFromString(minuteString)?.integerValue
		}
	}
	
	var second:Int?
		{
		get
		{
			let formatter = NSDateFormatter()
			formatter.dateFormat = "mm"
			let secondString = formatter.stringFromDate(self)
			return NSNumberFormatter().numberFromString(secondString)?.integerValue
		}
	}
	
	func dateStringByFormat(format:String)->String?
	{
		let formatter = NSDateFormatter()
		formatter.dateFormat = format
		return formatter.stringFromDate(self)
	}
	
	var firstDayOfMonth:NSDate?
		{
		get
		{
			var exceptDayFormat = ""
			if(self.year != nil)
			{
				exceptDayFormat += "yyyy/"
			}
			if (self.month != nil)
			{
				exceptDayFormat += "MM/"
			}
			if (self.hour != nil)
			{
				exceptDayFormat += "HH/"
			}
			if (self.minute != nil)
			{
				exceptDayFormat += "mm/"
			}
			if (self.second != nil)
			{
				exceptDayFormat += "ss/"
			}
			
			let exceptDay = dateStringByFormat(exceptDayFormat)
			let formatter = NSDateFormatter()
			formatter.dateFormat = exceptDayFormat + "dd"
			if(exceptDay != nil)
			{
				return formatter.dateFromString(exceptDay! + "01")
			}
			return nil
		}
	}
	
	var lastDayOfMonth:NSDate?
		{
		get
		{
			if(self.month != nil)
			{
				var exceptMonthFormat = ""
				if(self.year != nil)
				{
					exceptMonthFormat += "yyyy/"
				}
				if (self.dayOfMonth != nil)
				{
					exceptMonthFormat += "dd/"
				}
				if (self.hour != nil)
				{
					exceptMonthFormat += "HH/"
				}
				if (self.minute != nil)
				{
					exceptMonthFormat += "mm/"
				}
				if (self.second != nil)
				{
					exceptMonthFormat += "ss/"
				}
				
				let exceptDay = dateStringByFormat(exceptMonthFormat)
				let formatter = NSDateFormatter()
				formatter.dateFormat = exceptMonthFormat + "MM"
				if(exceptDay != nil)
				{
					let nextMonth = formatter.dateFromString(exceptDay! + "\(self.month!)")
					if(nextMonth != nil)
					{
						return NSDate(timeInterval: -24*60*60, sinceDate: nextMonth!.firstDayOfMonth!)
					}
				}
			}
			
			return nil
		}
	}
}
