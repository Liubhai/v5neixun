//
//  ExamPaperErrorTestAgainVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/4/26.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamPaperErrorTestAgainVC : BaseViewController

@property (strong, nonatomic) NSString *examType;
@property (strong, nonatomic) NSString *examIds;
/** 是否是顺序重练 yes  是 no 单独练题 */
@property (assign, nonatomic) BOOL isOrderTest;
@property (strong, nonatomic) NSDictionary *paperInfo;// 试卷信息

@end

NS_ASSUME_NONNULL_END
