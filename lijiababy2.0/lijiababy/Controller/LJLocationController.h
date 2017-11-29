//
//  LJLocationController.h
//  lijiababy
//
//  Created by YongZhi on 23/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef NS_ENUM(NSInteger, LJCLError) {
    kLJLocationSuccess = 0,
    kLJCLErrorDenied = -1, //访问被拒绝
    kLJCLErrorLocationUnknown = -2,  //无法获取地理位置
    kLJCLLocationServicesNotEnabled = -3 //获取地理位置的服务不可用
};

@protocol LocationExport <JSExport>

// callback: function(locationInfo) {
// }
// locationInfo: {
// 	"code":, //0(成功), -1(访问被拒绝), -2(无法获取地理位置), -3(获取地理位置的服务不可用)
// 	"latitude":, //经度
// 	"longitude": //维度
// }
JSExportAs(getLocation, - (void)getLocationWithCoordtype:(NSString *)coordtype callback:(JSValue *)callback);

@end

@interface LJLocationController : NSObject<LocationExport>


@end
