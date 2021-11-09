//
//  CCStudentActionManager.h
//  CCClassRoom
//
//  Created by cc on 17/4/28.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCMemberTableViewController.h"
/*专门处理学生的actionsheet操作*/
typedef void(^CCStudentActionManagerBlock)(BOOL result, id info);

@interface CCStudentActionManager : NSObject

@property (strong, nonatomic) CCDocVideoView *ccVideoView;

- (void)showWithModel:(CCMemberModel *)model inView:(UIView *)view dismiss:(CCStudentActionManagerBlock)completion;
- (void)showWithUserID:(NSString *)userID inView:(UIView *)view dismiss:(CCStudentActionManagerBlock)completion;

/*处理老师的actionsheet操作*/
- (void)studentCallWithUserID:(NSString *)userID inView:(UIView *)view dismiss:(CCStudentActionManagerBlock)completion;
- (void)studentCallWithModel:(CCMemberModel *)model inView:(UIView *)view dismiss:(CCStudentActionManagerBlock)completion;

/* 处理助教的actionsheet操作 */
- (void)assistant:(BOOL)published call:(NSString *)userID inView:(UIView *)view dismiss:(CCStudentActionManagerBlock)completion;
- (void)assistant:(BOOL)published callModel:(CCMemberModel *)model inView:(UIView *)view dismiss:(CCStudentActionManagerBlock)completion;
- (void)assistantCallModel:(CCMemberModel *)model inView:(UIView *)view dismiss:(CCStudentActionManagerBlock)completion;

@end
