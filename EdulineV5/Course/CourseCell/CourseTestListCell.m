//
//  CourseTestListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/9/26.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "CourseTestListCell.h"
#import "V5_Constant.h"

@implementation CourseTestListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 32, 16)];
    _iconView.image = Image(@"contents_icon_test");
    _iconView.centerY = 44 / 2.0;
    [self.contentView addSubview:_iconView];
    
    _testTitle = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + 7.5, 0, MainScreenWidth - _iconView.right - 7.5 - 15, 44)];
    _testTitle.font = SYSTEMFONT(14);
    _testTitle.textColor = EdlineV5_Color.textSecendColor;
    [self.contentView addSubview:_testTitle];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 43, MainScreenWidth - 15, 1)];
    _lineView.backgroundColor = EdlineV5_Color.backColor;
    [self.contentView addSubview:_lineView];
}

- (void)setCourseTestCellInfoData:(NSDictionary *)dict course_can_exam:(BOOL)courseCanExam {
    _testTitle.text = [NSString stringWithFormat:@"%@",dict[@"paper_title"]];
    NSString *can_exam = [NSString stringWithFormat:@"%@",dict[@"can_exam"]];
    if ([can_exam integerValue] && courseCanExam) {
        _testTitle.textColor = EdlineV5_Color.textSecendColor;
    } else {
        _testTitle.textColor = EdlineV5_Color.textThirdColor;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
