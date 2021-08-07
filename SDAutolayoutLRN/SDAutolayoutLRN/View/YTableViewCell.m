//
//  YTableViewCell.m
//  SDAutolayoutLRN
//
//  Created by iiik- on 2021/8/4.
//

#import "YTableViewCell.h"
#import <SDAutoLayout.h>
#import "cellModel.h"
#import "MenuView.h"
#import "CommentModel.h"

#define ShowMoreTitleColor [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]

@interface YTableViewCell()<UITextViewDelegate>

@property (nonatomic, strong) UIView *iconView;

@property (nonatomic, strong) UILabel *contentTextLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *showMoreButton;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *showMenuButton;

@property (nonatomic, strong) MenuView *menuView;

@property (nonatomic, strong) UITextView *likeTextView;

@property (nonatomic, strong) NSArray *likeArray;

@property (nonatomic, strong) id lastView;

@end

CGFloat maxShowTextHeight = 0;

@implementation YTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return  self;
}

- (void)setUI {
    _iconView = [[UIView alloc]init];
    _iconView.backgroundColor = [UIColor blueColor];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont systemFontOfSize:15.0];
    
    _contentTextLabel = [[UILabel alloc]init];
    _contentTextLabel.font = [UIFont systemFontOfSize:16.0];
    if (maxShowTextHeight == 0) {
        maxShowTextHeight = _contentTextLabel.font.lineHeight * 3;
    }
    
    _showMoreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_showMoreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_showMoreButton setTitleColor:ShowMoreTitleColor forState:UIControlStateNormal];
    _showMoreButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_showMoreButton addTarget:self action:@selector(showMoreText) forControlEvents:UIControlEventTouchUpInside];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.font = [UIFont systemFontOfSize:14.0];
    _timeLabel.text = @"1分钟前";
    _timeLabel.textColor = [UIColor grayColor];
    
    _showMenuButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_showMenuButton setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [_showMenuButton addTarget:self action:@selector(shouMenu) forControlEvents:UIControlEventTouchUpInside];
    
    _menuView = [[MenuView alloc]init];
    
    _likeTextView = [[UITextView alloc]init];
    _likeTextView.editable = NO;
    _likeTextView.scrollEnabled = NO;
    _likeTextView.font = [UIFont systemFontOfSize:13.0];
    _likeTextView.textContainer.lineFragmentPadding = 0;
    _likeTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _likeTextView.delegate = self;
    
    NSArray *viewArray = @[_iconView, _nameLabel, _contentTextLabel, _showMoreButton, _timeLabel, _showMenuButton, _menuView, _likeTextView];
    [self.contentView sd_addSubviews:viewArray];
    
    _iconView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    .widthIs(40)
    .heightIs(40);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconView, 10)
    .topEqualToView(_iconView)
    .heightIs(20)
    .maxWidthIs(200);
    
    _contentTextLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(_iconView, 5)
    .autoHeightRatio(0);
    
    _showMoreButton.sd_layout
    .leftEqualToView(_contentTextLabel)
    .topSpaceToView(_contentTextLabel, 0)
    .widthIs(30)
    .heightIs(18);
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentTextLabel)
    .heightIs(20)
    .widthIs(80);
    
    _showMenuButton.sd_layout
    .rightEqualToView(_contentTextLabel)
    .topEqualToView(_timeLabel)
    .widthIs(30)
    .heightIs(30);
    
    _menuView.sd_layout
    .rightSpaceToView(_showMenuButton, 0)
    .centerYEqualToView(_showMenuButton)
    .widthIs(0)
    .heightIs(36);
    
    _likeTextView.sd_layout
    .leftEqualToView(_contentTextLabel)
    .rightEqualToView(_contentTextLabel)
    .topSpaceToView(_showMenuButton, 5)
    .heightIs(0);
}

- (void)setModel:(cellModel *)model {
    _nameLabel.text = model.name;
    _contentTextLabel.text = model.contentText;
    _likeArray = model.likeArray;
    
    //更新MenuView的Block设置
    [self setMenuBlkWithModel:model];
    
    //判断是否需要显示全文
    [self judgeIsShowTotalTextWithModel:model];
    
    //判断是否需要展开点赞栏
    [self judgeIsShowLikeWithModel:model];
    
    
    [self setupAutoHeightWithBottomView:_lastView bottomMargin:15];
}

