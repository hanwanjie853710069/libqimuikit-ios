//
//  STIMPublicLogin.m
//  STIMUIKit
//
//  Created by lilu on 2019/2/14.
//  Copyright © 2019 STIM. All rights reserved.
//

#import "STIMPublicLogin.h"
#import "YYKeyboardManager.h"
#import "STIMPublicCompanyModel.h"
#import "STIMNavConfigManagerVC.h"
#import "YYModel.h"
#import "STIMUUIDTools.h"
#import "STIMProgressHUD.h"
#import "STIMAgreementViewController.h"
#import "STIMSelectComponyViewController.h"
#import "STIMZBarViewController.h"
#import "MBProgressHUD.h"
#import "STIMWebView.h"
#import "STIMNavConfigManagerVC.h"
#import "loginUnSettingNavView.h"

static const int companyTag = 10001;

@interface STIMPublicLoginHeader : UIView

@end

@implementation STIMPublicLoginHeader

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        ((CAGradientLayer *)self.layer).startPoint = CGPointMake(0, 0);
        ((CAGradientLayer *)self.layer).endPoint = CGPointMake(1, 0);
        ((CAGradientLayer *)self.layer).colors = @[(__bridge id)[UIColor stimDB_colorWithHex:0x2EFFD7].CGColor,(__bridge id)[UIColor stimDB_colorWithHex:0x0BE5D3].CGColor,(__bridge id)[UIColor stimDB_colorWithHex:0x0ED6C8].CGColor];
        ((CAGradientLayer *)self.layer).locations = @[@(0), @(0.3), @(1.0f)];
    }
    return self;
}

@end

@interface STIMPublicLoginButton : UIButton

@end

@implementation STIMPublicLoginButton
@synthesize enabled = _enabled;
+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        ((CAGradientLayer *)self.layer).startPoint = CGPointMake(0, 0);
        ((CAGradientLayer *)self.layer).endPoint = CGPointMake(1, 0);
        ((CAGradientLayer *)self.layer).colors = @[(__bridge id)[UIColor stimDB_colorWithHex:0x2EFFD7].CGColor,(__bridge id)[UIColor stimDB_colorWithHex:0x0BE5D3].CGColor,(__bridge id)[UIColor stimDB_colorWithHex:0x0ED6C8].CGColor];
        ((CAGradientLayer *)self.layer).locations = @[@(0), @(0.3), @(1.0f)];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    if (enabled) {
        ((CAGradientLayer *)self.layer).startPoint = CGPointMake(0, 0);
        ((CAGradientLayer *)self.layer).endPoint = CGPointMake(1, 0);
        ((CAGradientLayer *)self.layer).colors = @[(__bridge id)[UIColor stimDB_colorWithHex:0x2EFFD7].CGColor,(__bridge id)[UIColor stimDB_colorWithHex:0x0BE5D3].CGColor,(__bridge id)[UIColor stimDB_colorWithHex:0x0ED6C8].CGColor];
        ((CAGradientLayer *)self.layer).locations = @[@(0), @(0.3), @(1.0f)];
    } else {
        ((CAGradientLayer *)self.layer).startPoint = CGPointMake(0, 0);
        ((CAGradientLayer *)self.layer).endPoint = CGPointMake(1, 0);
        ((CAGradientLayer *)self.layer).colors =nil;
        ((CAGradientLayer *)self.layer).locations = @[@(0), @(0.3), @(1.0f)];
    }
}

@end


@interface STIMPublicLogin () <UITextFieldDelegate, YYKeyboardObserver, UITableViewDelegate, UITableViewDataSource,loginUnSettingNavViewDelegate,NSURLSessionTaskDelegate>

@property (nonatomic, strong) STIMPublicLoginHeader *headerView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) UILabel *loginTitleLabel;  //登录Label

@property (nonatomic, strong) UIButton *registerNewCompanyBtn;  //注册新公司按钮

@property (nonatomic, strong) UIButton * registerUserBtn;

@property (nonatomic, assign) BOOL multipleLogin;  //是否为多次登录

@property (nonatomic, strong) UILabel *companyShowLabel; //二次登录公司名

@property (nonatomic, strong) UIButton *switchCompanyBtn; //二次登录公司切换名按钮

@property (nonatomic, strong) UIView *userNameBgView;         //用户名LineView
@property (nonatomic, strong) UIImageView *userNameIcon;
@property (nonatomic, strong) UITextField *userNameTextField;   //用户名TextField

@property (nonatomic, strong) UIView *userPwdBgView;         //用户密码LineView
@property (nonatomic, strong) UIImageView *userPwdIcon;
@property (nonatomic, strong) UITextField *userPwdTextField;    //用户密码TextField


//@property (nonatomic, strong) UITextField *companyTextField;    //公司名TextField

//@property (nonatomic, strong) UIView *companyLineView;         //公司名LineView

@property (nonatomic, strong) UIButton *checkBtn;               //条款Btn

@property (nonatomic, strong) UILabel *textLabel;               //条款Label

@property (nonatomic, strong) UIButton *loginBtn;   //登录按钮

@property (nonatomic, strong) UIButton *forgotBtn;  //忘记密码

//@property (nonatomic, strong) UIButton *settingBtn;             //设置Btn

@property (nonatomic, assign) CGFloat keyboardOriginY;

@property (nonatomic, strong) STIMPublicCompanyModel *companyModel;

@property (nonatomic, strong) UIButton * scanSettingNavBtn;

@property (nonatomic, strong) loginUnSettingNavView * alertView;

@end

@implementation STIMPublicLogin

#pragma mark - setter and getter


- (UILabel *)loginTitleLabel {
    if (!_loginTitleLabel) {
        _loginTitleLabel = [[UILabel alloc] init];
        _loginTitleLabel.font = [UIFont boldSystemFontOfSize:26];
        _loginTitleLabel.textColor = [UIColor stimDB_colorWithHex:0x333333];
        _loginTitleLabel.text = [NSBundle stimDB_localizedStringForKey:@"login"];
        [_loginTitleLabel sizeToFit];
    }
    return _loginTitleLabel;
}

