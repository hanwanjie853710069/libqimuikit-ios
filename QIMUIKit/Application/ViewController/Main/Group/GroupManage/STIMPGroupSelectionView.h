//
//  STIMPGroupSelectionView.h
//  STChatIphone
//
//  Created by wangshihai on 14/12/16.
//  Copyright (c) 2014年 ping.xue. All rights reserved.
//

#import "STIMCommonUIFramework.h"

@protocol SelectionResultDelegate <NSObject>
@optional
- (void)selectionBuddiesArrays:(NSArray *)memberArrays;
@end

@interface STIMPGroupSelectionView : QTalkViewController

@property(nonatomic, strong) NSString * groupID;

@property(nonatomic, strong) NSString * groupName;

@property (assign) id <SelectionResultDelegate> delegate;

@property (nonatomic, assign) BOOL existGroup;

- (void) setAlreadyExistsMember:(NSArray *) members withGroupId:(NSString *) groupId;

@end
