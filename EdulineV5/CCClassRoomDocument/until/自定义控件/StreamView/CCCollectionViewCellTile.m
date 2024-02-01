//
//  CCCollectionViewCellTile.m
//  CCClassRoom
//
//  Created by cc on 17/4/20.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCCollectionViewCellTile.h"
#import "CCManagerTool.h"
#import "CCUser+CCSound.h"

@interface CCCollectionViewCellTile()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) CCStreamView *info;
@property (strong, nonatomic) UIImageView *audioImageView;
@property (strong, nonatomic) UIImageView *drawImageView;
@property (strong, nonatomic) UIImageView *lockImageView;
@property (strong, nonatomic) UIImageView *assistantView;
@property (strong, nonatomic) UIView *bottomView;
@property(nonatomic, strong)UIImageView *soundImg;
@property(nonatomic, strong)CCUser *user;
@end

#define NamelabelDelLeft 10.f
#define NamelabelDelBottom 10.f
#define PhoneBtnDelRight 10.f
#define PhoneBtnDelMicBtn 10.f

@implementation CCCollectionViewCellTile
- (void)loadwith:(CCStreamView *)info showAtTop:(BOOL)top
{
    if (self.info && self.info.superview == self)
    {
        [self.info removeFromSuperview];
        self.info = nil;
    }
    self.info = info;
    if (!self.nameLabel)
    {
        self.nameLabel = [UILabel new];
        self.nameLabel.font = [UIFont systemFontOfSize:FontSizeClass_12];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.nameLabel];
    }
    
    if (!self.soundImg) {
        self.soundImg = [[UIImageView alloc] init];
        [self.contentView addSubview:self.soundImg];
    }
    if (!self.audioImageView)
    {
        self.audioImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kaimai"]];
        [self addSubview:self.audioImageView];
    }
    if (!self.drawImageView)
    {
        self.drawImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pencil-2"]];
        [self addSubview:self.drawImageView];
    }
    if (!self.lockImageView)
    {
        self.lockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock2"]];
        [self addSubview:self.lockImageView];
    }
    if (!self.assistantView)
    {
        self.assistantView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teacher2"]];
        [self addSubview:self.assistantView];
    }
    if (!self.bottomView)
    {
        self.bottomView = [UIView new];
        self.bottomView.backgroundColor = CCRGBAColor(0, 0, 0, 0.5);
        [self addSubview:self.bottomView];
    }
    [self addSubview:info];
    [self sendSubviewToBack:info];
    [self bringSubviewToFront:self.lockImageView];
    [self bringSubviewToFront:self.audioImageView];
    [self bringSubviewToFront:self.drawImageView];
    [self bringSubviewToFront:self.assistantView];
    [self bringSubviewToFront:self.soundImg];
    self.audioImageView.hidden = NO;
    self.drawImageView.hidden = NO;