- (UIButton *)registerNewCompanyBtn {
    if (!_registerNewCompanyBtn) {
        _registerNewCompanyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerNewCompanyBtn setTitle:[NSBundle stimDB_localizedStringForKey:@"not_have_company"] forState:UIControlStateNormal];
        _registerNewCompanyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_registerNewCompanyBtn setTitleColor:[UIColor stimDB_colorWithHex:0x999999] forState:UIControlStateNormal];
        [_registerNewCompanyBtn addTarget:self action:@selector(registerNew:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerNewCompanyBtn;
}

- (UIButton *)registerUserBtn{
    if (!_registerUserBtn) {
        _registerUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerUserBtn setTitle:[NSBundle stimDB_localizedStringForKey:@"login_sign_Up"] forState:UIControlStateNormal];
        [_registerUserBtn setTitleColor:[UIColor stimDB_colorWithHex:0x00CABE] forState:UIControlStateNormal];
        _registerUserBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_registerUserBtn addTarget:self action:@selector(registerNewUserBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerUserBtn;
}

- (UILabel *)companyShowLabel {
    if (!_companyShowLabel) {
        _companyShowLabel = [[UILabel alloc] init];
        _companyShowLabel.textColor = [UIColor stimDB_colorWithHex:0x999999];
        _companyShowLabel.font = [UIFont systemFontOfSize:15];
        [_companyShowLabel sizeToFit];
    }
    return _companyShowLabel;
}

- (UIButton *)switchCompanyBtn {
    if (!_switchCompanyBtn) {
        _switchCompanyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchCompanyBtn setImage:[UIImage qimIconWithInfo:[STIMIconInfo iconInfoWithText:@"\U0000e31f" size:12 color:[UIColor stimDB_colorWithHex:0x00CABE]]] forState:UIControlStateNormal];
        [_switchCompanyBtn setImage:[UIImage qimIconWithInfo:[STIMIconInfo iconInfoWithText:@"\U0000e31f" size:12 color:[UIColor stimDB_colorWithHex:0x00CABE]]] forState:UIControlStateSelected];
        [_switchCompanyBtn addTarget:self action:@selector(gotoSelectCompany:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCompanyBtn;
}

- (UIImageView *)userNameIcon {
    if (_userNameIcon == nil) {
        _userNameIcon = [[UIImageView alloc] initWithImage:[UIImage stimDB_imageNamedFromSTIMUIKitBundle:@"user_icon"]];
    }
    return _userNameIcon;
}

- (UITextField *)userNameTextField {
    if (!_userNameTextField) {
        _userNameTextField = [[UITextField alloc] init];
        _userNameTextField.placeholder = [NSBundle stimDB_localizedStringForKey:@"Login_name"];
        _userNameTextField.delegate = self;
        _userNameTextField.backgroundColor = [UIColor clearColor];
        _userNameTextField.textColor = [UIColor stimDB_colorWithHex:0x666666];
    }
    return _userNameTextField;
}

- (UIView *)userNameBgView {
    if (_userNameBgView == nil) {
        _userNameBgView = [[UIView alloc] init];
        _userNameBgView.backgroundColor = [UIColor stimDB_colorWithHex:0xEEEEEE];
        _userNameBgView.clipsToBounds = YES;
        _userNameBgView.layer.cornerRadius = 8;
    }
    return _userNameBgView;
}

- (UIImageView *)userPwdIcon {
    if (_userPwdIcon == nil) {
        _userPwdIcon = [[UIImageView alloc] initWithImage:[UIImage stimDB_imageNamedFromSTIMUIKitBundle:@"pwd_icon"]];
    }
    return _userPwdIcon;
}

- (UITextField *)userPwdTextField {
    if (!_userPwdTextField) {
        _userPwdTextField = [[UITextField alloc] init];
        _userPwdTextField.placeholder = [NSBundle stimDB_localizedStringForKey:@"Login_password"];
        _userPwdTextField.delegate = self;
        _userPwdTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _userPwdTextField.secureTextEntry = YES;
        _userPwdTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _userPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userPwdTextField.backgroundColor = [UIColor clearColor];
    }
    if (self.companyModel) {
        _userPwdTextField.returnKeyType = UIReturnKeyGo;
    } else {
        _userPwdTextField.returnKeyType = UIReturnKeyNext;
    }
    return _userPwdTextField;
}

- (UIView *)userPwdBgView {
    if (_userPwdBgView == nil) {
        _userPwdBgView = [[UIView alloc] init];
        _userPwdBgView.backgroundColor = [UIColor stimDB_colorWithHex:0xEEEEEE];
        _userPwdBgView.clipsToBounds = YES;
        _userPwdBgView.layer.cornerRadius = 8;
    }
    return _userPwdBgView;
}

//- (UITextField *)companyTextField {
//    if (!_companyTextField) {
//        _companyTextField = [[UITextField alloc] init];
//        _companyTextField.placeholder = @"请输入公司名";
//        _companyTextField.delegate = self;
//        _companyTextField.backgroundColor = [UIColor whiteColor];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSelectCompany:)];
//        [_companyTextField addGestureRecognizer:tap];
//    }
//    return _companyTextField;
//}

- (UIButton *)scanSettingNavBtn{
    if (!_scanSettingNavBtn) {
        _scanSettingNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanSettingNavBtn.backgroundColor = [UIColor clearColor];
        [_scanSettingNavBtn setTitle:[NSBundle stimDB_localizedStringForKey:@"login_scan"] forState:UIControlStateNormal];
        [_scanSettingNavBtn setTitleColor:[UIColor stimDB_colorWithHex:0x0BB7AB] forState:UIControlStateNormal];
        _scanSettingNavBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:4];
        [_scanSettingNavBtn setImage:[UIImage qimIconWithInfo:[STIMIconInfo iconInfoWithText:@"\U0000f0f5" size:20 color:[UIColor stimDB_colorWithHex:0x0BB7AB]]] forState:UIControlStateNormal];
        [_scanSettingNavBtn setImage:[UIImage qimIconWithInfo:[STIMIconInfo iconInfoWithText:@"\U0000f0f5" size:20 color:[UIColor stimDB_colorWithHex:0x0BB7AB]]] forState:UIControlStateSelected];
        [_scanSettingNavBtn addTarget:self action:@selector(scanCodeSettingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _scanSettingNavBtn.layer.masksToBounds = YES;
        _scanSettingNavBtn.layer.cornerRadius = 4;
        _scanSettingNavBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0 - 7 / 2, 0, 0 + 7 / 2);
        _scanSettingNavBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0 + 7 / 2, 0, 0 - 7 / 2);
    }
    return _scanSettingNavBtn;
}

//- (UIView *)companyLineView {
//    if (!_companyLineView) {
//        _companyLineView = [[UIView alloc] init];
//        _companyLineView.backgroundColor = [UIColor stimDB_colorWithHex:0xDDDDDD];
//    }
//    return _companyLineView;
//}

- (UIButton *)forgotBtn {
    if (!_forgotBtn) {
        _forgotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgotBtn setTitleColor:[UIColor stimDB_colorWithHex:0x00CABE] forState:UIControlStateNormal];
        [_forgotBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_forgotBtn setTitle:[NSBundle stimDB_localizedStringForKey:@"login_forget_password"] forState:UIControlStateNormal];
        [_forgotBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_forgotBtn addTarget:self action:@selector(forgotPWD:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotBtn;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor stimDB_colorWithHex:0x999999];
        _textLabel.font = [UIFont systemFontOfSize:14];
        NSString *commentNumStr = [NSBundle stimDB_localizedStringForKey:@"login_privacy_policy"];
        NSString *titleText = [NSString stringWithFormat:@"%@%@", [NSBundle stimDB_localizedStringForKey:@"login_agree"],  commentNumStr];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:titleText];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor spectralColorGrayBlueColor], NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                range:[titleText rangeOfString:commentNumStr]];
        [_textLabel setAttributedText:attributedText];
        _textLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreementBtnHandle:)];
        [_textLabel addGestureRecognizer:tap];
    }
    return _textLabel;
}

