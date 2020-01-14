//
//  STIMNavBar.h
//  STChatIphone
//
//  Created by haibin.li on 15/11/17.
//
//

#import "STIMCommonUIFramework.h"

@interface STIMNavBar : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setNavBarBackgroundColor:(UIColor *)bgColor;

- (void)setNavBarLeftItem:(UIView *)item;

- (void)setNavBarLeftItems:(NSArray *)items;

- (void)setNavBarRightItem:(UIView *)item;

- (void)setNavBarRightItems:(NSArray *)items;

- (void)setNavBarTitle:(NSString *)title;

- (void)setNavBarTitleViewFont:(UIFont *)font;

- (void)setNavBarTitleColor:(UIColor *)titleColor;

- (void)setNavBarBackgroundView:(UIView *)bgView;

- (void)setNavBarBackgroundViewAlpha:(CGFloat)alpha;

@end
