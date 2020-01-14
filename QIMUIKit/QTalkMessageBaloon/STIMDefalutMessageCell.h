//
//  STIMDefalutMessageCell.h
//  STChatIphone
//
//  Created by 李海彬 on 2018/2/2.
//

#import "STIMCommonUIFramework.h"

@class STIMMsgBaloonBaseCell;
@interface STIMDefalutMessageCell : STIMMsgBaloonBaseCell

@property (nonatomic, strong)STIMMessageModel *message;

@property (nonatomic, strong) UIImageView *HeaderView;  //用户头像

@property (nonatomic, strong) UILabel *nameLabel; //用户昵称

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;   //加载菊花

@property (nonatomic, strong) UIButton *statusButton;   //消息发送状态按钮

@property (nonatomic, assign) ChatType chatType;

@property (nonatomic, assign) CGFloat frameWidth;

@property (nonatomic,weak)id<STIMMsgBaloonBaseCellDelegate> delegate;

- (void)refreshUI;

@end