- (UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setImage:[UIImage qimIconWithInfo:[STIMIconInfo iconInfoWithText:@"\U0000e337" size:17 color:[UIColor stimDB_colorWithHex:0xE4E4E4]]] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage qimIconWithInfo:[STIMIconInfo iconInfoWithText:@"\U0000e337" size:17 color:[UIColor stimDB_colorWithHex:0x00CABE]]] forState:UIControlStateSelected];
        _checkBtn.selected = YES;
        [_checkBtn addTarget:self action:@selector(agreeBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[STIMPublicLoginButton alloc] init];
        [_loginBtn setTitle:[NSBundle stimDB_localizedStringForKey:@"login"] forState:UIControlStateNormal];
        UIImage *disableImage = [UIImage stimDB_imageWithColor:[UIColor stimDB_colorWithHex:0x0EDBCC alpha:0.5]];
        [_loginBtn setBackgroundImage:disableImage forState:UIControlStateDisabled];
        //        UIImage *normalImage = [UIImage stimDB_imageWithColor:[UIColor stimDB_colorWithHex:0x00CABE]];
        [_loginBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.layer.cornerRadius = 16.0f;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.enabled = NO;
    }
    return _loginBtn;
}

//- (UIButton *)settingBtn {
//    if (_settingBtn == nil) {
//
//        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_settingBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//        [_settingBtn setTitleColor:[UIColor stimDB_colorWithHex:0x999999] forState:UIControlStateNormal];
//        [_settingBtn setTitle:@[NSBundle stimDB_localizedStringForKey:@"nav_Set_Service_Address"] forState:UIControlStateNormal];
//        [_settingBtn setImage:[UIImage stimDB_imageNamedFromSTIMUIKitBundle:@"iconSetting"] forState:UIControlStateNormal];
//        [_settingBtn addTarget:self action:@selector(onSettingClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _settingBtn;
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotify:) name:kNotificationLoginState object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNavDicts:) name:@"NavConfigSettingChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(streamEnd:) name:@"kNotificationOutOfDate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(streamEnd:) name:@"kNotificationStreamEnd" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    NSString *lastUserName = [STIMKit getLastUserName];
    NSString * userToken = [[STIMKit sharedInstance] getLastUserToken];
    //    [[STIMKit sharedInstance] userObjectForKey:@"userToken"];
    if (userToken && lastUserName) {
        
        [self autoLogin];
        
    } else if (lastUserName && !userToken) {
        //如果本地还有用户名，自动输入
        _userNameTextField.text = lastUserName;
    } else {
        
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.userPwdTextField) {
        if (textField.text.length - range.length + string.length >= 1 && self.userNameTextField.text.length > 0 && self.companyModel.domain.length > 0) {
            [self updateLoginEnable:YES];
        } else if([[self.userNameTextField.text lowercaseString] isEqualToString:@"appstore"]) {
            [self updateLoginEnable:YES];
        } else {
            [self updateLoginEnable:NO];
        }
    } else if (textField == self.userNameTextField) {
        if (textField.text.length - range.length + string.length >= 1 && self.userPwdTextField.text.length > 0 && self.companyModel.domain.length > 0) {
            [self updateLoginEnable:YES];
        } else {
            [self updateLoginEnable:NO];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.userPwdTextField) {
        [self updateLoginEnable:NO];
    } else if (textField == self.userNameTextField) {
        [self updateLoginEnable:NO];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.userPwdTextField == textField) {
        if (self.companyModel && self.userNameTextField.text.length) {
            [self clickLogin:nil];
        }
    } else {
        
    }
    return YES;
}

- (void)updateLoginEnable:(BOOL)flag {
    [self.loginBtn setEnabled:flag];
}

