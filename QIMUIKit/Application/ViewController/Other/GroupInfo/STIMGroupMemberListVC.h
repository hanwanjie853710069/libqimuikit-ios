//
//  STIMGroupMemberListVC.h
//  STChatIphone
//
//  Created by haibin.li on 15/11/19.
//
//

#import "STIMCommonUIFramework.h"

@interface STIMGroupMemberListVC : QTalkViewController

@property (nonatomic,copy) NSString                    * groupID;
@property (nonatomic,strong) NSMutableArray            * items;

@end
