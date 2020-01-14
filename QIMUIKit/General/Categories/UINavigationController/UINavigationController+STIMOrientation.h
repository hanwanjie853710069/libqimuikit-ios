//
//  UINavigationController+STIMOrientation.h
//  STIMUIKit
//
//  Created by 李海彬 on 2018/9/3.
//  Copyright © 2018年 STIM. All rights reserved.
//

#import "STIMCommonUIFramework.h"

@interface UINavigationController (STIMOrientation)

- (BOOL)shouldAutorotate;

- (UIInterfaceOrientationMask)supportedInterfaceOrientations;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;

@end
