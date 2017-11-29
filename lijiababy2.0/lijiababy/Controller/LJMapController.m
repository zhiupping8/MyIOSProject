//
//  LJMapController.m
//  lijiababy
//
//  Created by YongZhi on 30/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJMapController.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TQLocationConverter.h"

@interface LJMapController ()
@property (copy, nonatomic) NSArray *maps;
@property (copy, nonatomic) NSArray *mapNames;
@property (copy, nonatomic) NSArray *mapOpertionFuncs;

@property (weak, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSDictionary *locationInfo;

@property (strong, nonatomic) JSValue *openMapCallback;
@end

@implementation LJMapController

- (instancetype)initWithCallback:(JSValue *)callback {
    if (self = [super init]) {
        self.openMapCallback = callback;
    }
    return self;
}

- (NSArray *)maps {
    if (!_maps) {
        _maps = @[@"map://", @"baidumap://", @"iosamap://", @"comgooglemaps://", @"qqmap://"];
    }
    return _maps;
}

- (NSArray *)mapNames {
    if (!_mapNames) {
        _mapNames = @[@"苹果地图", @"百度地图", @"高德地图", @"谷歌地图", @"腾讯地图"];
    }
    return _mapNames;
}

- (NSArray *)mapOpertionFuncs {
    if (!_mapOpertionFuncs) {
        _mapOpertionFuncs = @[@"openAppleMap", @"openBaiduMap", @"openIosAMap", @"openComGoogleMap", @"openQQMap"];
    }
    return _mapOpertionFuncs;
}

- (NSArray *)getAvailableMaps {
    NSMutableArray *mapIndexes = [NSMutableArray new];
    for (int i=0; i<[self.maps count]; i++) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.maps[i]]]) {
            [mapIndexes addObject:@(i)];
        }
    }
    return mapIndexes;
}

- (void)showActionSheetWithView:(UIView *)view  location:(JSValue *)location{
    NSArray *availableMaps = [self getAvailableMaps];
    if (0 == [availableMaps count]) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:@(-2) forKey:@"code"];
        [dict setObject:@(-1) forKey:@"tag"];
        [self excuteScript:dict];
        return;
    }
    self.locationInfo = [location toDictionary];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    self.actionSheet = actionSheet;
    for (int i=0; i<[availableMaps count]; i++) {
        int index = [availableMaps[i] intValue];
        [actionSheet addButtonWithTitle:self.mapNames[index]];
    }
    [actionSheet showInView:view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //取消
            break;
        case 1:
            //苹果地图
            break;
        case 2:
            //百度地图
            break;
        case 3:
            //高德地图
            break;
        case 4:
            //谷歌地图
            break;
        case 5:
            //腾讯地图
            break;
        default:
            break;
    }
    NSArray *availableMaps = [self getAvailableMaps];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    int code = -4;
    int tag = -1; //地图标识 默认没有选择
    if (0 == [availableMaps count]) {
        code = -2; //没有可用的地图
    }
    if (0 == buttonIndex) {
        code = -3;//用户取消
    } else {
        tag = (int)(buttonIndex - 1);
        if (!self.locationInfo) {
            code = -1; //参数有误
        }
    }
    
    
    if (buttonIndex > 0 && buttonIndex <= [availableMaps count]) {
        int index = [availableMaps[buttonIndex-1] intValue];
        switch (index) {
            case 0:
                code = [self openAppleMap];
                break;
            case 1:
                code = [self openBaiduMap];
                break;
            case 2:
                code = [self openIosAMap];
                break;
            case 3:
                code = [self openComGoogleMap];
                break;
            case 4:
                code = [self openQQMap];
                break;
            default:
                break;
        }
        
    }
    [dict setObject:@(code) forKey:@"code"];
    [dict setObject:@(tag) forKey:@"tag"];
    [self excuteScript:dict];

}


#pragma mark - open map operation
- (int)openAppleMap {
//    //起点
    if (self.locationInfo) {
        NSString *locationName = [self.locationInfo objectForKey:@"locationName"];
        NSString *coordType = [self.locationInfo objectForKey:@"coordtype"];
        NSDictionary *tmpDict = [self transferCoord:coordType toCoordType:@"WGS-84" latitude:[self.locationInfo objectForKey:@"latitude"] longitude:[self.locationInfo objectForKey:@"longitude"]];
        CLLocationDegrees latitude = [[tmpDict objectForKey:@"latitude"] doubleValue];
        CLLocationDegrees longitude = [[tmpDict objectForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(latitude, longitude);
        MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1]];
        currentLocation.name = locationName;
        
        if ([currentLocation openInMapsWithLaunchOptions:nil]) {
            return 0;
        } else {
            return -4;
        }
    }
    return -1;
}

