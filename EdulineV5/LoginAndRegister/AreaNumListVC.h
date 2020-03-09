//
//  AreaNumListVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/6.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^areaCodeBlock)(NSString *);

@interface AreaNumListVC : BaseViewController

@property (copy, nonatomic) areaCodeBlock areaNumCodeBlock;

@end

NS_ASSUME_NONNULL_END