/// 根据cell的模型数据去更新MenuView的Block设置
/// @param model cell的模型数据
- (void)setMenuBlkWithModel:(cellModel *)model {
    //设置点击like按钮时调用的Block，再利用delegate调用主控制器的方法去更新数据源
    __weak typeof(self) weakSelf = self;
    [_menuView setLikeBlk:^{
        if ([weakSelf.delegate respondsToSelector:@selector(updateLikeModelWithIndexPath:WithUsername:)]) {
            [weakSelf.delegate updateLikeModelWithIndexPath:weakSelf.indexPath WithUsername:model.name];
        }
        //MenuView取消显示
        [weakSelf shouMenu];
    }];
}

/// 点击全文/收起按钮调用的方法
- (void)showMoreText {
    //刷新tableViewcell
    self.showBlk(_indexPath);
}

/// 点击右下角的按钮展开赞和评论的选项
- (void)shouMenu {
    _menuView.isShow = !_menuView.isShow;
}

/// 判断是否是要展开全文
/// @param model cell的模型数据
- (void)judgeIsShowTotalTextWithModel:(cellModel *)model {
    if (model.shouldShowTotal) {
        _showMoreButton.hidden = YES;
        _contentTextLabel.sd_layout.maxHeightIs(MAXFLOAT);
        _timeLabel.sd_layout.topSpaceToView(_contentTextLabel, 5);
    }else {
        _showMoreButton.hidden = NO;
        if (model.isOpen) {
            [_showMoreButton setTitle:@"收起" forState:UIControlStateNormal];
            _contentTextLabel.sd_layout.maxHeightIs(MAXFLOAT);
        }else {
            _contentTextLabel.sd_layout.maxHeightIs(maxShowTextHeight);
        }
        _timeLabel.sd_layout.topSpaceToView(_showMoreButton, 5);
    }
}

/// 判断是否需要展示点赞栏
/// @param model cell的模型数据
- (void)judgeIsShowLikeWithModel:(cellModel *)model {
    if (model.likeArray.count != 0) {
        //将likeArray里点赞的名字拼接起来，然后用富文本渲染
        NSMutableString *likeString = [[NSMutableString alloc]initWithString:@"💗"];
        for (int i=0; i < model.likeArray.count; i++) {
            NSString *likeNameString = model.likeArray[i];
            if (likeString.length == 2) {
                [likeString appendString:likeNameString];
            }else {
                [likeString appendFormat:@",%@",likeNameString];
            }
        }
        //计算likeName的高度
        CGSize size = [self textSizeWithString:likeString];
        _likeTextView.attributedText = [self renderWithString:likeString WithFont:[UIFont systemFontOfSize:13.0]];
        _likeTextView.sd_layout.heightIs(size.height);
        _lastView = _likeTextView;
    }else {
        //cell复用时不需要展示的话就将view的高度设为0
        _likeTextView.sd_layout.heightIs(0);
        _lastView = _timeLabel;
    }
}

/// 计算返回文本的size
/// @param likeString 要计算的字符串
- (CGSize)textSizeWithString:(NSMutableString *)likeString {
    return [likeString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size;;
}

/// 根据传入的文件对用户名进行渲染
/// @param string 用户名组合成的字符串
- (NSAttributedString *)renderWithString:(NSMutableString *)string WithFont:(UIFont *)font{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:font}];
    for (int i=0; i < _likeArray.count; i++) {
        NSString *likeName = _likeArray[i];
        NSRange range = [string rangeOfString:likeName];
        //给name渲染颜色
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor systemBlueColor] range:range];
        //给name加上link
        NSString *valueString = [[NSString stringWithFormat:@"clickName://%@", likeName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [attributeString addAttribute:NSLinkAttributeName value:valueString range:range];
        
    }
    return attributeString;
}

/// UITextView的代理方法 —— 用于超链接的实现
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"clickName"]) {
        //这里可以拓展出点击用户名进入主页的功能
        return YES;
    }
    return YES;
}

/// 当赞和评论的View展开时，点击cell的其他地方可以退出该View
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_menuView.isShow) {
        _menuView.isShow = !_menuView.isShow;
    }
}



@end
