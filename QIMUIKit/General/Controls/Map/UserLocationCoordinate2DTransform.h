//
//  UserLocationCoordinate2DTransform.h
//  STChatIphone
//
//  Created by Qunar-Lu on 2017/2/22.
//
//

#import "STIMCommonUIFramework.h"
#import <CoreLocation/CoreLocation.h>

@interface UserLocationCoordinate2DTransform : NSObject

+ (instancetype)sharedInstanced;

- (CLLocationCoordinate2D)getBaiduFromGaodeForLocationCoordinate:(CLLocationCoordinate2D)gd_coordinate;

- (CLLocationCoordinate2D)getGaodeFromBaiduForLocationCoordinate:(CLLocationCoordinate2D)bd_coordinate;

@end
