//Returns avg rating from list of ratings
export const generateRating = (ratings) => {
  return ratings.length > 0
    ? ratings.reduce((a, b) => a + b) / ratings.length
    : 0;
};

/*
  @param theRecord
  @param theField
 */
export const getLookupReferenceData = (theRecord, theField) => {
  const fieldInfo = theField.split(".");
  let lookupObject = fieldInfo[0];
  let lookupField = fieldInfo[1];

  const firstLevel = theRecord[lookupObject]
    ? theRecord[lookupObject][lookupField]
    : "";
  let secondLevel;
  if (fieldInfo.length > 2) {
    let thirdField = fieldInfo[2];
    secondLevel = theRecord[lookupObject][lookupField]
      ? theRecord[lookupObject][lookupField][thirdField]
      : "";
    return secondLevel;
  }
  return firstLevel;
};

export const filterColumns = (columnStatus, shifts) => {
  //Make a copy of shifts so that we dont alter the source array
  const shiftsCopy = JSON.parse(JSON.stringify(shifts));

  shiftsCopy.forEach((shift) => {
    const colInfo = shift.columnInfo;
    colInfo.forEach((col) => {
      const relevantCol = columnStatus.mainTable.find(
        (item) => item.column === col.label
      );
      col.selected = relevantCol.selected;
    });

    shift.shifts.forEach((child) => {
      const childColInfo = child.columnInfo;
      childColInfo.forEach((col) => {
        const relevantCol = columnStatus.subTable.find(
          (item) => item.column === col.label
        );
        col.selected = relevantCol.selected;
      });
    });
  });

  return shiftsCopy;
};