- (void)updateLoginUI {
    if (self.userNameTextField.text.length > 0 && self.userPwdTextField.text.length > 0 && self.companyModel.domain.length > 0) {
        [self.loginBtn setEnabled:YES];
    } else {
        [self.loginBtn setEnabled:NO];
    }
}

- (void)initHeaderView {
    self.headerView = [[STIMPublicLoginHeader alloc] init];
    [self.headerView setClipsToBounds:YES];
    [self.headerView.layer setCornerRadius:20];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view).offset(-25);
        make.height.mas_equalTo(220);
    }];
    
    self.headerLabel = [[UILabel alloc] init];
    [self.headerLabel setBackgroundColor:[UIColor clearColor]];
    [self.headerLabel setFont:[UIFont systemFontOfSize:16]];
    [self.headerLabel setTextColor:[UIColor whiteColor]];
    [self.headerLabel setTextAlignment:NSTextAlignmentCenter];
    [self.headerLabel setText:@"Hi，欢迎到来！"];
    [self.headerView addSubview:self.headerLabel];
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headerView).offset(-40);
        make.left.right.mas_equalTo(self.headerView);
        make.height.mas_equalTo(20);
    }];
    
    self.iconView = [[UIImageView alloc] initWithImage:[UIImage stimDB_imageNamedFromSTIMUIKitBundle:@"login_icon"]];
    [self.iconView setContentMode:UIViewContentModeScaleToFill];
    [self.headerView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.bottom.mas_equalTo(self.headerLabel.mas_top).offset(-10);
        make.centerX.mas_equalTo(self.headerView);
    }];
}

- (void)setupUI {
    
    [self initHeaderView];
    
    NSMutableDictionary *oldNavConfigUrlDict = [[STIMKit sharedInstance] userObjectForKey:@"QC_CurrentNavDict"];
    STIMVerboseLog(@"本地找到的oldNavConfigUrlDict : %@", oldNavConfigUrlDict);
    if (oldNavConfigUrlDict.count) {
        self.multipleLogin = YES;
        STIMPublicCompanyModel *companyModel = [[STIMPublicCompanyModel alloc] init];
        companyModel.name = [oldNavConfigUrlDict objectForKey:STIMNavNameKey];
        companyModel.domain = [oldNavConfigUrlDict objectForKey:STIMNavNameKey];
        companyModel.nav = [oldNavConfigUrlDict objectForKey:STIMNavUrlKey];
        self.companyModel = companyModel;
    } else {
        self.multipleLogin = NO;
    }
    
    UIView *settingView = [UIView new];
    [self.view addSubview:settingView];
    [settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(40);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [settingView addSubview:self.scanSettingNavBtn];
    [self.scanSettingNavBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(settingView);
        make.height.mas_equalTo(@(30));
        make.width.mas_equalTo(@(126));
    }];
    
    [self.view addSubview:self.registerNewCompanyBtn];
    UIFont *fnt = [UIFont systemFontOfSize:12];
    CGSize size = [[NSBundle stimDB_localizedStringForKey:@"not_have_company"] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil]];
    [self.registerNewCompanyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_offset(-30);
        make.width.mas_equalTo(size.width + 30);
        make.height.mas_equalTo(21);
    }];
    
    
    UIFont *registerUserBtnFont = [UIFont systemFontOfSize:12];
    CGSize registerUserBtnSize = [[NSBundle stimDB_localizedStringForKey:@"login_sign_Up"] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:registerUserBtnFont,NSFontAttributeName,nil]];
    [self.view addSubview:self.registerUserBtn];
    [self.registerUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((56 + 38/2) - 30/2);
        make.height.mas_equalTo(@(30));
        make.width.mas_equalTo(@(registerUserBtnSize.width + 5));
        make.right.mas_equalTo(@(-16));
    }];
    self.registerUserBtn.hidden = YES;
    
    if ([[STIMKit sharedInstance] qimNav_isToC]) {
        self.registerUserBtn.hidden = NO;
        self.scanSettingNavBtn.hidden = YES;
    }
    else{
        self.registerUserBtn.hidden = YES;
        self.scanSettingNavBtn.hidden = NO;
    }
    
    [self.view addSubview:self.userNameBgView];
    [self.userNameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(settingView.mas_bottom).mas_offset(30);
        make.left.mas_offset(33);
        make.right.mas_offset(-33);
        make.height.mas_equalTo(50);
    }];
    
    [self.userNameBgView addSubview:self.userNameIcon];
    [self.userNameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userNameBgView);
        make.left.mas_equalTo(self.userNameBgView).offset(12);
        make.width.height.mas_equalTo(15);
    }];
    
    [self.userNameBgView addSubview:self.userNameTextField];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userNameBgView);
        make.left.mas_equalTo(self.userNameBgView.mas_left).offset(40);
        make.right.mas_equalTo(self.userNameBgView.mas_right).offset(-12);
        make.height.mas_equalTo(35);
    }];
    
    [self.view addSubview:self.userPwdBgView];
    [self.userPwdBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameBgView.mas_bottom).mas_offset(30);
        make.left.mas_offset(33);
        make.right.mas_offset(-33);
        make.height.mas_equalTo(50);
    }];
    
    [self.userPwdBgView addSubview:self.userPwdIcon];
    [self.userPwdIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userPwdBgView);
        make.left.mas_equalTo(self.userPwdBgView).offset(12);
        make.width.height.mas_equalTo(15);
    }];
    
    [self.userPwdBgView addSubview:self.userPwdTextField];
    [self.userPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userPwdBgView);
        make.left.mas_equalTo(self.userPwdBgView.mas_left).offset(40);
        make.right.mas_equalTo(self.userPwdBgView.mas_right).offset(-12);
        make.height.mas_equalTo(35);
    }];
    
    if (self.multipleLogin) {
        //多次登录，展示切换公司按钮，不展示公司TextField
        
        NSMutableDictionary *oldNavConfigUrlDict = [[STIMKit sharedInstance] userObjectForKey:@"QC_CurrentNavDict"];
        STIMVerboseLog(@"本地找到的oldNavConfigUrlDict : %@", oldNavConfigUrlDict);
        NSString *navTitle = [oldNavConfigUrlDict objectForKey:@"title"];
        [self.companyShowLabel setText:navTitle];
        UIFont *navTitleFont = [UIFont systemFontOfSize:14];
        // 根据字体得到NSString的尺寸
        CGSize navTitleSize = [navTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:navTitleFont,NSFontAttributeName,nil]];
        
        [settingView addSubview:self.switchCompanyBtn];
        [self.switchCompanyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.scanSettingNavBtn.mas_right).mas_offset(30);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(12);
            make.centerY.mas_equalTo(self.scanSettingNavBtn.mas_centerY);
        }];
        
        [settingView addSubview:self.companyShowLabel];
        [self.companyShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.switchCompanyBtn.mas_right).offset(5);
            make.height.mas_equalTo(18);
            if (navTitleSize.width>220) {
                make.width.mas_equalTo(220);
            } else {
                make.width.mas_equalTo(navTitleSize.width + 10);
            }
            make.centerY.mas_equalTo(self.scanSettingNavBtn);
            make.right.mas_equalTo(settingView);
        }];
        
        
        [self updateLoginUI];
    } else {
        //第一次登录，展示公司TextField，不展示切换公司按钮
        [self.scanSettingNavBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(settingView);
        }];
    }
    
    if (self.multipleLogin) {
        
        //        [self.view addSubview:self.companyTextField];
        //        [self.companyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.mas_equalTo(self.userPwdLineView.mas_bottom).mas_offset(30);
        //            make.left.mas_equalTo(self.userPwdLineView.mas_left);
        //            make.right.mas_equalTo(self.userPwdLineView.mas_right);
        //            make.height.mas_equalTo(35);
        //        }];
        
        [self.view addSubview:self.forgotBtn];
        UIFont *forgotBtnFont = [UIFont systemFontOfSize:14];
        // 根据字体得到NSString的尺寸
        CGSize forgotBtnSize = [[NSBundle stimDB_localizedStringForKey:@"login_forget_password"] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:forgotBtnFont,NSFontAttributeName,nil]];
        [self.forgotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userPwdBgView.mas_bottom).mas_offset(12);
            make.right.mas_equalTo(self.userPwdBgView.mas_right);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(forgotBtnSize.width+30);
        }];
        
        
        [self.view addSubview:self.checkBtn];
        [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userPwdBgView.mas_bottom).mas_offset(12);
            make.left.mas_equalTo(self.userPwdBgView.mas_left);
            make.height.mas_equalTo(17);
            make.width.mas_equalTo(17);
        }];
        
    } else {
        UIFont *forgotBtnFont = [UIFont systemFontOfSize:14];
        // 根据字体得到NSString的尺寸
        CGSize forgotBtnSize = [[NSBundle stimDB_localizedStringForKey:@"login_forget_password"] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:forgotBtnFont,NSFontAttributeName,nil]];
        [self.view addSubview:self.forgotBtn];
        [self.forgotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userPwdBgView.mas_bottom).mas_offset(12);
            make.right.mas_equalTo(self.userPwdBgView.mas_right);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(forgotBtnSize.width+30);
        }];
        
        
        [self.view addSubview:self.checkBtn];
        [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userPwdBgView.mas_bottom).mas_offset(12);
            make.left.mas_equalTo(self.userPwdBgView.mas_left);
            make.height.mas_equalTo(17);
            make.width.mas_equalTo(17);
        }];
    }
    
    
    [self.view addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkBtn.mas_right).mas_offset(8);
        make.right.mas_equalTo(self.forgotBtn.mas_left).mas_offset(8);
        make.height.mas_equalTo(16);
        make.centerY.mas_equalTo(self.forgotBtn.mas_centerY);
    }];
    
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.forgotBtn.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(self.userPwdBgView.mas_left);
        make.right.mas_equalTo(self.userNameBgView.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    //    [self.view addSubview:self.settingBtn];
    //    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.mas_equalTo(0);
    //        make.bottom.mas_equalTo(-30);
    //        make.height.mas_equalTo(24);
    //    }];
}

