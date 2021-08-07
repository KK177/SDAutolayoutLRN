//
//  MenuView.h
//  SDAutolayoutLRN
//
//  Created by iiik- on 2021/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickLikeButton)(void);

@interface MenuView : UIView

@property (nonatomic, assign)BOOL isShow;

@property (nonatomic, copy)clickLikeButton likeBlk;


@end

NS_ASSUME_NONNULL_END
