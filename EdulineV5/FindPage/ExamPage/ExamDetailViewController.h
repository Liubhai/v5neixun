//
//  ExamDetailViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/2/5.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamDetailViewController : BaseViewController

@property (strong, nonatomic) NSString *examType;
@property (strong, nonatomic) NSString *examIds;
@property (strong, nonatomic) NSString *examTitle;//
@property (strong, nonatomic) NSString *examNewSelectCount;// 选择的 出题数量

@property (strong, nonatomic) NSString *examModuleId;// 模块ID(每个板块可以添加很多模块)

@property (strong, nonatomic) NSString *module_title;// 考试主页 板块儿名称

@property (strong, nonatomic) NSString *zhuanxiangCurrentTopicId;// 专项继续作答所需试题 id 

@end

NS_ASSUME_NONNULL_END
