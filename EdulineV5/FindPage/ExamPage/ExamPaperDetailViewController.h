//
//  ExamPaperDetailViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/15.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamPaperDetailViewController : BaseViewController

@property (strong, nonatomic) NSString *examType;
@property (strong, nonatomic) NSString *examIds;

@property (strong, nonatomic) NSString *courseId;

@property (strong, nonatomic) NSString *examModuleId;// 模块ID(每个板块可以添加很多模块)
@property (strong, nonatomic) NSString *rollup_id;// 套卷练习才会有这个
@property (strong, nonatomic) NSDictionary *paperInfo;// 试卷信息

@end

NS_ASSUME_NONNULL_END
