//
//  FGCarouselView.h
//  轮播图
//
//  Created by wangguigui on 16/8/11.
//  Copyright © 2016年 topsci. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FGCarouselViewDelegate <NSObject>
-(void)clickImageAtIndex:(NSInteger)index;
@end

@interface FGCarouselView : UIView
@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic, strong) NSMutableArray * urlArray;
@property (nonatomic, assign) id<FGCarouselViewDelegate>delegate;

@end
