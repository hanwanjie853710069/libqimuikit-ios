
#import "STIMOfficialAccountToolbar.h"
#import "STIMChatKeyBoardMacroDefine.h"

@implementation STIMOfficialAccountToolbar
{
    UIButton *_switchBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor stimDB_colorWithHex:0xf9f9f9 alpha:1];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        [lineView setBackgroundColor:[UIColor qtalkSplitLineColor]];
        [self addSubview:lineView];
        _switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_switchBtn setImage:[UIImage stimDB_imageNamedFromSTIMUIKitBundle:@"Mode_listtotext"] forState:UIControlStateNormal];
        [_switchBtn setImage:[UIImage stimDB_imageNamedFromSTIMUIKitBundle:@"Mode_listtotextHL"] forState:UIControlStateHighlighted];
        [_switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_switchBtn];
    }
    return self;
}

- (void)switchAction:(UIButton *)btn
{
    if (self.switchAction) {
        self.switchAction();
    }
}

@end