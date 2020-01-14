//
//  STIMQRCodeLoginVC.m
//  STChatIphone
//
//  Created by 李海彬 on 2017/10/27.
//

#import "STIMQRCodeLoginVC.h"
#import "STIMQRCodeLoginManager.h"

@interface STIMQRCodeLoginVC ()

@property (nonatomic, assign) STIMQRCodeLoginState loginState;

@property (nonatomic, strong) UIImageView *platFormImageView;

@property (nonatomic, strong) UILabel *platFormLabel;

@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *cancelLoginButton;

@end

@implementation STIMQRCodeLoginVC

#pragma mark - setter and getter

- (UIImageView *)platFormImageView {
    if (!_platFormImageView) {
        _platFormImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 108, 108)];
        if (self.iconUrl) {
            _platFormImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.iconUrl]];
        } else {
            _platFormImageView.image = [UIImage stimDB_imageNamedFromSTIMUIKitBundle:@"qunar-pc_f"];
        }
    }
    return _platFormImageView;
}

- (UILabel *)platFormLabel {
    if (!_platFormLabel) {
        _platFormLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _platFormImageView.bottom + 15, _platFormImageView.width * 2, 30)];
        _platFormLabel.text = [NSString stringWithFormat:@"%@登录确认", self.platForm];
        _platFormLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _platFormLabel;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _platFormLabel.bottom + 15, _platFormImageView.width * 4, 30)];
        _promptLabel.text = [NSString stringWithFormat:[NSBundle stimDB_localizedStringForKey:@"rescan qrCode Login"]];
        _promptLabel.textColor = [UIColor redColor];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.hidden = YES;
    }
    return _promptLabel;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(50, self.view.height - 200, 180, 50);
        _loginButton.layer.cornerRadius = 5.0f;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton setBackgroundColor:[UIColor qtalkIconSelectColor]];
    }
    return _loginButton;
}

- (UIButton *)cancelLoginButton {
    if (!_cancelLoginButton) {
        _cancelLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelLoginButton.frame = CGRectMake(100, self.view.height - 50, 80, 30);
        [_cancelLoginButton setTitle:[NSBundle stimDB_localizedStringForKey:@"Cancel Login"] forState:UIControlStateNormal];
        [_cancelLoginButton setTitleColor:[UIColor qunarTextGrayColor] forState:UIControlStateNormal];
        [_cancelLoginButton addTarget:self action:@selector(cancelLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelLoginButton;
}

- (void)setupUI {
    [self.view addSubview:self.platFormImageView];
    [self.view addSubview:self.platFormLabel];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.cancelLoginButton];
    self.platFormImageView.centerX = self.view.centerX;
    self.platFormLabel.centerX = self.view.centerX;
    self.promptLabel.centerX = self.view.centerX;
    self.loginButton.centerX = self.view.centerX;
    self.cancelLoginButton.centerX = self.view.centerX;
}

- (void)setupNav {
    UIBarButtonItem *closeBarItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle stimDB_localizedStringForKey:@"common_close"] style:UIBarButtonItemStyleDone target:self action:@selector(closeQRCodeLogin)];
    self.navigationItem.leftBarButtonItem = closeBarItem;
}

- (void)confirmLogin:(id)sender {
    STIMVerboseLog(@"%s", __func__);
    [[STIMQRCodeLoginManager shareSTIMQRCodeLoginManager] confirmQRCodeLogin];
}

- (void)cancelLogin:(id)sender {
    STIMVerboseLog(@"%s", __func__);
    [[STIMQRCodeLoginManager shareSTIMQRCodeLoginManager] cancelQRCodeLogin];
    [self closeQRCodeLogin];
}

- (void)closeQRCodeLogin {
    [[STIMQRCodeLoginManager shareSTIMQRCodeLoginManager] cancelQRCodeLogin];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginState = STIMQRCodeLoginStateNone;
    [self setupUI];
    [self refreshLoginButton];
    [self setupNav];
    [self registerObserver];
}

- (void)refreshLoginButton {
    switch (self.loginState) {
        case STIMQRCodeLoginStateNone: {
            self.promptLabel.hidden = YES;
            [self.loginButton setTitle:[NSBundle stimDB_localizedStringForKey:@"Login"] forState:UIControlStateNormal];
            [self.loginButton addTarget:self action:@selector(confirmLogin:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case STIMQRCodeLoginStateSuccess: {
            
        }
            break;
        case STIMQRCodeLoginStateFailed: {
            self.promptLabel.hidden = NO;
            self.cancelLoginButton.hidden = YES;
            [self.loginButton setTitle:[NSBundle stimDB_localizedStringForKey:@"rescan Login"] forState:UIControlStateNormal];
            [self.loginButton addTarget:self action:@selector(closeQRCodeLogin) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
}

- (void)registerObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qrcodeLoginNotify:) name:STIMQRCodeLoginStateNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)qrcodeLoginNotify:(NSNotification *)notify {
    dispatch_async(dispatch_get_main_queue(), ^{
        STIMQRCodeLoginState loginState = [notify.object unsignedIntegerValue];
        self.loginState = loginState;
        if (loginState == STIMQRCodeLoginStateSuccess) {
            STIMVerboseLog(@"二维码登陆成功");
            [self closeQRCodeLogin];
        } else {
            STIMVerboseLog(@"二维码登陆失败");
            [self refreshLoginButton];
        }
    });
}

@end
