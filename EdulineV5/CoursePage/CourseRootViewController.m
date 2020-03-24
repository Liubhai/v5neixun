//
//  CourseRootViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseRootViewController.h"
#import "CourseSearchListVC.h"

@interface CourseRootViewController ()

@end

@implementation CourseRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    _titleLabel.text = @"课程";
    _rightButton.hidden = NO;
    // Do any additional setup after loading the view.
}

- (void)rightButtonClick:(id)sender {
    CourseSearchListVC *vc = [[CourseSearchListVC alloc] init];
    vc.isSearch = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
