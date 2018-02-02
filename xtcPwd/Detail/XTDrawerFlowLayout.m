//
//  XTDrawerFlowLayout.m
//  xtcPwd
//
//  Created by xtc on 2018/2/2.
//  Copyright © 2018年 teason. All rights reserved.
//

#import "XTDrawerFlowLayout.h"

@implementation XTDrawerFlowLayout

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 1.prepareLayout
 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 * 用来做布局的初始化操作（不建议在init方法中进行布局的初始化操作）
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 设置内边距
//    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
//    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect] ;
    
    // 计算collectionView最中心点的x值
    CGFloat centerY = self.collectionView.contentOffset.y + self.collectionView.frame.size.height * 0.5;
    
    // 在原有布局属性的基础上，进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // cell的中心点x 和 collectionView最中心点的x值 的间距
        CGFloat delta = ABS(attrs.center.y - centerY);
        
        // 根据间距值 计算 cell的缩放比例
        CGFloat scale = 1 - delta / self.collectionView.frame.size.height;
        
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}

/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 
 */
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    // 计算出最终显示的矩形框
//    CGRect rect;
//    rect.origin.x = 0;
//    rect.origin.y = proposedContentOffset.y;
//    rect.size = self.collectionView.frame.size;
//
//    // 获得super已经计算好的布局属性
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//
//    // 计算collectionView最中心点的x值
//    CGFloat centerY = proposedContentOffset.y + self.collectionView.frame.size.height * 0.5;
//
//    // 存放最小的间距值
//    CGFloat minDelta = MAXFLOAT;
//    for (UICollectionViewLayoutAttributes *attrs in array) {
//        if (ABS(minDelta) > ABS(attrs.center.y - centerY)) {
//            minDelta = attrs.center.y - centerY;
//        }
//    }
//
//    // 修改原有的偏移量
//    proposedContentOffset.y += minDelta;
//    return proposedContentOffset;
//}
//
@end
