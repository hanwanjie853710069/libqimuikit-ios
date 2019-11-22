//
//  NSBundle+STIMImagePicker.h
//  STIMImagePickerController
//
//  Created by 谭真 on 16/08/18.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (STIMImagePicker)

+ (NSBundle *)qim_imagePickerBundle;

+ (NSString *)qim_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)qim_localizedStringForKey:(NSString *)key;

@end

