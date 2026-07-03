import { ShowToastEvent } from "lightning/platformShowToastEvent";

/*
 Acts as a wrapper for LWC's ShowToastEvent
 
 @param variant - The type of message, acceptable parameters are: info, success, error, warning
 @param message - The desired tbody for the message
 @param component - The LWC to bind the dispatch event to
*/
export const showMessageToUser = (variant, message, component) => {
  const event = new ShowToastEvent({
    message: message,
    variant: variant
  });
  component.dispatchEvent(event);
};

/*
 Allows you to set a cookie
 
 @param cname - The name of the cookie
 @param cvalue - The body of the cookie
 @param expiryDays - How many days the cookie expires in 
*/

export function setCookie(cname, cvalue, expiryDays) {
  const d = new Date();
  d.setTime(d.getTime() + expiryDays * 24 * 60 * 60 * 1000);
  let expires = "expires=" + d.toUTCString();
  document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}
/*
 Allows you to get a cookie
 
 @param cname - The name of the cookie
 */
export function getCookie(cname) {
  let name = cname + "=";
  let ca = document.cookie.split(";");
  for (let i = 0; i < ca.length; i++) {
    let c = ca[i];
    while (c.charAt(0) === " ") {
      c = c.substring(1);
    }
    if (c.indexOf(name) === 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}