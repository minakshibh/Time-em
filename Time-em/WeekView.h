//
//  WeekView.h
//  WeekViewDemo
//
//  Created by Yashwant Chauhan on 3/31/14.
//  Copyright (c) 2014 Yashwant Chauhan. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface WeekView : NSObject

@property (nonatomic, strong) NSMutableArray *weekViewDays;

+ (NSMutableArray*) showdates;
@end