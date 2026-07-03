export const timeToDecimal = (hours) => {
  var arr = hours.split(":");
  var dec = parseInt((arr[1] / 6) * 10, 10);

  return parseFloat(parseInt(arr[0], 10) + "." + (dec < 10 ? "0" : "") + dec);
};

export const createDateAsUTC = (date) => {
  return new Date(
    Date.UTC(
      date.getFullYear(),
      date.getMonth(),
      date.getDate(),
      date.getHours(),
      date.getMinutes(),
      date.getSeconds()
    )
  );
};

export const addDays = (dateValue, days) => {
  var date = new Date(dateValue.valueOf());
  date.setDate(date.getDate() + days);
  return date;
};

export const addHours = (dateValue, hours) => {
  var date = new Date(dateValue.valueOf());
  date.setTime(date.getTime() + hours * 60 * 60 * 1000);
  return date;
};

export const getMonday = (date) => {
  date = new Date(date);
  let day = date.getDay(),
    diff = date.getDate() - day + (day === 0 ? -6 : 1); // adjust when day is sunday
  return new Date(date.setDate(diff));
};

export const daysBetween = (start, end) => {
  const date1 = new Date(start);
  const date2 = new Date(end);

  // One day in milliseconds
  const oneDay = 1000 * 60 * 60 * 24;

  // Calculating the time difference between two dates
  const diffInTime = date2.getTime() - date1.getTime();

  // Calculating the no. of days between two dates
  const diffInDays = Math.round(diffInTime / oneDay);

  return diffInDays;
};

export const getDSTOffset = (currentDate, targetDate) => {
  const currentOffset = new Date(currentDate.valueOf()).getTimezoneOffset();
  const targetOffset = new Date(targetDate.valueOf()).getTimezoneOffset();

  //DST is in effect in current but not target
  if (currentOffset < targetOffset) {
    return 1;
  }
  //DST is in effect in target but not current
  else if (currentOffset > targetOffset) {
    return -1;
  }
  //Else Both dates are in the same timezone
  return 0;
};

export const isDaylightSavingsObserved = (date) => {
  return date.getTimezoneOffset() < this.stdTimezoneOffset(date);
};

export const stdTimezoneOffset = (date) => {
  var jan = new Date(date.getFullYear(), 0, 1);
  var jul = new Date(date.getFullYear(), 6, 1);
  return Math.max(jan.getTimezoneOffset(), jul.getTimezoneOffset());
};