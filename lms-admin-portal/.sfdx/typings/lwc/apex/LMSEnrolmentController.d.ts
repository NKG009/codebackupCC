declare module "@salesforce/apex/LMSEnrolmentController.getEnrolmentList" {
  export default function getEnrolmentList(param: {courseId: any, status: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSEnrolmentController.enrolLearner" {
  export default function enrolLearner(param: {enrolmentData: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSEnrolmentController.withdrawLearner" {
  export default function withdrawLearner(param: {enrolmentId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSEnrolmentController.getEnrolmentProgress" {
  export default function getEnrolmentProgress(param: {enrolmentId: any}): Promise<any>;
}
