//
//  FGCarouselView.m
//  轮播图
//
//  Created by wangguigui on 16/8/11.
//  Copyright © 2016年 topsci. All rights reserved.
//

#import "FGCarouselView.h"

@interface FGCarouselView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * carouseScrollView;
@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, strong) UIImageView * leftImage;
@property (nonatomic, strong) UIImageView * centerImage;
@property (nonatomic, strong) UIImageView * rightImage;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger beginX;
@property (nonatomic, assign) NSInteger endX;
@property (nonatomic, assign) BOOL canScrollToNext;
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation FGCarouselView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canScrollToNext = NO;
        self.currentPage = 0;
        [self addSubViews];
    }
    return self;
}

-(void)addSubViews
{
    self.carouseScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.carouseScrollView.delegate = self;
    self.carouseScrollView.pagingEnabled = YES;
    self.carouseScrollView.showsVerticalScrollIndicator = NO;
    self.carouseScrollView.showsHorizontalScrollIndicator = NO;
    self.carouseScrollView.contentSize = CGSizeMake(self.carouseScrollView.frame.size.width*3, 0);
    self.carouseScrollView.contentOffset = CGPointMake(self.carouseScrollView.frame.size.width, 0);
    [self.carouseScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage)]];
    [self addSubview:self.carouseScrollView];

    self.leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.carouseScrollView.frame.size.width, self.carouseScrollView.frame.size.height)];
    [self.carouseScrollView addSubview:self.leftImage];
    
    self.centerImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.carouseScrollView.frame.size.width, 0, self.carouseScrollView.frame.size.width, self.carouseScrollView.frame.size.height)];
    [self.carouseScrollView addSubview:self.centerImage];
    
    self.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.carouseScrollView.frame.size.width*2, 0, self.carouseScrollView.frame.size.width, self.carouseScrollView.frame.size.height)];
    [self.carouseScrollView addSubview:self.rightImage];

    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.carouseScrollView.frame.size.height - 20, self.carouseScrollView.frame.size.width, 20)];
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
}

-(void)clickImage
{
    [self.delegate clickImageAtIndex:self.currentPage];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.beginX = scrollView.contentOffset.x;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x-self.beginX>30 || scrollView.contentOffset.x-self.beginX<-30) {
        self.canScrollToNext = YES;
    } else {
        self.canScrollToNext = NO;
    }
    [self startTimer];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!self.canScrollToNext) {
        return;
    }
    BOOL isScrollToRight = NO;
    self.endX = scrollView.contentOffset.x;

    if (self.endX>self.beginX) {
        isScrollToRight = NO;
        self.currentPage+=1;
    } else {
        isScrollToRight = YES;
        self.currentPage-=1;
    }
    [self updateImage];
}

#pragma mark - 设置页面元素
-(void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    self.leftImage.image = _imageArray[imageArray.count-1];
    self.centerImage.image = _imageArray[0];
    self.rightImage.image = _imageArray[1];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.imageArray.count;
    [self startTimer];
}

-(void)setUrlArray:(NSMutableArray *)urlArray
{
    _urlArray = urlArray;
}

#pragma mark - 创建计时器
-(void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

-(void)nextImage
{
    self.currentPage+=1;
    [self updateImage];
}

#pragma mark - 更新图片
-(void)updateImage
{
    if (self.currentPage == self.imageArray.count) {
        self.currentPage = 0;
    }
    if (self.currentPage == -1) {
        self.currentPage = self.imageArray.count-1;
    }
    self.pageControl.currentPage = self.currentPage;
    self.carouseScrollView.contentOffset = CGPointMake(self.carouseScrollView.frame.size.width, 0);
    if (self.currentPage == 0) {
        self.leftImage.image = self.imageArray[self.imageArray.count-1];
        self.centerImage.image = self.imageArray[0];
        self.rightImage.image = self.imageArray[1];
    } else if (self.currentPage == self.imageArray.count-1) {
        self.leftImage.image = self.imageArray[self.currentPage-1];
        self.centerImage.image = self.imageArray[self.currentPage];
        self.rightImage.image = self.imageArray[0];
    } else {
        self.leftImage.image = self.imageArray[self.currentPage-1];
        self.centerImage.image = self.imageArray[self.currentPage];
        self.rightImage.image = self.imageArray[self.currentPage+1];
    }
    
    //给图片增加从右到左的动画
    CATransition * ca = [CATransition animation];
    ca.type = kCATransitionPush;
    ca.subtype = kCATransitionFromRight;
    ca.duration = 0.25;
    [self.centerImage.layer addAnimation:ca forKey:nil];
}

@end