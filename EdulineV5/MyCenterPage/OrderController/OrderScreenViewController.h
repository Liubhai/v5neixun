//
//  OrderScreenViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/17.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol OrderScreenViewControllerDelegate <NSObject>

- (void)sureChooseOrderScreen:(NSDictionary *)orderScreenInfo;

@end

@interface OrderScreenViewController : BaseViewController

@property (weak, nonatomic) id<OrderScreenViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *screenTitle;// 当前选中的类型
@property (strong, nonatomic) NSString *screenType;// 当前选中的类型

@end

NS_ASSUME_NONNULL_END
