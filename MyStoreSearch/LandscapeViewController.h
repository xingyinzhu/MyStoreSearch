//
//  LandscapeViewController.h
//  MyStoreSearch
//
//  Created by Xingyin Zhu on 12-12-9.
//  Copyright (c) 2012年 Xingyin Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

//We’re going to make the view controller the delegate of the scroll view so we will be notified when the user is flicking through the pages.
@interface LandscapeViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *searchResults;

@end
