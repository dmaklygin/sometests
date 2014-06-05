//
//  dmMenuTableViewController.m
//  Vocxod
//
//  Created by Дмитрий on 05.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmMenuViewController.h"

@interface dmMenuViewController ()
@property (nonatomic, strong) NSMutableArray *menuItems;
@end

@implementation dmMenuViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.menuTable setBackgroundView:nil];
    [self.menuTable setBackgroundColor:[UIColor clearColor]];
    
    [self.menuTable reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)menuItems
{
    if (_menuItems) {
        return _menuItems;
    }
    
    _menuItems = [[NSMutableArray alloc] initWithArray:@[NSLocalizedString(@"MAIN", nil),
                                                         NSLocalizedString(@"SPORT", nil),
                                                         NSLocalizedString(@"LIVE", nil),
                                                         NSLocalizedString(@"FAVOURITES", nil),
                                                         NSLocalizedString(@"COUPON", nil)
                                                        ]];
    
    return _menuItems;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *menuItem = [self.menuItems objectAtIndex:indexPath.row];

    cell.textLabel.text = menuItem;
    
//    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


@end
