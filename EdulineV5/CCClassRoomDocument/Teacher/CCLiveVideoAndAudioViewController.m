//
//  CCLiveVideoAndAudioViewController.m
//  CCClassRoom
//
//  Created by cc on 17/1/20.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCLiveVideoAndAudioViewController.h"

@interface CCLiveVideoAndAudioViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *oneImage;
@property (weak, nonatomic) IBOutlet UIImageView *twoImage;
@end

@implementation CCLiveVideoAndAudioViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = HDClassLocalizeString(@"连麦音视频") ;
    self.tableView.delegate = self;
    
    UIView *line = [UIView new];
    [line setBackgroundColor:CCRGBColor(229,229,229)];
    line.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 0.5f);
    self.tableView.tableFooterView = line;
    self.tableView.separatorColor = CCRGBColor(229, 229, 229);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CCVideoMode micType = [[CCStreamerBasic sharedStreamer] getRoomInfo].room_video_mode;
    if (micType == CCVideoMode_Audio)
    {
        self.oneImage.hidden = YES;
        self.twoImage.hidden = NO;
    }
    else
    {
        self.oneImage.hidden = NO;
        self.twoImage.hidden = YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCVideoMode type;
    if (indexPath.row == 0)
    {
        type = CCVideoMode_AudioAndVideo;
    }
    else
    {
        type = CCVideoMode_Audio;
    }
    
    /*
     1、改变连麦音视频权限并发送通知，如果是音频连麦，就调用关闭摄像头，如果是视频连麦，打开摄像头。
     2、改正：连麦音视频是学生端只推音频，并不推送视频。
     */
    [[CCBarleyManager sharedBarley] changeRoomVideoMode:type completion:^(BOOL result, NSError *error, id info) {
        NSLog(@"%s__result:%d__error:%@", __func__, result, error);
        if (result) {
        }
    }];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
