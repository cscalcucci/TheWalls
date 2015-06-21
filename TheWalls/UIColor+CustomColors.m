//
//  UIColor+CustomColors.m
//  TheWalls
//
//  Created by John McClelland on 6/13/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *)peonyColor {
    return [UIColor colorWithRed:227/255.0 green:80/255.0 blue:113/255.0 alpha:100];
}

+ (UIColor *)hamlindigoColor {
    return [UIColor colorWithRed:80/255.0 green:113/255.0 blue:227/255.0 alpha:100];
}

+ (UIColor *)limeColor {
    return [UIColor colorWithRed:113/255.0 green:227/255.0 blue:80/255.0 alpha:100];
}

+ (UIColor *)paperColor {
    return [UIColor colorWithRed:247/255.0 green:247/255.0 blue:239/255.0 alpha:100];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

//Method call to add
//[myButton setBackgroundImage:[self imageWithColor:[UIColor greenColor]] forState:UIControlStateHighlighted];




@end
