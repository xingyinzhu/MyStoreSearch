//
//  ViewController.m
//  MyStoreSearch
//
//  Created by Xingyin Zhu on 12-12-7.
//  Copyright (c) 2012年 Xingyin Zhu. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResult.h"
#import "SearchResultCell.h"
#import "AFJSONRequestOperation.h"
#import "AFImageCache.h"
#import "DetailViewController.h"
#import "LandscapeViewController.h"
#import "DetailViewController.h"
#import "Search.h"

static NSString *const SearchResultCellIdentifier = @"SearchResultCell";
static NSString *const NothingFoundCellIdentifier = @"NothingFoundCell";
static NSString *const LoadingCellIdentifier = @"LoadingCell";

@interface SearchViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentChanged:(UISegmentedControl *)sender;

@end

@implementation SearchViewController
{
    Search *search;
    LandscapeViewController *landscapeViewController;
    //prevent a memory leak
    __weak DetailViewController *detailViewController;
}

@synthesize searchBar = _searchBar;
@synthesize tableView = _tableView;
@synthesize segmentedControl = _segmentedControl;

- (void)showLandscapeViewWithDuration:(NSTimeInterval)duration
{
    if (landscapeViewController == nil)
    {
        landscapeViewController = [[LandscapeViewController alloc] initWithNibName:@"LandscapeViewController" bundle:nil];
        landscapeViewController.search = search;
        
        landscapeViewController.view.frame = self.view.bounds;
        landscapeViewController.view.alpha = 0.0f;
        
        [self.view addSubview:landscapeViewController.view];
        [self addChildViewController:landscapeViewController];
        
        [UIView animateWithDuration:duration animations:
        ^{
            landscapeViewController.view.alpha = 1.0f;
        } completion:^(BOOL finished)
        {
            [landscapeViewController didMoveToParentViewController:self];
        }];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
        //[landscapeViewController didMoveToParentViewController:self];
        
        //dismiss the keyboard
        [self.searchBar resignFirstResponder];
        [detailViewController dismissFromParentViewControllerWithAnimationType:DetailViewControllerAnimationTypeFade];
    }
}

- (void)hideLandscapeViewWithDuration:(NSTimeInterval)duration
{
    if (landscapeViewController != nil)
    {
        [landscapeViewController willMoveToParentViewController:nil];
        
        [UIView animateWithDuration:duration animations:
         ^{
            landscapeViewController.view.alpha = 0.0f;
        }
        completion:^(BOOL finished)
        {
            [landscapeViewController.view removeFromSuperview];
            [landscapeViewController removeFromParentViewController];
            landscapeViewController = nil;
        }];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        [self hideLandscapeViewWithDuration:duration];
    }
    else
    {
        [self showLandscapeViewWithDuration:duration];
    }
}

- (IBAction)segmentChanged:(UISegmentedControl *)sender
{
    if (search != nil)
    {
        [self performSearch];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UINib *cellNib = [UINib nibWithNibName:SearchResultCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SearchResultCellIdentifier];

    cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    
    cellNib = [UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:LoadingCellIdentifier];
    
    self.tableView.rowHeight = 80;
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (search.isLoading)
    {
        return 1;
    }
    else if (search.searchResults == nil)
    {
        return 0;
    }
    else if ([search.searchResults count] == 0)
    {
        return 1;
    }
    else
    {
        return [search.searchResults count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"SearchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    */
    if (search.isLoading)
    {
        return [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
        
    }
    else if ([search.searchResults count] == 0)
    {
        return [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier];
    }
    else
    {
        SearchResultCell *cell = (SearchResultCell *)[tableView dequeueReusableCellWithIdentifier:SearchResultCellIdentifier];
        
        //SearchResult *searchResult = [searchResults objectAtIndex:indexPath.row];
        SearchResult *searchResult = search.searchResults[indexPath.row];
        [cell configureForSearchResult:searchResult];
        return cell;

    }
    //return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)showNetworkError
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Whoops...",@"Error alert: title")
                              message:NSLocalizedString(@"There was an error reading from the iTunes Store. Please try again.", @"Error alert: message")
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}


#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSearch];
}

- (void)performSearch
{
    search = [[Search alloc] init];
    NSLog(@"allocated %@", search);
    [search performSearchForText:self.searchBar.text
                        category:self.segmentedControl.selectedSegmentIndex
                        completion:^(BOOL success)
                        {
                            if (!success)
                            {
                                [self showNetworkError];
                            }
                            
                            [landscapeViewController searchResultsReceived];
                            [self.tableView reloadData];
                        }];
    
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *controller = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    //[self presentViewController:controller animated:YES completion:nil];
    //pass the value
    SearchResult *searchResult = [search.searchResults objectAtIndex:indexPath.row];
    controller.searchResult = searchResult;
    
    [controller presentInParentViewController:self];
    detailViewController = controller;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([search.searchResults count] == 0 || search.isLoading)
    {
        return nil;
    }
    else
    {
        return indexPath;
    }
}

@end
