//
//  MenuView.m
//  SDAutolayoutLRN
//
//  Created by iiik- on 2021/8/5.
//

#import "MenuView.h"
#import <SDAutoLayout.h>

@interface MenuView()

@property (nonatomic, strong)UIButton *likeButton;

@property (nonatomic, strong)UIButton *commentButton;

@property (nonatomic, strong)UIView *centerView;

@end

@implementation MenuView

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"赞 (1)"] forState:UIControlStateNormal];
        [_likeButton setTintColor:[UIColor whiteColor]];
        [_likeButton addTarget:self action:@selector(likeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    }
    return _likeButton;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"评论 (1)"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_commentButton setTintColor:[UIColor whiteColor]];
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    }
    return _commentButton;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc]init];
        _centerView.backgroundColor = [UIColor grayColor];
    }
    return _centerView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUI];
    }
    return  self;
}

/// MenuView的UI构建
- (void)setUI {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor colorWithRed:69/255.0 green:74/255.0 blue:76/255.0 alpha:1.0];
    
    NSArray *viewArray = @[self.likeButton, self.commentButton, self.centerView];
    [self sd_addSubviews:viewArray];
    
    _likeButton.sd_layout
    .leftSpaceToView(self, 5)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(80);
    
    _centerView.sd_layout
    .leftSpaceToView(_likeButton, 5)
    .topSpaceToView(self, 5)
    .bottomSpaceToView(self, 5)
    .widthIs(1);
    
    _commentButton.sd_layout
    .leftSpaceToView(_centerView, 5)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(80);
    
}

/// 根据View的isShow属性来判断该View是否需要展示
/// @param isShow 记录View是否需要展示的成员变量
- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        if (weakSelf.isShow) {
            //设置view的宽度自适应
            [weakSelf setupAutoWidthWithRightView:weakSelf.commentButton rightMargin:5];
        }else {
            //首先要先清楚view的宽度自适应
            [weakSelf clearAutoWidthSettings];
            weakSelf.sd_layout.widthIs(0);
        }
        [weakSelf updateLayoutWithCellContentView:weakSelf.superview];
    }];
   
}

/// 点击like按钮时调用的方法
- (void)likeButtonClick {
    self.likeBlk();
}

- (void)commentButtonClick {
    
}


@end
