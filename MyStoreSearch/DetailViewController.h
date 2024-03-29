//
//  DetailViewController.h
//  MyStoreSearch
//
//  Created by Xingyin Zhu on 12-12-9.
//  Copyright (c) 2012年 Xingyin Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResult;

typedef enum
{
    DetailViewControllerAnimationTypeSlide,
    DetailViewControllerAnimationTypeFade
}DetailViewControllerAnimationType;

@interface DetailViewController : UIViewController


@property (nonatomic, strong) SearchResult *searchResult;

- (void)presentInParentViewController:(UIViewController *)parentViewController;
- (void)dismissFromParentViewController;

- (void)dismissFromParentViewControllerWithAnimationType:(DetailViewControllerAnimationType)animationType;

@end
