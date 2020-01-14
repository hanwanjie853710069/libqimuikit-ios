//
//  MyDressUpController.m
//  STChatIphone
//
//  Created by haibin.li on 15/7/17.
//
//

#import "STIMDressUpController.h"
#import "STIMDataController.h"
#import "STIMChatBGImageSelectController.h"
#import "STIMColorfulBubblesController.h"
#import "STIMChatBubbleFontChangeViewController.h"
#import "STIMFontSettingVC.h"
#import "STIMCommonFont.h"
#import "NSBundle+STIMLibrary.h"

@interface STIMDressUpController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView         * _mainTableView;
    NSMutableArray      * _dataSource;
}

@end

@implementation STIMDressUpController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [NSBundle stimDB_localizedStringForKey:@"explore_tab_personality_dress_up"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initMainTableViewDataSource];
    [self initMainTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFont:) name:kNotificationCurrentFontUpdate object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initMainTableViewDataSource
{
    _dataSource = [NSMutableArray arrayWithCapacity:1];
    
    [_dataSource addObject:@"cap"];
    
//    //QT表情
//    [_dataSource addObject:@"QTEmotion"];
    
    [_dataSource addObject:@"cap"];
    //多彩气泡
    [_dataSource addObject:@"colorfulBubbles"];
    
    [_dataSource addObject:@"cap"];
    //聊天字体
    [_dataSource addObject:@"chatFont"];
    
    [_dataSource addObject:@"cap"];
    //聊天背景
    [_dataSource addObject:@"chatBG"];
}

- (void)initMainTableView
{
    _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.separatorColor = [UIColor stimDB_colorWithHex:0xebecef alpha:1];
    _mainTableView.backgroundColor = [UIColor stimDB_colorWithHex:0xebecef alpha:1];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    self.view = _mainTableView;
}

- (void)updateFont:(NSNotification *)notify{
    dispatch_async(dispatch_get_main_queue(), ^{
       [_mainTableView reloadData];
    });
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = nil;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString * text = [_dataSource objectAtIndex:indexPath.row];
    
    //间隔cell
    if ([text isEqualToString:@"cap"]) {
        cell.textLabel.text = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if ([text isEqualToString:@"chatBG"]){
        cell.textLabel.text = [NSBundle stimDB_localizedStringForKey:@"personality_chat_bgimage"];
    }else if ([text isEqualToString:@"chatFont"]){
        cell.textLabel.text = [NSBundle stimDB_localizedStringForKey:@"personality_chat_bubblecolor"];
    }else if ([text isEqualToString:@"colorfulBubbles"]){
        cell.textLabel.text = [NSBundle stimDB_localizedStringForKey:@"custom_bubble_entrance"];
    }else if ([text isEqualToString:@"QTEmotion"]){
        cell.textLabel.text = @"QT表情";
    }
    cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:[[STIMCommonFont sharedInstance] currentFontSize]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * text = [_dataSource objectAtIndex:indexPath.row];
    
    //间隔cell
    if ([text isEqualToString:@"cap"]) {
        return 15;
    }else{
        return [[STIMCommonFont sharedInstance] currentFontSize] + 22;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * text = [_dataSource objectAtIndex:indexPath.row];
    //间隔cell
    if ([text isEqualToString:@"cap"]) {
        
    }else if([text isEqualToString:@"chatBG"]){
        NSMutableDictionary * chatBGImageDic = [[STIMKit sharedInstance] userObjectForKey:@"chatBGImageDic"];
        UIImage * image = nil;
        if (chatBGImageDic) {
            image = [UIImage imageWithContentsOfFile:[[STIMDataController getInstance] getSourcePath:@"chatBGImageFor_Common"]];
        }
        
        STIMChatBGImageSelectController * chatBGImageSelectVC = [[STIMChatBGImageSelectController alloc] initWithCurrentBGImage:image];
        chatBGImageSelectVC.userID = @"Common";
        [self.navigationController pushViewController:chatBGImageSelectVC animated:YES];
    }else if ([text isEqualToString:@"chatFont"]){
        STIMFontSettingVC * fontSettingVC = [[STIMFontSettingVC alloc] init];
        [self.navigationController pushViewController:fontSettingVC animated:YES];
    }else if ([text isEqualToString:@"colorfulBubbles"]){
        STIMChatBubbleFontChangeViewController * colorfulBubbleVC = [[STIMChatBubbleFontChangeViewController alloc] init];
        [self.navigationController pushViewController:colorfulBubbleVC animated:YES];
    }else if ([text isEqualToString:@"QTEmotion"]){
        
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *value = [_dataSource objectAtIndex:indexPath.row];
    if ([value isEqualToString:@"cap"]) {
        return NO;
    }else{
        return YES;
    }
}

@end
