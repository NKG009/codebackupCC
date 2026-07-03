import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getSitesOfLoggedInUser from "@salesforce/apex/SiteManagementComponentController.getSitesOfLoggedInUser";
import getContactSiteLinksForUser from "@salesforce/apex/SiteManagementComponentController.getContactSiteLinksForUser";

import { createRecord } from "lightning/uiRecordApi";

import ERROR_LOG_OBJECT from "@salesforce/schema/Portal_Error_Log__c";
import REPORTED_BY_FIELD from "@salesforce/schema/Portal_Error_Log__c.Reported_By__c";
import ERROR_MESSAGE_FIELD from "@salesforce/schema/Portal_Error_Log__c.Error_Message__c";
import ERROR_DATE_FIELD from "@salesforce/schema/Portal_Error_Log__c.Error_Date__c";
import ERROR_SHIFT_FIELD from "@salesforce/schema/Portal_Error_Log__c.Shift__c";

export function setCookie(cname, cvalue, expiryDays) {
  const d = new Date();
  d.setTime(d.getTime() + expiryDays * 24 * 60 * 60 * 1000);
  let expires = "expires=" + d.toUTCString();
  document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

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

export const showMessageToUser = (variant, message, component) => {
  const event = new ShowToastEvent({
    message: message,
    variant: variant
  });
  component.dispatchEvent(event);
};

export const parseSiteValue = (value) => {
  try {
    return JSON.parse(value);
  } catch (err) {
    return value;
  }
};

export const fetchLoggedInUserSites = async () => {
  //init logged in user sites
  const availableSites = [];
  try {
    const result = await getSitesOfLoggedInUser();

    result.forEach((site) => {
      availableSites.push({
        value: site.Id,
        label: site.Name,
        creditStatus: site.IP_CreditStatus__c
      });
    });
    console.log("Logged In User Sites: ", result);
  } catch (error) {
    showMessageToUser(
      "error",
      "An internal error occurred while fetching logged-in user sites.",
      this
    );

    console.log("Logged In User Sites Error As Object: ", error);
    console.log(
      "Logged In User Sites Error As String: ",
      JSON.stringify(error)
    );
  }
  return availableSites;
};

export const isViewOnlyUser = async () => {
  const links = await getContactSiteLinksForUser();
  console.log(links);
  const readOnlyLink = links.find(
    (link) =>
      link.IP_PortalType__c.includes("Viewer") ||
      link.IP_PortalType__c.includes("Consultant")
  );
  console.log(readOnlyLink);

  return readOnlyLink !== undefined;
};

export const createErrorLog = async (reportedBy, errorMessage, shiftRecord) => {
  const errorDate = new Date();
  const fields = {};
  fields[ERROR_DATE_FIELD.fieldApiName] = errorDate;
  fields[ERROR_MESSAGE_FIELD.fieldApiName] = JSON.stringify(errorMessage)
    ? JSON.stringify(errorMessage)
    : errorMessage;
  fields[REPORTED_BY_FIELD.fieldApiName] = reportedBy;
  if (shiftRecord) fields[ERROR_SHIFT_FIELD.fieldApiName] = shiftRecord;

  const recordInput = {
    apiName: ERROR_LOG_OBJECT.objectApiName,
    fields: fields
  };

  return createRecord(recordInput);
};

export const getTimeFromIsoString = (string) => {
  const stringPieces = string.split("T");
  return stringPieces[1];
};
export const getDateFromIsoString = (string) => {
  const stringPieces = string.split("T");
  return stringPieces[0];
};