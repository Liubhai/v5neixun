//
//  ExamNewMainCateListVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/10.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamNewMainCateListVC : BaseViewController

@property (strong, nonatomic) NSString *circleType;// 圈子类型
@property (strong, nonatomic) NSMutableArray *mainTypeArray;// 主页传递过来的大的分类
@property (strong, nonatomic) NSMutableDictionary *mainSelectDict;// 主页传递过来的当前选择的

@end

NS_ASSUME_NONNULL_END
