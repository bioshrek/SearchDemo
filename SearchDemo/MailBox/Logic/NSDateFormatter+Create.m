//
//  NSDateFormatter+Create.m
//  SearchDemo
//
//  Created by 王欢 on 2019/7/20.
//  Copyright © 2019 王欢. All rights reserved.
//

#import "NSDateFormatter+Create.h"

@implementation NSDateFormatter (Create)

+ (instancetype)dateFormatterWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = format.copy;
    return dateFormatter;
}

@end
