//
//  ZhuangXiangListTreeTableVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "ZhuangXiangModelManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZhuangXiangListTreeTableVC : BaseViewController

@property (nonatomic, strong) ZhuangXiangModelManager *manager;

@property (strong, nonatomic) NSString *examModuleId;// 模块ID(每个板块可以添加很多模块)
@property (strong, nonatomic) NSString *examTypeString;
@property (strong, nonatomic) NSString *examTypeId;

@end

NS_ASSUME_NONNULL_END
