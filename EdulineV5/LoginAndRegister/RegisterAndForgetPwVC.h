//
//  RegisterAndForgetPwVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"


@interface RegisterAndForgetPwVC : BaseViewController

@property (assign, nonatomic) BOOL registerOrForget;
@property (assign, nonatomic) BOOL editPw;

@property (assign, nonatomic) BOOL changePhone;// 是不是更换手机号
@property (assign, nonatomic) BOOL hasPhone;// 此账号是否是有手机号 没有就直接验证新手机号  有就要先验证旧手机号 再验证新手机号 再保存编辑个人信息
@property (assign, nonatomic) BOOL oldPhone;// (有手机号的时候才会考虑这个属性的值 yes 是 旧手机号验证页面 no 是 新手机页面验证)
@property (strong, nonatomic) NSString *topTitle;

@end