- (void)keyboardChangedWithTransition:(YYKeyboardTransition)transition {
    CGRect kbFrame1 = [[YYKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    CGFloat kbFrameOriginY = CGRectGetMinY(kbFrame1);
    self.keyboardOriginY = kbFrameOriginY;
}

#pragma mark - Action

- (void)registerNew:(id)sender {
    [STIMFastEntrance openWebViewForUrl:@"https://i.startalk.im/home/#/register" showNavBar:YES];
}

- (void)forgotPWD:(id)sender {
    if (!(self.companyModel != nil && self.companyModel.nav.length >0)) {
        self.alertView = [[loginUnSettingNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self];
        [self.view addSubview:self.alertView];
        return;
    }
    [STIMFastEntrance openWebViewForUrl:[[STIMKit sharedInstance] qimNav_resetPwdUrl] showNavBar:YES];
}

- (void)agreementBtnHandle:(UIButton *)sender {
    STIMAgreementViewController * agreementVC = [[STIMAgreementViewController alloc] init];
    STIMNavController * nav = [[STIMNavController alloc]initWithRootViewController:agreementVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)autoLogin {
    // 增加 appstore 验证通过能力
    // 修正偶尔无法登录的问题
    NSString *lastUserName = [STIMKit getLastUserName];
    _userNameTextField.text = lastUserName;
    _userPwdTextField.text = @"......";
    
    if ([[lastUserName lowercaseString] isEqualToString:@"appstore"]) {
        NSDictionary *testQTalkNav = @{STIMNavNameKey:@"Startalk", STIMNavUrlKey:@"https://qt.qunar.com/package/static/qtalk/nav"};
        [[STIMKit sharedInstance] qimNav_updateNavigationConfigWithNavDict:testQTalkNav WithUserName:lastUserName Check:YES WithForcedUpdate:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[STIMKit sharedInstance] updateLastTempUserToken:@"appstore"];
            [[STIMKit sharedInstance] loginWithUserName:lastUserName WithPassWord:lastUserName];
        });
    } else {
        NSString *token = [[STIMKit sharedInstance] getLastUserToken];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[STIMKit sharedInstance] loginWithUserName:lastUserName WithPassWord:token];
        });
    }
}

