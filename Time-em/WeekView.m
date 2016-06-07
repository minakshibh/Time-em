//
//  WeekView.m
//  WeekViewDemo
//
//  Created by Yashwant Chauhan on 3/31/14.
//  Copyright (c) 2014 Yashwant Chauhan. All rights reserved.
//

#import "WeekView.h"


@interface WeekView () {
    @private
        NSDate *_startDate;
        NSDate *_endDate;
        NSInteger _currentDay;
        NSDate *_currentDate;
        NSRange _activeDays;
        NSIndexPath *_currentIndex;
}

@end

@implementation WeekView

@synthesize weekViewDays;


+(NSMutableArray *) showdates{
    NSString *start = @"2016-06-02";
    NSString *end = @"2016-07-02";
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:start];
    NSDate *endDate = [f dateFromString:end];
    NSMutableArray *dates = [NSMutableArray new];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    for (int i = 1; i < components.day; ++i) {
        NSDateComponents *newComponents = [NSDateComponents new];
        newComponents.day = i;
        NSDate *date = [gregorianCalendar dateByAddingComponents:newComponents
                                                          toDate:startDate
                                                         options:0];
        NSDateFormatter *dateNameFormatter = [[NSDateFormatter alloc] init];
        [dateNameFormatter setDateFormat:@"EEEEE"];
        
        NSDateFormatter *dateNumberFormatter = [[NSDateFormatter alloc] init];
        [dateNumberFormatter setDateFormat:@"dd"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        NSMutableDictionary *DateData = [NSMutableDictionary new];
        [DateData setObject:[dateNameFormatter stringFromDate:date] forKey:@"dayName"];
        [DateData setObject:[dateNumberFormatter stringFromDate:date] forKey:@"dayNumber"];
        [DateData setObject:[dateFormat stringFromDate:date] forKey:@"date"];
        BOOL today = [[NSCalendar currentCalendar] isDateInToday:date];
        [DateData setObject:[NSNumber numberWithBool:today]forKey:@"isCurrentDate"];

        
        [dates addObject:DateData];
    }
    
    
    //[dates addObject:endDate];
    return dates;
}

@end
