//
//  ExamResultViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/2/3.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamResultViewController : BaseViewController

@property (strong, nonatomic) NSString *record_id;// 考试结果列表里面的id
@property (strong, nonatomic) NSString *answer_status;//阅卷状态【0：提交答案；1：客观题已阅卷；2：主观题已阅卷，完成阅卷】(除了2 考试结果里面都不能点击)
@property (strong, nonatomic) NSString *examType;// 考试类型(3 公开考试 4 套卷练习)

@end

NS_ASSUME_NONNULL_END
