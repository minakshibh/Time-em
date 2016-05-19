//
//  NSDictionary+CL.m
//  CLWeeklyCalendarView
//
//  Created by Caesar on 10/12/2014.
//  Copyright (c) 2014 Caesar. All rights reserved.
//

#import "NSDictionary+CL.h"

@implementation NSDictionary (CL)
- (id)objectForKeyWithNil:(id)aKey {
    if(!self) return nil;
    id object = [self objectForKey:aKey];
    if (object == [NSNull null]) {
        return nil;
    }
    return object;
}
@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