//    CCStreamerBasic *client = [CCStreamerBasic sharedStreamer];
//    CCUser *user3 = [client getUserInfoWithStreamID:info.stream.streamID];
//    self.nameLabel.text = user3.user_name;
    for (CCUser *user in [CCStreamerBasic sharedStreamer].getRoomInfo.room_userList)
    {
        if ([user.user_id isEqualToString:info.stream.userID])
        {
            self.user = user;
            self.nameLabel.text = user.user_name;
            self.drawImageView.hidden = !user.user_drawState;
            if (user.user_audioState)
            {
                ///音频
                ///拿userid换数据
//                int leave = [[CCManagerTool shared] getSoundInfoLeveWith:user.user_id uid:user.user_uid];
                if (user.soundccLeave) {
                    NSString *imgName = [NSString stringWithFormat:HDClassLocalizeString(@"声音%d") ,user.soundccLeave];
                    self.soundImg.image = [UIImage imageNamed:imgName];
                    self.soundImg.hidden = NO;
                }else {
                    ///0不显示
                    self.soundImg.hidden = YES;
                }
                self.audioImageView.image = [UIImage imageNamed:@"kaimai"];
            }
            else
            {
                self.soundImg.hidden = YES;
                self.audioImageView.image = [UIImage imageNamed:@"guanmai"];
            }
            self.lockImageView.hidden = !user.rotateLocked;
            self.assistantView.hidden = !user.user_AssistantState;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [info mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(weakSelf).offset(0.f);
    }];
    
    if (top)
    {
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf).offset(NamelabelDelLeft);
            make.top.mas_equalTo(weakSelf).offset(75);
            make.width.mas_equalTo(30.f);
        }];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.soundImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf).offset(NamelabelDelLeft);
            make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(NamelabelDelBottom);
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(8.5);
        }];
        
        [self.audioImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.nameLabel).offset(0.f);
            make.left.mas_equalTo(weakSelf.nameLabel.mas_right).offset(5.f);
        }];
        UIView *leftView;
        [self.drawImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.audioImageView).offset(0.f);
            make.left.mas_equalTo(weakSelf.audioImageView.mas_right).offset(0.f);
        }];
        if (self.drawImageView.hidden)
        {
            [self.lockImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(weakSelf.audioImageView).offset(0.f);
                make.left.mas_equalTo(weakSelf.audioImageView.mas_right).offset(0.f);
            }];
            leftView = self.audioImageView;
        }
        else
        {
            [self.lockImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(weakSelf.audioImageView).offset(0.f);
                make.left.mas_equalTo(weakSelf.drawImageView.mas_right).offset(0.f);
            }];
            leftView = self.drawImageView;
        }
        if (!self.lockImageView.hidden)
        {
            leftView = self.lockImageView;
        }
        [self.assistantView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.audioImageView).offset(0.f);
            make.left.mas_equalTo(leftView.mas_right).offset(0.f);
        }];
        self.bottomView.hidden = YES;
    }
    else
    {
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf).offset(10.f);
            make.width.mas_equalTo(weakSelf.frame.size.width - 40);
            make.bottom.mas_equalTo(weakSelf).offset(-4.f);
        }];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.audioImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.nameLabel).offset(0.f);
            make.right.mas_equalTo(weakSelf).offset(-NamelabelDelLeft);
        }];
        
        [self.drawImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.audioImageView).offset(0.f);
            make.right.mas_equalTo(weakSelf.audioImageView.mas_left).offset(0.f);
        }];
        UIView *rightView;
        if (self.drawImageView.hidden)
        {
            [self.lockImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(weakSelf.audioImageView).offset(0.f);
                make.right.mas_equalTo(weakSelf.audioImageView.mas_left).offset(0.f);
            }];
            rightView = self.audioImageView;
        }
        else
        {
            [self.lockImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(weakSelf.audioImageView).offset(0.f);
                make.right.mas_equalTo(weakSelf.drawImageView.mas_left).offset(0.f);
            }];
            rightView = self.drawImageView;
        }
        if (!self.lockImageView.hidden)
        {
            rightView = self.lockImageView;
        }
        [self.assistantView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.audioImageView).offset(0.f);
            make.right.mas_equalTo(rightView.mas_left).offset(0.f);
        }];
        self.bottomView.hidden = NO;
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(info).offset(0.f);
            make.top.mas_equalTo(weakSelf.nameLabel.mas_top).offset(-5.f);
        }];
        
        [self.soundImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf).offset(NamelabelDelLeft);
            make.bottom.mas_equalTo(weakSelf.bottomView.mas_top).offset(-2);
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(8.5);
        }];
    }
    
    if ([info.stream.userID isEqualToString:ShareScreenViewUserID])
    {
        self.audioImageView.hidden = YES;
        self.drawImageView.hidden = YES;
    }
    if (info.stream.role == CCRole_Teacher)
    {
        self.drawImageView.hidden = YES;
        self.assistantView.hidden = YES;
    }
    info.backgroundColor = StreamColor;
    CCClassType classType = [CCStreamerBasic sharedStreamer].getRoomInfo.room_class_type;
    if (classType == CCClassType_Auto || classType == CCClassType_Named || [info.stream.userID isEqualToString:ShareScreenViewUserID])
    {
        self.lockImageView.hidden = YES;
    }
    if ([info.stream.userID isEqualToString:ShareScreenViewUserID])
    {
        self.assistantView.hidden = YES;
    }
    
//    NSString *haveAudio = [info.stream.attributes objectForKey:@"audio"];
//    if (![haveAudio isEqualToString:@"true"])
//    {
//        self.audioImageView.image = [UIImage imageNamed:@"nomai"];
//    }
}

- (void)updateSound {
    if (self.user.soundccLeave) {
        NSString *imgName = [NSString stringWithFormat:HDClassLocalizeString(@"声音%d") ,self.user.soundccLeave];
        self.soundImg.image = [UIImage imageNamed:imgName];
        self.soundImg.hidden = NO;
    }else {
        ///0不显示
        self.soundImg.hidden = YES;
    }
}

- (void)dealloc
{
//    [self.info removeFromSuperview];
//    self.info = nil;
}
@end
