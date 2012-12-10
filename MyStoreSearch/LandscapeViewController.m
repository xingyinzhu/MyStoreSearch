//
//  LandscapeViewController.m
//  MyStoreSearch
//
//  Created by Xingyin Zhu on 12-12-9.
//  Copyright (c) 2012年 Xingyin Zhu. All rights reserved.
//

#import "LandscapeViewController.h"
#import "SearchResult.h"
#import "AFImageCache.h"

@interface LandscapeViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

- (IBAction)pageChanged:(UIPageControl *)sender;
@end

@implementation LandscapeViewController
{
    NSOperationQueue *imageRequestOperationQueue;
}

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize searchResults = _searchResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [imageRequestOperationQueue setMaxConcurrentOperationCount:8];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LandscapeBackground"]];
    
    //self.scrollView.contentSize = CGSizeMake(1000, self.scrollView.bounds.size.height);
    [self tileButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
    [imageRequestOperationQueue cancelAllOperations];
}

- (void)tileButtons
{
    const CGFloat itemWidth = 96.0f;
    const CGFloat itemHeight = 88.0f;
    const CGFloat buttonWidth = 82.0f;
    const CGFloat buttonHeight = 82.0f;
    const CGFloat marginHorz = (itemWidth - buttonWidth)/2.0f;
    const CGFloat marginVert = (itemHeight - buttonHeight)/2.0f;
    
    int index = 0;
    int row = 0;
    int column = 0;
    
    for (SearchResult *searchResult in self.searchResults)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(column*itemWidth + marginHorz, row*itemHeight + marginVert, buttonWidth, buttonHeight);
        [button setBackgroundImage:[UIImage imageNamed:@"LandscapeButton"] forState:UIControlStateNormal];
        //[button setTitle:[NSString stringWithFormat:@"%d", index] forState:UIControlStateNormal];
        [self.scrollView addSubview:button];
        
        [self downloadImageForSearchResult:searchResult andPlaceOnButton:button];
        
        index ++;
        row++;
        if (row == 3)
        {
            row = 0;
            column ++;
        }
    }
    
    int numPages = ceilf([self.searchResults count] / 15.0f);
    self.scrollView.contentSize = CGSizeMake(numPages*480.0f, self.scrollView.bounds.size.height);
    
    self.pageControl.numberOfPages = numPages;
    self.pageControl.currentPage = 0;
    
    NSLog(@"Number of pages: %d", numPages);
}

- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
    CGFloat width = self.scrollView.bounds.size.width;
    int currentPage = (self.scrollView.contentOffset.x + width/2.0f) / width;
    self.pageControl.currentPage = currentPage;
}

- (IBAction)pageChanged:(UIPageControl *)sender
{
    //self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width * sender.currentPage, 0);
    [UIView animateWithDuration:0.3f
            delay:0
            options:UIViewAnimationOptionCurveEaseInOut animations:
            ^{
                self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width * sender.currentPage, 0);
            }
            completion:nil];
}

- (void)downloadImageForSearchResult:(SearchResult *)searchResult andPlaceOnButton:(UIButton *)button
{
    NSURL *url = [NSURL URLWithString:searchResult.artworkURL60];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [urlRequest setHTTPShouldHandleCookies:NO];
    [urlRequest setHTTPShouldUsePipelining:YES];
    
    UIImage *cachedImage = [[AFImageCache sharedImageCache] cachedImageForURL:[urlRequest URL] cacheName:nil];
    if (cachedImage != nil)
    {
        [button setImage:cachedImage forState:UIControlStateNormal];
    }
    else
    {
        AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:urlRequest];
        [requestOperation setCompletionBlockWithSuccess:
         ^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [button setImage:responseObject forState:UIControlStateNormal];
            [[AFImageCache sharedImageCache] cacheImageData:operation.responseData forURL:[urlRequest URL] cacheName:nil];
            
        }failure:nil];
        [imageRequestOperationQueue addOperation:requestOperation];
    }
}

@end
