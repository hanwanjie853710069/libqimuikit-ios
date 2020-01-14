//
//  STIMATGroupMemberTextAttachment.m
//  STChatIphone
//
//  Created by 李海彬 on 2018/4/3.
//

#import "STIMATGroupMemberTextAttachment.h"

@implementation STIMATGroupMemberTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    CGSize size = [self.groupMemberName stimDB_sizeWithFontCompatible:[UIFont systemFontOfSize:17]];
    return CGRectMake(0, -2, size.width, 20);
}

- (NSString *)getSendText{
    if (self.groupMemberName) {
        
        return self.groupMemberName;
    }
    return nil;
}

@end
