//
//  SurePwViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"


@interface SurePwViewController : BaseViewController

@property (assign, nonatomic) BOOL registerOrForget;

@property (strong, nonatomic) NSString *phoneNum;

@property (strong, nonatomic) NSString *msgCode;

@property (strong, nonatomic) NSString *pkString;


@end

