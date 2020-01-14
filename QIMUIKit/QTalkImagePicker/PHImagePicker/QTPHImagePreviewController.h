//
//  QTImagePreviewController.h
//  STChatIphone
//
//  Created by admin on 15/8/19.
//
//

//#import "STIMCommonUIFramework.h"
#import "STIMCommonUIFramework.h"

@class QTPHImagePickerController;
@class QTPHGridViewController;
@interface QTPHImagePreviewController : QTalkViewController
@property (nonatomic,assign) QTPHImagePickerController * picker;
@property (nonatomic,assign) QTPHGridViewController * gridVC;
@property (nonatomic, strong) NSArray *photoArray;
@end