- (void)clickLogin:(id)sender {
    
    if (self.checkBtn.selected == NO) {
        __weak __typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSBundle stimDB_localizedStringForKey:@"Reminder"] message:@"请选择同意Startalk服务条款后登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[NSBundle stimDB_localizedStringForKey:@"Confirm"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSString *userName = [[self.userNameTextField text] lowercaseString];
        userName = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *validCode = self.userPwdTextField.text;
#warning 报错即将登陆的用户名 并请求导航
        [[STIMProgressHUD sharedInstance] showProgressHUDWithTest:[NSBundle stimDB_localizedStringForKey:@"login_waiting"]];
        [[STIMKit sharedInstance] setUserObject:userName forKey:@"currentLoginUserName"];
        if ([[userName lowercaseString] isEqualToString:@"appstore"]) {
            NSDictionary *testQTalkNav = @{STIMNavNameKey:@"Startalk", STIMNavUrlKey:@"https://qt.qunar.com/package/static/qtalk/nav"};
            [[STIMKit sharedInstance] qimNav_updateNavigationConfigWithNavDict:testQTalkNav WithUserName:userName Check:YES WithForcedUpdate:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[STIMKit sharedInstance] loginWithUserName:userName WithPassWord:userName];
            });
        } else {
            if ([[STIMKit sharedInstance] qimNav_LoginType] == QTLoginTypeNewPwd) {
                
                NSDictionary *publicQTalkNav = @{STIMNavNameKey:(self.companyModel.name.length > 0) ? self.companyModel.name : self.companyModel.domain, STIMNavUrlKey:self.companyModel.nav};
                [[STIMKit sharedInstance] qimNav_updateNavigationConfigWithNavDict:publicQTalkNav WithUserName:userName Check:YES WithForcedUpdate:YES];
                __weak id weakSelf = self;
                NSString *pwd = self.userPwdTextField.text;
                [[STIMKit sharedInstance] getNewUserTokenWithUserName:userName WithPassword:pwd withCallback:^(NSDictionary *result) {
                    if (result) {
                        BOOL ret = [[result objectForKey:@"ret"] boolValue];
                        NSInteger errcode = [[result objectForKey:@"errcode"] integerValue];
                        if (ret && errcode == 0) {
                            NSDictionary *data = [result objectForKey:@"data"];
                            NSString *newUserName = [data objectForKey:@"u"];
                            NSString *newToken = [data objectForKey:@"t"];
                            if (newUserName.length && newToken.length) {
                                [[STIMKit sharedInstance] updateLastTempUserToken:newToken];
                                [[STIMKit sharedInstance] loginWithUserName:newUserName WithPassWord:newToken];
                            }
                        } else {
                            NSString *errmsg = [result objectForKey:@"data"];
                            if (!errmsg.length) {
                                errmsg = @"验证失败";
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                [alertView show];
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                            });
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf showNetWorkUnableAlert];
                        });
                    }
                }];
            } else {
                NSDictionary *publicQTalkNav = @{STIMNavNameKey:(self.companyModel.name.length > 0) ? self.companyModel.name : self.companyModel.domain, STIMNavUrlKey:self.companyModel.nav};
                [[STIMKit sharedInstance] qimNav_updateNavigationConfigWithNavDict:publicQTalkNav WithUserName:userName Check:YES WithForcedUpdate:YES];
                __weak id weakSelf = self;
                NSString *pwd = self.userPwdTextField.text;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[STIMKit sharedInstance] updateLastTempUserToken:pwd];
                    [[STIMKit sharedInstance] loginWithUserName:userName WithPassWord:pwd];
                });
            }
        }
    }
}

- (void)showNetWorkUnableAlert {
    
    __weak id weakSelf = self;
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:[NSBundle stimDB_localizedStringForKey:@"common_prompt"] message:[NSBundle stimDB_localizedStringForKey:@"network_unavailable_tip"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:[NSBundle stimDB_localizedStringForKey:@"ok"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        [weakSelf stopLoginAnimation];
    }];
    UIAlertAction *helpAction = [UIAlertAction actionWithTitle:[NSBundle stimDB_localizedStringForKey:@""] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //        [weakSelf stopLoginAnimation];
        NSString *netHelperPath = [[NSBundle mainBundle] pathForResource:@"NetWorkSetting" ofType:@"html"];
        NSString *netHelperString = [NSString stringWithContentsOfFile:netHelperPath encoding:NSUTF8StringEncoding error:nil];
        [STIMFastEntrance openWebViewWithHtmlStr:netHelperString showNavBar:YES];
    }];
    [alertVc addAction:okAction];
    [alertVc addAction:helpAction];
    [weakSelf presentViewController:alertVc animated:YES completion:nil];
}

- (void)agreeBtnHandle:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)onSettingClick:(UIButton *)sender{
    STIMNavConfigManagerVC *navURLsSettingVc = [[STIMNavConfigManagerVC alloc] init];
    STIMNavController *navURLsSettingNav = [[STIMNavController alloc] initWithRootViewController:navURLsSettingVc];
    [self presentViewController:navURLsSettingNav animated:YES completion:nil];
}

