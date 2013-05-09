# TableTest

Filed as rdar://13846681 and on [OpenRadar](http://openradar.appspot.com/13846681).

This project demonstrates a bug with reordering cells in UITableView.

The bug occurs only when the table contains cells of differing heights, more
specifically when the lower of 2 adjacent cells is less than half the height
of the upper. To replicate:

1) Enter edit mode on the table
2) Scroll the larger (upper) cell more than half way off screen, so that the
   grabber is only just visible.
3) Single tap the grabber.

The table is now in an inconsistent state with the datasource. The datasource's
tableView:moveRowAtIndexPath:toIndexPath: method has been called with the correct
index paths, so the datasource can be correctly updated, but the index paths of
the cells in the table are now incorrect.

This project demonstrates this by:
- Creating a trivial table view
- Allowing editing
- Making the top cell more than twice the height of the rest of them (100 -vs- 44)
- Having a log status button, which logs out the status of the backing array, and
  the table cells themselves.

To replicate the bug in the demo app:
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


--
Sam Davies, 23rd Jan 2013
