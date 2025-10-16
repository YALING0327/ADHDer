//
//  NSDAte+NSDateMock.m
//  Adhder
//
//  Created by Phillip Thelen on 16/06/15.
//  Copyright © 2017 AdhderApp Inc. All rights reserved.
//

#import "NSDate+NSDateMock.h"

@implementation NSDate (NSDateMock)

static NSDate *_mockDate;

+(NSDate *)mockCurrentDate
{
    return _mockDate;
}

+(void)setMockDate:(NSString *)mockDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY/MM/dd HH:mm:ss";
    _mockDate = [dateFormatter dateFromString:mockDate];
}

@end