- (int)openBaiduMap {
    if (self.locationInfo) {
        NSString* locationName = [self.locationInfo objectForKey:@"locationName"];
        NSString *coordType = [self.locationInfo objectForKey:@"coordtype"];
        NSString *latitude = [self.locationInfo objectForKey:@"latitude"];
        NSString *longitude = [self.locationInfo objectForKey:@"longitude"];
        NSDictionary *tmpDict = [self transferCoord:coordType toCoordType:@"BD-09" latitude:latitude longitude:longitude];
        NSString *locationAddress = [self.locationInfo objectForKey:@"locationAddress"];
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/marker?location=%@,%@&title=%@&content=%@&src=%@", [tmpDict objectForKey:@"latitude"], [tmpDict objectForKey:@"longitude"], locationName,locationAddress, @"丽家宝贝"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]]) {
            return 0;
        } else {
            return -4;
        }
    }
    return -1;
}

- (int)openIosAMap {
    if (self.locationInfo) {
        NSString* locationName = [self.locationInfo objectForKey:@"locationName"];
        NSString *coordType = [self.locationInfo objectForKey:@"coordtype"];
        NSString *latitude = [self.locationInfo objectForKey:@"latitude"];
        NSString *longitude = [self.locationInfo objectForKey:@"longitude"];
        NSDictionary *tmpDict = [self transferCoord:coordType toCoordType:@"GCJ-02" latitude:latitude longitude:longitude];
        //默认为高德坐标系（gcj02坐标系）
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://viewMap?sourceApplication=%@&poiname=%@&lat=%@&lon=%@&dev=0",@"丽家宝贝", locationName, [tmpDict objectForKey:@"latitude"], [tmpDict objectForKey:@"longitude"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]]) {
            return 0;
        } else {
            return -4;
        }
    }
    return -1;
}

- (int)openComGoogleMap {
    if (self.locationInfo) {
        NSString *latitude = [self.locationInfo objectForKey:@"latitude"];
        NSString *longitude = [self.locationInfo objectForKey:@"longitude"];
        NSString *coordType = [self.locationInfo objectForKey:@"coordtype"];
        NSDictionary *tmpDict = [self transferCoord:coordType toCoordType:@"GCJ-02" latitude:latitude longitude:longitude];
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?center=%@,%@&zoom=14&views=traffic", [tmpDict objectForKey:@"latitude"], [tmpDict objectForKey:@"longitude"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]]) {
            return 0;
        } else {
            return -4;
        }
    }
    return -1;
}

- (int)openQQMap {
    if (self.locationInfo) {
        NSString* locationName = [self.locationInfo objectForKey:@"locationName"];
        NSString *coordType = [self.locationInfo objectForKey:@"coordtype"];
        NSString *latitude = [self.locationInfo objectForKey:@"latitude"];
        NSString *longitude = [self.locationInfo objectForKey:@"longitude"];
        NSString *locationAddress = [self.locationInfo objectForKey:@"locationAddress"];
        NSDictionary *tmpDict = [self transferCoord:coordType toCoordType:@"GCJ-02" latitude:latitude longitude:longitude];
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/marker?marker=coord:%@,%@;title:%@;addr:%@&referer=%@",[tmpDict objectForKey:@"latitude"], [tmpDict objectForKey:@"longitude"], locationName, locationAddress, @"丽家宝贝"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]]) {
            return 0;
        } else {
            return -4;
        }
    }
    return -1;
}

- (NSDictionary *)transferCoord:(NSString *)coordType toCoordType:(NSString *)toCoordType latitude:(NSString *)latitude longitude:(NSString *)longitude {
    CLLocationDegrees latitude1 = [[self.locationInfo objectForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude1 = [[self.locationInfo objectForKey:@"longitude"] doubleValue];
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(latitude1, longitude1);
    CLLocationCoordinate2D coords2 = coords1;
    if ([coordType isEqualToString:@"WGS-84"]) {
        if ([toCoordType isEqualToString:@"GCJ-02"]) {
            coords2 = [TQLocationConverter transformFromWGSToGCJ:coords1];
        } else if ([toCoordType isEqualToString:@"BD-09"]) {
            coords2 = [TQLocationConverter transformFromGCJToBaidu:[TQLocationConverter transformFromWGSToGCJ:coords1]];
        }
    } else if([coordType isEqualToString:@"GCJ-02"]) {
        if ([toCoordType isEqualToString:@"WGS-84"]) {
            coords2 = [TQLocationConverter transformFromGCJToWGS:coords1];
        } else if([toCoordType isEqualToString:@"BD-09"]) {
            coords2 = [TQLocationConverter transformFromGCJToBaidu:coords1];
        }
    } else if([coordType isEqualToString:@"BD-09"]) {
        if ([toCoordType isEqualToString:@"WGS-84"]) {
            coords2 = [TQLocationConverter transformFromGCJToWGS:[TQLocationConverter transformFromBaiduToGCJ:coords1]];
        } else if([toCoordType isEqualToString:@"GCJ-02"]) {
            coords2 = [TQLocationConverter transformFromBaiduToGCJ:coords1];
        }
    }
    
    return @{@"latitude":@(coords2.latitude), @"longitude":@(coords2.longitude)};
}


- (void)excuteScript:(NSDictionary *)dict {
//    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.openMapCallback) {
            if (dict) {
                [self.openMapCallback callWithArguments:@[dict]];
            } else {
                NSDictionary *tmpDict = [NSDictionary new];
                [self.openMapCallback callWithArguments:@[tmpDict]];
            }
        }
        
    });
}
@end
