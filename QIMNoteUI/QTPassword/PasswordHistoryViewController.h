//
//  PasswordHistoryViewController.h
//  STChatIphone
//
//  Created by 李海彬 on 2017/7/20.
//
//

#import "STIMCommonUIFramework.h"
#if __has_include("STIMNoteManager.h")
@interface PasswordHistoryViewController : UIViewController

- (void)setHistoryModels:(NSArray *)models;

@property (nonatomic, copy) NSString *pk;

@end
#endif
