//
//  ViewController.m
//  TableTest
//
//  Created by Sam Davies on 22/01/2013.
//


/* This project demonstrates a potential bug in UITableView when reordering
 with non-constant height rows. To replicate the bug:
 1. Open the project
 2. Click the edit button
 3. Scroll the table down so that the grabber icon is only just visible for the
    top cell (cell 0).
 4. Single tap the reordering grabber.
 
 The table now has an inconsistent index path state. The log status button shows
 the index path (row) for each of the cells currently visible table, and the
 corresponding index of the content of that cell in the backing array. These
 should always match. Pressing it after the above actions will reveal that this
 isn't the case, and if you scroll back to the top of the table and log the status
 again you'll see that some of the cell content is repeated. Further scrolling
 of the table will cause blank rows to appear etc.
 
 */

#import "ViewController.h"
#import "TableDatasource.h"

@interface ViewController ()<UITableViewDelegate> {
    UITableView *tableView;
    TableDatasource *ds;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Create a simple tableview
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 300, 500)];
    ds = [[TableDatasource alloc] init];
    tableView.dataSource = ds;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.allowsSelection = NO;
    [self.view addSubview:tableView];
    
    // Create a couple of buttons
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editButton.frame = CGRectMake(5, 5, 90, 40);
    [editButton setTitle:@"edit" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editTable) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
    
    UIButton *printButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    printButton.frame = CGRectMake(100, 5, 90, 40);
    [printButton setTitle:@"log status" forState:UIControlStateNormal];
    [printButton addTarget:self action:@selector(printStatus) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:printButton];
    
    // Beautiful design
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)dealloc
{
    [ds release];
    [tableView release];
    [super dealloc];
}

#pragma mark - UIButton callback methods
- (void)editTable
{
    [tableView setEditing:!tableView.editing animated:YES];
}

- (void)printStatus
{
    NSMutableString *logOutput = [NSMutableString string];
    [logOutput appendString:@"\n\n=== Visible Table Cell Status ===\n"];
    [logOutput appendString:@" Showing:\n"];
    [logOutput appendString:@"   - cell index path row\n"];
    [logOutput appendString:@"   - index of content for this cell in the backing array\n"];
    [logOutput appendString:@"   - the content text of the cell\n"];
    [logOutput appendString:@" NOTE: The cell index path row and the index of content in the backing array should always be equal\n"];
    for(UITableViewCell *cell in tableView.visibleCells) {
        if([ds.store indexOfObject:cell.textLabel.text] != NSNotFound) {
            [logOutput appendFormat:@"cell idx: %d => content idx: %d (%@)\n", [tableView indexPathForCell:cell].row, [ds.store indexOfObject:cell.textLabel.text], cell.textLabel.text];
        }
    }
    NSLog(@"%@", logOutput);
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ds heightForIndex:indexPath.row];
}

@end
