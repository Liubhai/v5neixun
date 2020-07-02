//
//  ZiXunDetailVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/28.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ZiXunDetailVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "CourseCommentCell.h"
#import "CommentBaseView.h"

@interface ZiXunDetailVC ()<UITableViewDelegate, UITableViewDataSource, CourseCommentCellDelegate, WKUIDelegate, WKNavigationDelegate, CommentBaseViewDelegate> {
    NSInteger page;
    CGFloat keyHeight;
}

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSDictionary *newsInfo;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSMutableArray *recommendNewArray;

@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) WKWebIntroview *contenView;

// 推荐资讯部分
@property (strong, nonatomic) UIScrollView *recommendZixunView;

// 底部评论
@property (strong, nonatomic) CommentBaseView *commentView;
@property (strong, nonatomic) UIView *commentBackView;


@end

@implementation ZiXunDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_rightButton setImage:Image(@"home_change_icon") forState:0];
    _rightButton.hidden = NO;
    // Do any additional setup after loading the view.
    
    _dataSource = [NSMutableArray new];
    _recommendNewArray = [NSMutableArray new];
    [self makeTableView];
    [self makeCommentToolView];
    [self getZiXunDetail];
}

- (void)makeHeaderView {
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.1)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    [_headerView removeAllSubviews];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    _topView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:_topView];
    
    UILabel *zixunTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 30, 20)];
    zixunTitle.font = SYSTEMFONT(14);
    zixunTitle.textColor = EdlineV5_Color.textFirstColor;
    zixunTitle.text = [NSString stringWithFormat:@"%@",_newsInfo[@"data"][@"detail"][@"title"]];
    zixunTitle.numberOfLines = 0;
    [zixunTitle sizeToFit];
    zixunTitle.frame = CGRectMake(15, 0, MainScreenWidth - 30, zixunTitle.height);
    [_topView addSubview:zixunTitle];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, zixunTitle.bottom, 200, 43)];
    timeLabel.font = SYSTEMFONT(13);
    timeLabel.textColor = EdlineV5_Color.textThirdColor;
    timeLabel.text = [EdulineV5_Tool formatterDate:[NSString stringWithFormat:@"%@",_newsInfo[@"data"][@"detail"][@"publish_time"]]];
    [_topView addSubview:timeLabel];
    
    UILabel *lookCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, zixunTitle.bottom, 200, 43)];
    lookCountLabel.font = SYSTEMFONT(13);
    lookCountLabel.textColor = EdlineV5_Color.textThirdColor;
    lookCountLabel.textAlignment = NSTextAlignmentRight;
    lookCountLabel.text = [NSString stringWithFormat:@"%@",_newsInfo[@"data"][@"detail"][@"read_count"]];
    CGFloat lookCountLabelWidth = [lookCountLabel.text sizeWithFont:lookCountLabel.font].width + 4;
    lookCountLabel.frame = CGRectMake(MainScreenWidth - 15 - lookCountLabelWidth, zixunTitle.bottom, lookCountLabelWidth, 43);
    [_topView addSubview:lookCountLabel];
    
    UIImageView *lookIcon = [[UIImageView alloc] initWithFrame:CGRectMake(lookCountLabel.left - 5.5 - 13, 0, 13, 8)];
    lookIcon.centerY = lookCountLabel.centerY;
    lookIcon.image = Image(@"news_view_icon");
    [_topView addSubview:lookIcon];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, timeLabel.bottom, MainScreenWidth, 1)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_topView addSubview:line];
    
    [_topView setHeight:line.bottom];
    
    _contenView = [[WKWebIntroview alloc] initWithFrame:CGRectMake(0, _topView.bottom, MainScreenWidth, 0.5)];
    _contenView.backgroundColor = [UIColor whiteColor];
    _contenView.scrollView.scrollEnabled = NO;
    _contenView.UIDelegate = self;
    _contenView.navigationDelegate = self;
    [_headerView addSubview:_contenView];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - CommenViewHeight - MACRO_UI_SAFEAREA)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstData)];
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreDataList)];
//    _tableView.mj_footer.hidden = YES;
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
//    [_tableView.mj_header beginRefreshing];
}

