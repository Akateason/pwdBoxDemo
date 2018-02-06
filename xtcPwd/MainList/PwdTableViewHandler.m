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

@interface PwdTableViewHandler () 
@property (weak, nonatomic) PwdListController *fromCtrller ;
@end

@implementation PwdTableViewHandler

- (instancetype)initWithCtrller:(PwdListController *)fromCtrller
{
    self = [super init] ;
    if (self) {
        _fromCtrller = fromCtrller ;
    }
    return self;
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
    [cell configure:item] ;
    
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
    BOOL bDel = [item deleteModel] ;
    if (!bDel) {
        [SVProgressHUD showErrorWithStatus:@"delete fail"] ;
        return ;
    }
    
    NSMutableArray *tmplist = [self.fromCtrller.dataList mutableCopy] ;
    [tmplist removeObjectAtIndex:indexPath.row] ;
//    self.fromCtrller.dataList = tmplist ;
    [self.fromCtrller setValue:tmplist forKey:@"dataList"] ;
    [self.fromCtrller.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade] ;
}


@end
