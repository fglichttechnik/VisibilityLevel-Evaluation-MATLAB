function cleanCellObject = cleanEmptyCells( cellObject)
    %# find empty cells
    emptyCells = cellfun( 'isempty', cellObject );
    %# remove empty cells
    cellObject( emptyCells ) = [];
    cleanCellObject = cellObject ;
end