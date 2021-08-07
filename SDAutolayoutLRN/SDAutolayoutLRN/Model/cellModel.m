//
//  cellModel.m
//  SDAutolayoutLRN
//
//  Created by iiik- on 2021/8/4.
//

#import "cellModel.h"
#import <UIKit/UIKit.h>

extern CGFloat maxShowTextHeight;

@implementation cellModel

- (NSString *)contentText {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    CGRect rect = [_contentText boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil];
    if (rect.size.height > maxShowTextHeight) {
        _shouldShowTotal = NO;
    }else {
        _shouldShowTotal = YES;
    }
    return _contentText;
}

@end
