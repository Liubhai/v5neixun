//
//  QuestionChatViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/8/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionChatViewController : BaseViewController

@property (strong, nonatomic) NSString *questionId;
@property (strong, nonatomic) NSDictionary *questionInfo;

@end

NS_ASSUME_NONNULL_END
