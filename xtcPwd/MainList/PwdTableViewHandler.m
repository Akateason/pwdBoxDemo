//
//  PwdTableViewHandler.m
//  xtcPwd
//
//  Created by xtc on 2018/2/6.
//  Copyright © 2018年 teason. All rights reserved.
//

#import "PwdTableViewHandler.h"
#import "ListCell.h"
#import "PwdItem.h"
#import <ReactiveObjC.h>
#import "PwdListController.h"
#import "ReqUtil.h"
#import "BYImageValue.h"
#import <UIImageView+WebCache.h>
#import "XTlib.h"

@interface PwdTableViewHandler () 
@property (weak, nonatomic) PwdListController *fromCtrller ;
@end

@implementation PwdTableViewHandler

- (instancetype)initWithCtrller:(PwdListController *)fromCtrller
{
    self = [super init] ;
    if (self) {
        _fromCtrller = fromCtrller ;
        
        @weakify(self)
        [[RACObserve(_fromCtrller.table, contentOffset)
          throttle:1]
         subscribeNext:^(id  _Nullable x) {
             @strongify(self)
             [self getImagesFromServer] ;
         }] ;
    }
    return self;
}

#pragma mark - util

- (void)getImagesFromServer {
    
    NSArray *visibleCells = self.fromCtrller.table.visibleCells ;
    
    for (ListCell *cell in visibleCells) {
        PwdItem *item = cell.model ;
        if (item.imageUrl.length) continue ;
        
        [ReqUtil searchImageWithName:item.name
                               count:1
                              offset:0
                          completion:^(NSArray *list) {

              if (!list) return ;
              
              BYImageValue *imageValue = [list firstObject] ;
              item.imageUrl = imageValue.thumbnailUrl ;
              [item xt_update] ;
              
              [cell.image sd_setImageWithURL:[NSURL URLWithString:item.imageUrl]
                                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                       
                   image = [UIImage thumbnailWithImage:image size:GET_IMAGE_SIZE_SCALE2x(cell.image.frame.size)] ;

                                   }] ;
                          }] ;
    }
    
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fromCtrller.dataList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"ListCell"] ;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [UIView animateWithDuration:.6
                     animations:^{
                         self.fromCtrller.btAdd.alpha = .4 ;
                         self.fromCtrller.btAdd.layer.transform = CATransform3DMakeTranslation(0, 60, 0) ;
                     }
                     completion:nil] ;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [UIView animateWithDuration:.6
                     animations:^{
                         self.fromCtrller.btAdd.alpha = 1 ;
                         self.fromCtrller.btAdd.layer.transform = CATransform3DIdentity ;
                     }
                     completion:nil] ;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [UIView animateWithDuration:.6
                     animations:^{
                         self.fromCtrller.btAdd.alpha = 1 ;
                         self.fromCtrller.btAdd.layer.transform = CATransform3DIdentity ;
                     }
                     completion:nil] ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ListCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PwdItem *item = self.fromCtrller.dataList[indexPath.row] ;
    [cell configure:item
          indexPath:indexPath] ;
    
    cell.image.alpha = 0. ;
    [UIView animateWithDuration:0.2
                     animations:^{
                         cell.image.alpha = 0.8 ;
                     }
                     completion:^(BOOL finished) {
                         cell.image.layer.transform = indexPath.row % 2 ? CATransform3DMakeTranslation(-10, 0, 0) : CATransform3DMakeTranslation(10, 0, 0) ;
                         [UIView animateWithDuration:.4
                                               delay:0
                              usingSpringWithDamping:.5
                               initialSpringVelocity:0
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              cell.image.layer.transform = CATransform3DIdentity ;
                                          }
                                          completion:nil] ;
                     }] ;
    
    cell.layer.transform = CATransform3DMakeScale(0.76, 0.76, 1) ;
    [UIView animateWithDuration:.25
                     animations:^{
                         cell.layer.transform = CATransform3DIdentity ;
                     }] ;
    
    cell.name.alpha = 0. ;
    cell.account.alpha = 0. ;
    [UIView animateWithDuration:1.6
                     animations:^{
                         cell.name.alpha = 1. ;
                         cell.account.alpha = 1. ;
                     }] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ListCell cellHeight] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.fromCtrller performSegueWithIdentifier:@"list2detail" sender:@(indexPath.row)] ;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES ;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete ;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        @weakify(self)
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"Confirm"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            @strongify(self)
                                                            [self doDelete:indexPath] ;
                                                        }] ;
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"cancel"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil] ;
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Remove"
                                                                           message:@"Are you sure to remove this item ???"
                                                                    preferredStyle:UIAlertControllerStyleAlert] ;
        [alertCtrl addAction:action0] ;
        [alertCtrl addAction:action1] ;
        [self.fromCtrller presentViewController:alertCtrl animated:YES completion:nil] ;
    }
}

- (void)doDelete:(NSIndexPath *)indexPath {
    PwdItem *item = self.fromCtrller.dataList[indexPath.row] ;
    BOOL bDel = [item xt_deleteModel] ;
    if (!bDel) {
        [SVProgressHUD showErrorWithStatus:@"delete fail"] ;
        return ;
    }
    
    NSMutableArray *tmplist = [self.fromCtrller.dataList mutableCopy] ;
    [tmplist removeObjectAtIndex:indexPath.row] ;
    [self.fromCtrller setValue:tmplist forKey:@"dataList"] ;
    [self.fromCtrller.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade] ;
}

@end
