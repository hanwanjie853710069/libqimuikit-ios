//
//  STIMMsgBaloonBaseCell.h
//  STChatIphone
//
//  Created by xueping on 15/7/9.
//
//

#import "STIMCommonUIFramework.h" 
#import "STIMMenuImageView.h"
#import "STIMCommonEnum.h"

#define ATSomeOneNotifacation @"ATSomeOneNotifacation"

#define kCellHeightCap      10
#define kBackViewCap        10

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//Avatar和SuperView之间的约束
#define AVATAR_SUPER_LEFT 10
#define AVATAR_SUPER_TOP 5
#define AVATAR_WIDTH 45
#define AVATAR_HEIGHT 45

//Name和SuperView之间的约束
#define NAME_SUPER_LEFT 10
#define NAME_SUPER_TOP 0
#define NAME_SUPER_WIDTH 160
#define NAME_SUPER_HEIGHT 18

//MedalListView 和superView之间的约束
#define MEDAL_SUPER_LEFT 3
#define MEDAL_SUPER_TOP 0
#define MEDAL_SUPER_WIDTH 160
#define MEDAL_SUPER_HEIGHT 18

#define CELL_EDIT_OFFSET 36

@protocol STIMMsgBaloonBaseCellDelegate <NSObject>

- (void)processEvent:(MenuActionType)eventType withMessage:(id) message;

- (NSUInteger)getColorHex:(NSString *)text;

@end

@interface STIMMsgBaloonBaseCell : UITableViewCell

@property (nonatomic, strong) STIMMenuImageView *backView;

@property (nonatomic, strong) UIImageView *HeadView; //用户头像

@property (nonatomic, strong) UILabel *nameLabel;   //用户昵称

@property (nonatomic, strong) UIView *medalListView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;   //加载菊花

@property (nonatomic, strong) UILabel *messgaeRealStateLabel;   //发消息真实状态（后门）

@property (nonatomic, strong) UILabel *messgaeStateLabel;   //发消息状态Label

@property (nonatomic, strong) UIImageView *messgaeStateIcon;   //发消息状态Icon

@property (nonatomic, strong) UIButton *statusButton;   //消息发送状态按钮

@property (nonatomic,weak) id <STIMMsgBaloonBaseCellDelegate> delegate;

@property (nonatomic, weak) UIViewController *owerViewController;

@property (nonatomic, assign) CGFloat frameWidth;

@property (nonatomic, strong)STIMMessageModel *message;

@property (nonatomic, assign) ChatType chatType;     //当前会话类型

+ (CGFloat)getCellHeightWithMessage:(STIMMessageModel *)message chatType:(ChatType)chatType;

- (void)initBackViewAndHeaderName;

- (void)setBackViewWithWidth:(CGFloat)backWidth WithHeight:(CGFloat)backHeight;

- (void)refreshUI;

+ (UIImage *)leftBallocImage;

+ (UIImage *)rightBallcoImage;


@end