- (void)gotoSelectCompany:(UITapGestureRecognizer *)tap {
    //    STIMSelectComponyViewController *companyVC = [[STIMSelectComponyViewController alloc] init];
    //    __weak __typeof(self) weakSelf = self;
    //    [companyVC setCompanyBlock:^(STIMPublicCompanyModel * _Nonnull companyModel) {
    //        weakSelf.companyModel = companyModel;
    //        NSString *companyName = companyModel.name;
    //        STIMVerboseLog(@"companyName : %@", companyName);
    //        if (companyName.length > 0) {
    ////            [self.companyTextField setText:companyName];
    //            [self.companyShowLabel setText:companyName];
    //        } else {
    //            NSString *companyDomain = companyModel.domain;
    ////            [self.companyTextField setText:companyDomain];
    //            [self.companyShowLabel setText:companyDomain];
    //        }
    //        [self updateLoginUI];
    //    }];
    //    [self.navigationController pushViewController:companyVC animated:YES];
    [self showSettingNavViewController];
}

#pragma mark - NSNotification

- (void)loginNotify:(NSNotification *)notify {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[STIMProgressHUD sharedInstance] closeHUD];
        if ([notify.object boolValue]) {
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            [[STIMKit sharedInstance] setUserObject:[infoDictionary objectForKey:@"CFBundleVersion"] forKey:@"QTalkApplicationLastVersion"];
            [STIMFastEntrance showMainVc];
        } else {
            __weak __typeof(self) weakSelf = self;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSBundle stimDB_localizedStringForKey:@"Reminder"] message:[NSBundle stimDB_localizedStringForKey:@"login_faild"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:[NSBundle stimDB_localizedStringForKey:@"Confirm"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    });
}

- (void)streamEnd:(NSNotification *)notify {
    [[STIMProgressHUD sharedInstance] closeHUD];
}

- (void)reloadNavDicts:(NSNotification *)notify {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupUI];
    });
}

#pragma mark 扫码配置导航

- (void)scanCodeSettingBtnClick:(UIButton *)btnClick{
    __weak typeof(self) weakSelf = self;
    STIMZBarViewController *vc=[[STIMZBarViewController alloc] initWithBlock:^(NSString *str, BOOL isScceed) {
        if (isScceed) {
            STIMVerboseLog(@"str : %@", str);
            NSString * navAddress;
            NSString * navUrl;
            
            NSURL * myurl = [NSURL URLWithString:str];
            NSString * query = [myurl query];
            NSArray * parameters = [query componentsSeparatedByString:@"&"];
            if (parameters && parameters.count > 0) {
                for (NSString * item in parameters) {
                    NSArray * value = [item componentsSeparatedByString:@"="];
                    NSString * key = [value objectAtIndex:0];
                    if ([key isEqualToString:@"c"]) {
                        navUrl = str;
                        navAddress = [item stringByReplacingOccurrencesOfString:@"c=" withString:@""];
                        [self onSaveWith:navAddress navUrl:navUrl];
                    }
                    else if([key isEqualToString:@"configurl"]){
                        NSString * configUrlStr = [[item stringByReplacingOccurrencesOfString:@"configurl=" withString:@""] stimDB_base64DecodedString];
                        NSURL *  configUrl = [NSURL URLWithString:configUrlStr];
                        NSString * configQuery = [configUrl query];
                        NSArray * parameters = [configQuery componentsSeparatedByString:@"&"];
                        if (parameters.count > 0 && parameters) {
                            for (NSString * tempItems in parameters) {
                                NSArray * tempValue = [tempItems componentsSeparatedByString:@"="];
                                NSString * tempKey = [tempValue objectAtIndex:0];
                                if ([tempKey isEqualToString:@"c"]) {
                                    navUrl = configUrl.absoluteString;
                                    navAddress = [tempItems stringByReplacingOccurrencesOfString:@"c=" withString:@""];
                                    [self onSaveWith:navAddress navUrl:navUrl];
                                }
                            }
                        }
                        else{
                            navUrl = configUrl.absoluteString;
                            navAddress =configUrl.absoluteString;
                            [self requestByURLSessionWithUrl:configUrl.absoluteString];
                        }
                    }
                }
            }
            else{
                navUrl = str;
                navAddress = str;
                [self requestByURLSessionWithUrl:str];
            }
            
            //            if ([str containsString:@"publicnav?c="]) {
            //                str = [[str componentsSeparatedByString:@"publicnav?c="] lastObject];
            //                navUrl = str;
            //                navAddress = str;
            //                [self onSaveWith:navAddress navUrl:navUrl];
            //            } else if ([str containsString:@"confignavigation?configurl="]) {
            //                NSString *base64NavUrl = [[str componentsSeparatedByString:@"confignavigation?configurl="] lastObject];
            //                str = [base64NavUrl stimDB_base64DecodedString];
            //                navUrl = str;
            //                navAddress = str;
            //                if ([str containsString:@"publicnav?c="]) {
            //                    navAddress = [[str componentsSeparatedByString:@"publicnav?c="] lastObject];
            //                }
            //                [self onSaveWith:navAddress navUrl:navUrl];
            //            } else if ([str containsString:@"startalk_nav"]){
            //                navUrl = str;
            //                [self requestByURLSessionWithUrl:str];
            //            }
            //            else{
            //                navUrl = str;
            //                navAddress = str;
            //                [self requestByURLSessionWithUrl:str];
            //            }
        }
    }];
    vc.isSettingNav = YES;
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)requestByURLSessionWithUrl:(NSString *)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *quest = [NSMutableURLRequest requestWithURL:url];
    quest.HTTPMethod = @"GET";
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:quest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                                      
                                      NSLog(@"statusCode: %ld", urlResponse.statusCode);
                                      NSDictionary * dataSerialDic = [[STIMJSONSerializer sharedInstance] deserializeObject:data error:nil];
                                      
                                      if (dataSerialDic && dataSerialDic.count > 0) {
                                          NSDictionary * baseAddress = [dataSerialDic objectForKey:@"baseaddess"];
                                          if (baseAddress && baseAddress.count >0) {
                                              NSString * domain = [baseAddress objectForKey:@"domain"];
                                              if (domain && domain.length >0) {
                                                  [self onSaveWith:domain navUrl:urlStr];
                                                  return ;
                                              }
                                          }
                                      }
                                      NSLog(@"%@", urlResponse.allHeaderFields);
                                      if (urlResponse.allHeaderFields.count >0 && urlResponse.allHeaderFields) {
                                          NSString * requestLocation = [urlResponse.allHeaderFields objectForKey:@"Location"];
                                          if (requestLocation.length >0 && requestLocation) {
                                              STIMVerboseLog(@"%@",requestLocation);
                                              NSString * navAddress;
                                              NSString * navUrl;
                                              NSURL * requestLocationUrl = [NSURL URLWithString:requestLocation];
                                              NSString * queryStr = [requestLocationUrl query];
                                              NSArray * parameters = [queryStr componentsSeparatedByString:@"&"];
                                              if (parameters.count>0 && parameters) {
                                                  for (NSString * item in parameters) {
                                                      NSArray * value = [item componentsSeparatedByString:@"="];
                                                      
                                                      NSString * key = [value objectAtIndex:0];
                                                      if ([key isEqualToString:@"c"]) {
                                                          navUrl = requestLocationUrl;
                                                          navAddress = [item stringByReplacingOccurrencesOfString:@"c=" withString:@""];
                                                          [self onSaveWith:navAddress navUrl:navUrl];
                                                      }
                                                      else if([key isEqualToString:@"configurl"]){
                                                          NSString * configUrlStr = [[item stringByReplacingOccurrencesOfString:@"configurl=" withString:@""] stimDB_base64DecodedString];
                                                          NSURL * configUrl = [NSURL URLWithString:configUrlStr];
                                                          NSString * configQuery = [configUrl query];
                                                          NSArray * parameters = [configQuery componentsSeparatedByString:@"&"];
                                                          if (parameters.count > 0 && parameters) {
                                                              for (NSString * tempItems in parameters) {
                                                                  NSArray * tempValue = [tempItems componentsSeparatedByString:@"="];
                                                                  NSString * tempKey = [tempValue objectAtIndex:0];
                                                                  if ([tempKey isEqualToString:@"c"]) {
                                                                      navUrl = configUrl.absoluteString;
                                                                      navAddress = [tempItems stringByReplacingOccurrencesOfString:@"c=" withString:@""];
                                                                      [self onSaveWith:navAddress navUrl:navUrl];
                                                                  }
                                                                  else{
                                                                      //                                                                      navUrl = configUrl.absoluteString;
                                                                      //                                                                      navAddress =configUrl.absoluteString;
                                                                      //                                                                      [self onSaveWith:navAddress navUrl:navUrl];
                                                                  }
                                                              }
                                                          }
                                                          else if([configUrlStr containsString:@"startalk_nav"]){
                                                              [self requestByURLSessionWithUrl:configUrlStr];
                                                              return;
                                                          }
                                                          else{
                                                              navUrl = configUrlStr;
                                                              [self onSaveWith:navAddress navUrl:navUrl];
                                                          }
                                                      }
                                                  }
                                              }
                                              else {
                                                  navUrl = requestLocation;
                                                  [self onSaveWith:navAddress navUrl:navUrl];
                                              }
                                          }
                                          else{
                                              
                                              [self onSaveWith:urlStr navUrl:urlStr];
                                          }
                                      }
                                  }];
    [task resume];
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler
{
    NSLog(@"statusCode: %ld", response.statusCode);
    
    NSDictionary *headers = response.allHeaderFields;
    NSString * requestLocation = [headers objectForKey:@"Location"];
    completionHandler(nil);
}


