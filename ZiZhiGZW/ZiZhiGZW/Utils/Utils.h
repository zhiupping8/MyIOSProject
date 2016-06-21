//
//  Utils.h
//  ZiZhiGZW
//
//  Created by zyz on 11/30/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

//颜色（RGB）
#define RGBCOLOR(r,g,b)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface Utils : NSObject

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIViewController*)getVCFromSB:(NSString*)identifier storyBoardName:(NSString *)storyBoardName;

/**
 *  获取归档路径
 *
 *  @param name file name
 *
 *  @return file path
 */
+ (NSString *)modelPathWithName:(NSString *)name;

/**
 * @function isBlankString
 * @explain 判断字符串是否为空
 *  @param NSString * string - 接受判断的字符串
 * @return BOOL - 判断结果
 */
+ (BOOL)isBlankString:(NSString *)string;

/**
 *  is mobile number or not
 *
 *  @param mobileNum - mobile number
 *
 *  @return YES or NO
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+(BOOL)isIdentityCardNo:(NSString*)text;

+(BOOL)isFirstLaunch;

@end
