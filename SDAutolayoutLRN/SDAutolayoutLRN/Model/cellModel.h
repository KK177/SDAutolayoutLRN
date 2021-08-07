//
//  cellModel.h
//  SDAutolayoutLRN
//
//  Created by iiik- on 2021/8/4.
//

#import <Foundation/Foundation.h>

@class CommentModel;

NS_ASSUME_NONNULL_BEGIN

@interface cellModel : NSObject

@property (nonatomic, copy)NSString *contentText;

@property (nonatomic, copy)NSString *name;

@property (nonatomic, assign)BOOL isOpen;

@property (nonatomic, assign)BOOL shouldShowTotal;

@property (nonatomic, strong)NSMutableArray *likeArray;

@property (nonatomic, strong)NSMutableArray <cellModel *>* commentArray;

@end

NS_ASSUME_NONNULL_END