- (void)onSaveWith:(NSString *)navAddressText navUrl:(NSString *)navUrl{
    NSString *navHttpName = navAddressText;
    if (navAddressText.length > 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __block NSDictionary *userWillsaveNavDict = @{STIMNavNameKey:(navHttpName.length > 0) ? navHttpName : [[navUrl.lastPathComponent componentsSeparatedByString:@"="] lastObject], STIMNavUrlKey:navUrl};
        [[STIMKit sharedInstance] setUserObject:userWillsaveNavDict forKey:@"QC_UserWillSaveNavDict"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success = [[STIMKit sharedInstance] qimNav_updateNavigationConfigWithCheck:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if (success) {
                    [[STIMKit sharedInstance] setUserObject:userWillsaveNavDict forKey:@"QC_CurrentNavDict"];
                    [self setupUI];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:[NSBundle stimDB_localizedStringForKey:@"nav_no_available_Navigation"]
                                                                       delegate:nil
                                                              cancelButtonTitle:[NSBundle stimDB_localizedStringForKey:@"Confirm"]
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
            });
        });
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:[NSBundle stimDB_localizedStringForKey:@"nav_valid_promot"]
                                                           delegate:nil
                                                  cancelButtonTitle:[NSBundle stimDB_localizedStringForKey:@"Confirm"]
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self scanCodeSettingBtnClick:nil];
    }
    if (buttonIndex == 2) {
        STIMNavConfigManagerVC *navURLsSettingVc = [[STIMNavConfigManagerVC alloc] init];
        STIMNavController *navURLsSettingNav = [[STIMNavController alloc] initWithRootViewController:navURLsSettingVc];
        [self presentViewController:navURLsSettingNav animated:YES completion:nil];
    }
    else{
        
    }
}

- (void)registerNewUserBtnClicked:(UIButton *)btn{
    [STIMFastEntrance openWebViewForUrl:[[STIMKit sharedInstance] qimNav_webAppUrl] showNavBar:YES];
}

#pragma loginUnSettingNavViewDelegate

- (void)showScanViewController{
    [self scanCodeSettingBtnClick:nil];
}

-(void)showSettingNavViewController{
    STIMNavConfigManagerVC *navURLsSettingVc = [[STIMNavConfigManagerVC alloc] init];
    STIMNavController *navURLsSettingNav = [[STIMNavController alloc] initWithRootViewController:navURLsSettingVc];
    [self presentViewController:navURLsSettingNav animated:YES completion:nil];
}
@end