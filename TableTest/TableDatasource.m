//
//  TableDatasource.m
//  TableTest
//
//  Created by Sam Davies on 22/01/2013.
//

#import "TableDatasource.h"

@interface TableDatasource () {
    NSMutableArray *datastore;
}
@end

@implementation TableDatasource

- (id)init
{
    self = [super init];
    if (self) {
        // Create an array of strings to serve as the backing store for the table
        @synchronized(datastore) {
            datastore = [[NSMutableArray alloc] init];
            for(int i=0; i < 15; i++) {
                [datastore addObject:[NSString stringWithFormat:@"cell %d", i]];
            }
        }
    }
    return self;
}

- (void)dealloc
{
    [datastore release];
    [super dealloc];
}

- (NSArray *)store
{
    // Utility method used by the status logging utility
    @synchronized(datastore) {
        return datastore;
    }
}

- (CGFloat)heightForIndex:(NSInteger)index
{
    // 
    @synchronized(datastore) {
        if ([[datastore objectAtIndex:index] isEqualToString:@"cell 0"]) {
            return 100;
        }
        return 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    @synchronized(datastore) {
        
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        // In iOS 6 we should be able to just use the above method, but to ensure
        //  we aren't having cell reuse issues, let's create a new cell every single
        //  time.
        
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        
        // Update the cell text
        cell.textLabel.text = [datastore objectAtIndex:indexPath.row];
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @synchronized(datastore) {
        return datastore.count;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    @synchronized(datastore) {
        NSString *cellName = [datastore[sourceIndexPath.row] retain];
        [datastore removeObjectAtIndex:sourceIndexPath.row];
        [datastore insertObject:cellName atIndex:destinationIndexPath.row];
        [cellName release];
        NSLog(@"\n\n=== Content of backing datastore after move ===");
        NSLog(@"%@", datastore);
    }
}

@end
