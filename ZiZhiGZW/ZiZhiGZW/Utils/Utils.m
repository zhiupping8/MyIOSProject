//
//  Utils.m
//  ZiZhiGZW
//
//  Created by zyz on 11/30/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}

+ (UIViewController*)getVCFromSB:(NSString*)identifier storyBoardName:(NSString *)storyBoardName{
    storyBoardName = (nil == storyBoardName ? @"Main" : storyBoardName);
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    
    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:identifier];
    return vc;
}

+ (NSString *)modelPathWithName:(NSString *)name {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                       , NSUserDomainMask
                                                       , YES);
    NSString *filePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:name];
    return filePath;
}

/**
 * @function isBlankString
 * @explain 判断字符串是否为空
 *  @param NSString * string - 接受判断的字符串
 * @return BOOL - 判断结果
 */
+ (BOOL)isBlankString:(NSString *)string
{
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

/**
 *  is mobile number or not
 *
 *  @param mobileNum - mobile number
 *
 *  @return YES or NO
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}

//是否身份证
+(BOOL)isIdentityCardNo:(NSString*)text
{
    if (text.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[text substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[text substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[text substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

+(BOOL)isFirstLaunch {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *appBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *localAppVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"];
    NSString *localAppBuild = [[NSUserDefaults standardUserDefaults] objectForKey:@"appBuild"];
    
    if (!localAppVersion ||
        !localAppBuild ||
        ![localAppVersion isEqualToString:appVersion] ||
        ![localAppBuild isEqualToString:appBuild]) {
        [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:@"appVersion"];
        [[NSUserDefaults standardUserDefaults] setObject:appBuild forKey:@"appBuild"];
        return YES;
    }
    
    return NO;
}

@end
