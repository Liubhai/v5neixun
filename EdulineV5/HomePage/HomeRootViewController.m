//
//  HomeRootViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "HomeRootViewController.h"

@interface HomeRootViewController ()

@end

@implementation HomeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    _titleLabel.text = @"首页";
    [Net_API requestGETSuperAPIWithURLStr:@"https://t.v4.51eduline.com/service/config.indexConfig" WithAuthorization:@"aouth" paramDic:@{@"user":@"9"} finish:^(id  _Nonnull responseObject) {
        
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
