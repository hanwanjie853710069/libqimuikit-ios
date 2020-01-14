//
//  PasswordBoxListVc.m
//  STChatIphone
//
//  Created by 李海彬 on 2017/7/17.
//
//
#if __has_include("STIMNoteManager.h")
#import "PasswordBoxListVc.h"
#import "NewPasswordBoxVc.h"
#import "STIMNoteManager.h"
#import "STIMNoteModel.h"
#import "PasswordBoxCell.h"
#import "PwdBoxSecuritySettingVc.h"
#import "PasswordListViewController.h"
#import "STIMNoteUICommonFramework.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface PasswordBoxListVc () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation PasswordBoxListVc

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [UIView new];
    }
    return _mainTableView;
}

- (void)loadPasswordBoxs {
    self.dataSource = [NSMutableArray arrayWithCapacity:5];
    NSArray *array = [[STIMNoteManager sharedInstance] getMainItemWithType:STIMNoteTypePassword WithExceptState:STIMNoteStateBasket];
    [self.dataSource addObjectsFromArray:array];
    [self.mainTableView reloadData];
}

- (void)getRemotePasswordBoxs {
    NSInteger version = [[STIMNoteManager sharedInstance] getQTNoteMainItemMaxTimeWithType:STIMNoteTypePassword];
    [[STIMNoteManager sharedInstance] getCloudRemoteMainWithVersion:version WithType:STIMNoteTypePassword];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getRemotePasswordBoxs];
    [self loadPasswordBoxs];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger securityMinute = [[[STIMKit sharedInstance] userObjectForKey:@"securityMinute"] integerValue];
    if (securityMinute < 1) {
        [[STIMKit sharedInstance] setUserObject:@(15 * 60) forKey:@"securityMinute"];
    }
    [self setupUI];
    [self registerNotification];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPasswordBoxs) name:QTNoteManagerGetCloudMainSuccessNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI {
    self.title = [NSBundle stimDB_localizedStringForKey:@"explore_title_passwords"];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view = self.mainTableView;
    [self setupNav];
}

- (void)setupNav {
    
    UIButton *createPwdBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
    [createPwdBoxButton setImage:[UIImage stimDB_imageNamedFromSTIMUIKitBundle:@"new_somthing_icon"] forState:UIControlStateNormal];
    [createPwdBoxButton addTarget:self action:@selector(addPasswordBox) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *newPwdBoxItem = [[UIBarButtonItem alloc] initWithCustomView:createPwdBoxButton];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage stimDB_imageNamedFromSTIMUIKitBundle:@"PasswordBox_setting-normal"] style:UIBarButtonItemStyleDone target:self action:@selector(PasswordBoxSecuritySetting)];
    [self.navigationItem setRightBarButtonItems:@[settingItem ,newPwdBoxItem]];
}

- (void)addPasswordBox {
    NewPasswordBoxVc *newPwdBoxVc = [[NewPasswordBoxVc alloc] init];
    [self.navigationController pushViewController:newPwdBoxVc animated:YES];
    [self.mainTableView reloadData];
}

- (void)PasswordBoxSecuritySetting {
    PwdBoxSecuritySettingVc *securitySettingVc = [[PwdBoxSecuritySettingVc alloc] init];
    [self.navigationController pushViewController:securitySettingVc animated:YES];
}

#pragma mark - UITableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    STIMNoteModel *model = [self.dataSource objectAtIndex:indexPath.row];
    
    PasswordBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PasswordBoxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setSTIMNoteModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //请求数据源提交的插入或删除指定行接收者。
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataSource];
        __block NSInteger row = indexPath.row;
        if ((row < [tempArray count]) && (row >= 0)) {
            STIMNoteModel *model = [tempArray objectAtIndex:row];
            model.q_state = STIMNoteStateBasket;
            [[STIMNoteManager sharedInstance] updateQTNoteMainItemStateWithModel:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mainTableView beginUpdates];
                [tempArray removeObjectAtIndex:row];
                _dataSource = [NSMutableArray arrayWithArray:tempArray];
                [_mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [_mainTableView endUpdates];
            });
        }
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NSBundle stimDB_localizedStringForKey:@"password_box_moveToBasket"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    STIMNoteModel *model = [self.dataSource objectAtIndex:indexPath.row];    
    PasswordListViewController *plistVc = [[PasswordListViewController alloc] init];
    [plistVc setSTIMNoteModel:model];
    [self.navigationController pushViewController:plistVc animated:YES];
}

@end
#endif
