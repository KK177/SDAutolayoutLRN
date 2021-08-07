//
//  YTableViewCell.h
//  SDAutolayoutLRN
//
//  Created by iiik- on 2021/8/4.
//

#import <UIKit/UIKit.h>

@class cellModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^showMoreText)(NSIndexPath *indexPath);

@protocol MenuViewDelegate <NSObject>

@optional

- (void)updateLikeModelWithIndexPath:(NSIndexPath *)indexPath WithUsername:(NSString *)username;

@end

@interface YTableViewCell : UITableViewCell

@property (nonatomic, strong)cellModel *model;

@property (nonatomic, copy)showMoreText showBlk;

@property (nonatomic, strong)NSIndexPath *indexPath;

@property (nonatomic, weak)id<MenuViewDelegate>delegate;



@end

NS_ASSUME_NONNULL_END
