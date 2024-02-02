//
//  AddAddressViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/10/27.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddAddressViewController : BaseViewController

@property (strong, nonatomic) NSDictionary *currentAddressInfo;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *submitButton;

@end

NS_ASSUME_NONNULL_END
