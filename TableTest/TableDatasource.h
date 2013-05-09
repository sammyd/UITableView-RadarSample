//
//  TableDatasource.h
//  TableTest
//
//  Created by Sam Davies on 22/01/2013.
//

#import <Foundation/Foundation.h>

@interface TableDatasource : NSObject<UITableViewDataSource>

// Accessible for the status logging method only
@property (readonly, assign) NSArray *store;

// Used for the delegate cell height method
- (CGFloat)heightForIndex:(NSInteger)index;

@end
