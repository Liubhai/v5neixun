//
//  StudyLatestCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "StudyLatestCell.h"
#import "V5_Constant.h"

@implementation StudyLatestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mainScrollView];
}

- (void)setLatestLearnInfo:(NSArray *)learnArray {
    
    [_mainScrollView removeAllSubviews];
    CGFloat maxHeight = 0;
    CGFloat maxWidth = 0;
    for (int i = 0; i<learnArray.count; i ++) {
        UIImageView *face = [[UIImageView alloc] initWithFrame:CGRectMake(15 + (125 + 8) * i, 10, 125, 70)];
        [face sd_setImageWithURL:EdulineUrlString([learnArray[i] objectForKey:@"course_cover"]) placeholderImage:DefaultImage];
        [_mainScrollView addSubview:face];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(face.right - 32, face.top + 8, 32, 18)];
        NSString *courseType = [NSString stringWithFormat:@"%@",[learnArray[i] objectForKey:@"course_type"]];
        if ([courseType isEqualToString:@"1"]) {
            icon.image = Image(@"dianbo");
        } else if ([courseType isEqualToString:@"2"]) {
            icon.image = Image(@"live");
        } else if ([courseType isEqualToString:@"3"]) {
            icon.image = Image(@"mianshou");
        } else if ([courseType isEqualToString:@"4"]) {
            icon.image = Image(@"album_icon");
        }
        [_mainScrollView addSubview:icon];
        
        UILabel *learnTime = [[UILabel alloc] initWithFrame:CGRectMake(face.left, face.bottom - 16, face.width, 16)];
        learnTime.layer.backgroundColor = [UIColor colorWithRed:48/255.0 green:49/255.0 blue:51/255.0 alpha:0.5].CGColor;
        learnTime.textColor = [UIColor whiteColor];
        learnTime.font = SYSTEMFONT(10);
        learnTime.text = [NSString stringWithFormat:@" 学习至%@",[EdulineV5_Tool timeChangeWithSecondsFormat:[[learnArray[i] objectForKey:@"current_time"] integerValue]]];
        [_mainScrollView addSubview:learnTime];
        
        UILabel *thmeLabel = [[UILabel alloc] initWithFrame:CGRectMake(face.left, face.bottom + 10, face.width, 20)];
        thmeLabel.font = SYSTEMFONT(13);
        thmeLabel.textColor = EdlineV5_Color.textFirstColor;
        thmeLabel.text = [NSString stringWithFormat:@"%@",[learnArray[i] objectForKey:@"course_title"]];
        thmeLabel.numberOfLines = 0;
        [thmeLabel sizeToFit];
        if (thmeLabel.height > 20) {
            [thmeLabel setHeight:38];
        }
        maxHeight = MAX(thmeLabel.bottom + 10, maxHeight);
        maxWidth = MAX(face.right, maxWidth);
        [_mainScrollView addSubview:thmeLabel];
    }
    _mainScrollView.contentSize = CGSizeMake(maxWidth + 10, 0);
    [_mainScrollView setHeight:maxHeight];
    
    [self setHeight:_mainScrollView.bottom];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end