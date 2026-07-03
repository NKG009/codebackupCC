declare module "@salesforce/apex/LMSUserController.getLmsUsers" {
  export default function getLmsUsers(): Promise<any>;
}
declare module "@salesforce/apex/LMSUserController.getUserDetail" {
  export default function getUserDetail(param: {userId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSUserController.searchUsers" {
  export default function searchUsers(param: {searchTerm: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSUserController.updateUserRole" {
  export default function updateUserRole(param: {userId: any, role: any}): Promise<any>;
}
