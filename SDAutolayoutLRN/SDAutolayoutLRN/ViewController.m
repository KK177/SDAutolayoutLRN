//
//  ViewController.m
//  SDAutolayoutLRN
//
//  Created by iiik- on 2021/8/4.
//

#import "ViewController.h"
#import <SDAutoLayout.h>
#import "cellModel.h"
#import "YTableViewCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, MenuViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;


@end

@implementation ViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [[UIView alloc]init];
        [_tableView registerClass:[YTableViewCell class] forCellReuseIdentifier:@"YTabCellID"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDataSource];
    
    [self initTab];
}

- (void)initTab {
    self.tableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
}

- (void)initDataSource {
    _dataArr = [NSMutableArray array];
    NSArray *namesArray = @[@"111",
                            @"222",
                            @"333",
                            @"666",
                            @"888"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，https://github.com/gsdios/SDAutoLayout大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，https://github.com/gsdios/SDAutoLayout等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    for (int i=0; i < textArray.count; i++) {
        NSString *name = namesArray[i];
        NSString *contentText = textArray[i];
        cellModel *model = [[cellModel alloc]init];
        model.name = name;
        model.contentText = contentText;
        model.isOpen = NO;
        model.likeArray = [NSMutableArray array];
        model.commentArray = [NSMutableArray array];
        [_dataArr addObject:model];
    }
}

#pragma mark - TableViewDelegate方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTabCellID"];
    cellModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//去除点击的阴影效果
    __weak typeof(self) weakSelf = self;
    [cell setShowBlk:^(NSIndexPath *indexPath) {
        cellModel *model = weakSelf.dataArr[indexPath.row];
        model.isOpen = !model.isOpen;
        weakSelf.dataArr[indexPath.row] = model;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    cellModel *model = self.dataArr[indexPath.row];
    return  [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[YTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
}

#pragma mark - MenuViewDelegate
- (void)updateLikeModelWithIndexPath:(NSIndexPath *)indexPath WithUsername:(NSString *)username {
    cellModel *model = self.dataArr[indexPath.row];
    NSMutableArray *likeArray = model.likeArray;
    if ([likeArray containsObject:username]) {
        [likeArray removeObject:username];
    }else {
        [likeArray addObject:username];
    }
    model.likeArray = likeArray;
    self.dataArr[indexPath.row] = model;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

}
@end
