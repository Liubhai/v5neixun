//
//  SearchHistoryListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/2.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "SearchHistoryListCell.h"
#import "V5_Constant.h"

@implementation SearchHistoryListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 30, 43)];
    _themeLabel.font = SYSTEMFONT(14);
    _themeLabel.textColor = EdlineV5_Color.textSecendColor;
    [self.contentView addSubview:_themeLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 43, MainScreenWidth - 30, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_lineView];
}

- (void)setSearchHistoryListCellInfo:(NSDictionary *)info searchKeyWord:(NSString *)searchKeyWord {
    _themeLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
    NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:_themeLabel.text];
    if ([_themeLabel.text rangeOfString:searchKeyWord].location != NSNotFound) {
        [pass addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.themeColor} range:[_themeLabel.text rangeOfString:searchKeyWord]];
        _themeLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
