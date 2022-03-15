//
//  ExamPointSelectVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/12/28.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamPointSelectVC : BaseViewController

@property (strong, nonatomic) NSString *examTypeString;
@property (strong, nonatomic) NSString *examTypeId;

@property (strong, nonatomic) NSString *examModuleId;// 模块ID(每个板块可以添加很多模块)

@property (strong, nonatomic) NSMutableArray *mainTypeArray;// 主页传递过来的大的分类
@property (strong, nonatomic) NSMutableDictionary *mainSelectDict;// 主页传递过来的当前选择的

@end

NS_ASSUME_NONNULL_END
