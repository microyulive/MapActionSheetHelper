//
//  MapActionSheet.m
//  Pods
//
//  Created by Wenji Yu on 2016/11/3.
//
//

#import "MapActionSheet.h"
#import "JZLocationConverter.h"

@interface MapActionSheet () <UIActionSheetDelegate>
@end

@implementation MapActionSheet

//生成ActionSheet
- (void)setActionSheetWithWebAction:(NSMutableDictionary *)params view:(UIView *)view {
    
    NSString *latiStr = params[@"latitude"];
    NSString *longStr = params[@"longitude"];
    double latitudeNum = latiStr.doubleValue;
    double longitudeNum = longStr.doubleValue;
    NSLog(@"Latitude = %f", latitudeNum);
    NSLog(@"Longitude = %f", longitudeNum);
    
    //ActionSheet
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择地图" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    //苹果地图自带会放在第一个位置
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [sheet addButtonWithTitle:@"百度地图"];
    }
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [sheet addButtonWithTitle:@"高德地图"];
    }
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        [sheet addButtonWithTitle:@"谷歌地图"];
    }
    
    [sheet showInView:view];
}

// 需要注意的是 iOS9.0以上的系统需要在info.plist文件设置白名单才能调起三方地图
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex latitude:(double)latitude longitude:(double)longitude appUrlScheme:(NSString *)urlScheme appName:(NSString *)appName {
    //目的地坐标
    CLLocationCoordinate2D coordinate = {latitude, longitude};
    CLLocationCoordinate2D aMapCoordinate;
    
    //GPS坐标转高德坐标方法
    CLLocationCoordinate2D coordinateTrans = {latitude, longitude};
    coordinateTrans = [JZLocationConverter gcj02ToWgs84:coordinateTrans];
    double latitudeNumCheck = coordinateTrans.latitude;
    double longitudeNumCheck = coordinateTrans.longitude;
    
    if (!latitudeNumCheck || !longitudeNumCheck || latitudeNumCheck == 0 || longitudeNumCheck == 0) {
        NSLog(@"Original");
        aMapCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    } else {
        NSLog(@"Fixed");
        aMapCoordinate = CLLocationCoordinate2DMake(latitudeNumCheck, longitudeNumCheck);
    }
    
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    
    if ([title isEqualToString:@"苹果地图"]) {
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    } else if ([title isEqualToString:@"高德地图"]) {
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://viewMap?sourceApplication=%@&poiname=房屋位置&lat=%f&lon=%f&dev=1", appName, aMapCoordinate.latitude, aMapCoordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else if ([title isEqualToString:@"百度地图"]) {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else if ([title isEqualToString:@"谷歌地图"]) {
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}




@end

