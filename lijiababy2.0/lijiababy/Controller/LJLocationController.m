//
//  LJLocationController.m
//  lijiababy
//
//  Created by YongZhi on 23/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJLocationController.h"
#import "TQLocationConverter.h"

@interface LJLocationController()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) JSValue *getLocationCallback;
@property (strong, nonatomic) NSString *coordtype;

@end

@implementation LJLocationController


//开始定位
- (BOOL)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {

        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        // 总是授权
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
        return YES;
    }
    return NO;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:@(kLJCLErrorDenied) forKey:@"code"]; //kLJCLErrorDenied 方位被拒绝
        [self excuteJSWith:dict];
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:@(kLJCLErrorLocationUnknown) forKey:@"code"]; //无法获取位置信息
        [self excuteJSWith:dict];
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D coordinate2D = newLocation.coordinate;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@(kLJLocationSuccess) forKey:@"code"];
    
    
    if ([self.coordtype isEqualToString:@"GCJ-02"]) {
        [dict setObject:@"GCJ-02" forKey:@"coordtype"];
        coordinate2D = [TQLocationConverter transformFromWGSToGCJ:coordinate2D];
    } else if ([self.coordtype isEqualToString:@"BD-09"]) {
        [dict setObject:@"BD-09" forKey:@"coordtype"];
        CLLocationCoordinate2D tmpCoordinate2D = [TQLocationConverter transformFromWGSToGCJ:coordinate2D];
        coordinate2D = [TQLocationConverter transformFromGCJToBaidu:tmpCoordinate2D];
    } else {
        [dict setObject:@"WGS-84" forKey:@"coordtype"];
    }
    [dict setObject:@(coordinate2D.latitude) forKey:@"latitude"];
    [dict setObject:@(coordinate2D.longitude) forKey:@"longitude"];
    [dict setObject:@(newLocation.horizontalAccuracy) forKey:@"accuracy"];
    
    [self excuteJSWith:dict];
    
//    // 获取当前所在的城市名
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    //根据经纬度反向地理编译出地址信息
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
//        if (array.count > 0){
//            CLPlacemark *placemark = [array objectAtIndex:0];
//            
//            //获取城市
//            NSString *city = placemark.locality;
//            if (!city) {
//                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                city = placemark.administrativeArea;
//            }
//            NSLog(@"city = %@", city);
//        }
//        else if (error == nil && [array count] == 0)
//        {
//            NSLog(@"No results were returned.");
//        }
//        else if (error != nil)
//        {
//            NSLog(@"An error occurred = %@", error);
//        }
//    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}

#pragma mark - JS Interface
- (void)getLocationWithCoordtype:(NSString *)coordtype callback:(JSValue *)callback {
    self.coordtype = coordtype;
    self.getLocationCallback = callback;
    BOOL servicesEnabled = [self startLocation];
    if (!servicesEnabled) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:@(kLJCLLocationServicesNotEnabled) forKey:@"code"]; //kLJCLLocationServicesNotEnabled 获取地理位置的服务不可用
        [self excuteJSWith:dict];;
    }
}

- (void)excuteJSWith:(NSDictionary *)dict {
//    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.getLocationCallback) {
            if (dict) {
                [self.getLocationCallback callWithArguments:@[dict]];
            } else {
                NSDictionary *tmpDictionary = [NSDictionary new];
                [self.getLocationCallback callWithArguments:@[tmpDictionary]];
            }
        }
    });
}

@end
