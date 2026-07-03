declare module "@salesforce/apex/LMSGradingController.getPendingCount" {
  export default function getPendingCount(): Promise<any>;
}
declare module "@salesforce/apex/LMSGradingController.getGradingQueue" {
  export default function getGradingQueue(param: {courseId: any, status: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSGradingController.getAttemptDetail" {
  export default function getAttemptDetail(param: {attemptId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSGradingController.saveGrades" {
  export default function saveGrades(param: {attemptId: any, answers: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSGradingController.issueCertification" {
  export default function issueCertification(param: {attemptId: any}): Promise<any>;
}