- (void)makeCommentToolView {
    _commentView = [[CommentBaseView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - CommenViewHeight - MACRO_UI_SAFEAREA, MainScreenWidth, CommenViewHeight + MACRO_UI_SAFEAREA)];
    _commentView.delegate = self;
    _commentView.hidden = NO;
    [self.view addSubview:_commentView];
    
    _commentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.001)];
    _commentBackView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentBackViewTap:)];
    [_commentBackView addGestureRecognizer:backViewTap];
    _commentBackView.hidden = YES;
    [self.view addSubview:_commentBackView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"CourseCommentReplayCell";
    CourseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CourseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse cellType:YES];
    }
    cell.delegate = self;
    [cell setCommentInfo:_dataSource[indexPath.row] showAllContent:YES];
    cell.scoreStar.hidden = YES;
    cell.commentCountButton.hidden = YES;
    cell.commentOrReplay = YES;
    cell.editButton.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"完成加载");
    
#pragma mark --- 解析图片标签
    NSString *botySise=[[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",100];
    [webView evaluateJavaScript:[NSString stringWithFormat:@"var script = document.createElement('script');"
                                 "script.type = 'text/javascript';"
                                 "script.text = \"function ResizeImages() { "
                                 "var myimg,oldwidth,newheight;"
                                 "var maxwidth=%f;" //缩放系数
                                 "for(i=0;i <document.images.length;i++){"
                                 "myimg = document.images[i];"
                                 "myimg.setAttribute('style','max-width:%fpx;height:auto')"
                                 "}"
                                 "}\";"
                                 "document.getElementsByTagName('head')[0].appendChild(script);",MainScreenWidth,MainScreenWidth] completionHandler:nil];
    [webView evaluateJavaScript:@"document.body.style.backgroundColor='#f9f9f9';" completionHandler:nil];//设置背景颜色
    [webView evaluateJavaScript:@"document.body.style.zoom=1.0" completionHandler:nil];
    [webView evaluateJavaScript:@"document.body.style.backgroundColor='#f9f9f9';" completionHandler:nil];
    [webView evaluateJavaScript:@"ResizeImages();" completionHandler:nil];
    [webView evaluateJavaScript:botySise completionHandler:nil];
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id _Nullable heigh, NSError * _Nullable error) {
        NSString *height = [NSString stringWithFormat:@"%@", heigh];
        [self.contenView setHeight:[height floatValue] + 20];
        [self.headerView setHeight:self.contenView.bottom];
        self.tableView.tableHeaderView = self.headerView;
        [self.tableView reloadData];
    }];
}

//加载失败调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"加载失败");
}

- (void)getZiXunDetail {
    if (SWNOTEmptyStr(_zixunId)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path zixunDetailNet:_zixunId] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _newsInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                    NSString *allStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"detail"][@"content"]];
                    [self makeHeaderView];
                    [_contenView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:allStr]]];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)textViewValueDidChanged:(NSNotification *)notice {
    UITextView *textView = (UITextView *)notice.object;
    if (textView.text.length<=0) {
        _commentView.placeHoderLab.hidden = NO;
    } else {
        _commentView.placeHoderLab.hidden = YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [_commentView setTop:MainScreenHeight - MACRO_UI_SAFEAREA - CommenViewHeight];
    [_commentView setHeight:CommenViewHeight + MACRO_UI_SAFEAREA];
    [_commentView.inputTextView setHeight:CommentInputHeight];
    [_commentBackView setHeight:0.001];
    _commentBackView.hidden = YES;
    if (_commentView.inputTextView.text.length<=0) {
        _commentView.placeHoderLab.hidden = NO;
    } else {
        _commentView.placeHoderLab.hidden = YES;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSValue * endValue   = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyHeight = [endValue CGRectValue].size.height;
    [UIView animateWithDuration:0.1 animations:^{
        [self.commentView setHeight:CommentViewMaxHeight];
        [self.commentView.inputTextView setHeight:CommentViewMaxHeight - (CommenViewHeight - CommentInputHeight)];
        [self.commentView setTop:MainScreenHeight - MACRO_UI_SAFEAREA - CommentViewMaxHeight - self->keyHeight];
        [self.commentBackView setHeight:MainScreenHeight - MACRO_UI_SAFEAREA - CommentViewMaxHeight - self->keyHeight];
    } completion:^(BOOL finished) {
        self.commentBackView.hidden = NO;
    }];
}

- (void)commentBackViewTap:(UIGestureRecognizer *)tap {
    [_commentView.inputTextView resignFirstResponder];
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
