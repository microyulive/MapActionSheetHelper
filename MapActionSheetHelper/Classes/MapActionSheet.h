//
//  MapActionSheet.h
//  Pods
//
//  Created by Wenji Yu on 2016/11/3.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <MapKit/MapKit.h>

#ifndef MapActionSheet_h
#define MapActionSheet_h


#endif /* MapActionSheet_h */

@interface MapActionSheet : NSObject

//通过前端传入params触发
- (void)setActionSheetWithWebAction:(NSMutableDictionary *)params view:(UIView *)view;

//此方法需要在(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex中调用
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex latitude:(double)latitude longitude:(double)longitude appUrlScheme:(NSString *)urlScheme appName:(NSString *)appName;

@end
