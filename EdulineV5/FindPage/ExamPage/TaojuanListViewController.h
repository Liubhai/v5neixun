//
//  TaojuanListViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/22.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^taojuanUserFaceVerify)(BOOL result);

@interface TaojuanListViewController : BaseViewController

@property (nonatomic, strong) taojuanUserFaceVerify taojuanUserFaceVerifyResult;

@property (strong, nonatomic) NSString *module_id;
@property (strong, nonatomic) NSString *module_title;

@property (strong, nonatomic) NSString *examModuleId;// 模块ID(每个板块可以添加很多模块)

@property (strong, nonatomic) NSMutableArray *mainTypeArray;// 主页传递过来的大的分类
@property (strong, nonatomic) NSMutableDictionary *mainSelectDict;// 主页传递过来的当前选择的

@end

NS_ASSUME_NONNULL_END
