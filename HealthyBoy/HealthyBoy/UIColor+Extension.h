//
//  UIColor+Extension.h
//  gameStore
//
//  Created by cg on 15/11/2.
//  Copyright © 2015年 forgame. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIColor (Extension)

+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (UIImage*) createImageWithColor:(UIColor*) color;
@end
