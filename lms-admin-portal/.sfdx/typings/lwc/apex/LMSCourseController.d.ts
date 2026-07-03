declare module "@salesforce/apex/LMSCourseController.getDashboardStats" {
  export default function getDashboardStats(): Promise<any>;
}
declare module "@salesforce/apex/LMSCourseController.getCourseList" {
  export default function getCourseList(): Promise<any>;
}
declare module "@salesforce/apex/LMSCourseController.getCourseDetail" {
  export default function getCourseDetail(param: {courseId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSCourseController.saveCourse" {
  export default function saveCourse(param: {courseData: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSCourseController.deleteCourse" {
  export default function deleteCourse(param: {courseId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSCourseController.togglePublish" {
  export default function togglePublish(param: {recordId: any, currentState: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSCourseController.removeCourseClass" {
  export default function removeCourseClass(param: {junctionId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSCourseController.removeCourseLesson" {
  export default function removeCourseLesson(param: {junctionId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSCourseController.removeClassLesson" {
  export default function removeClassLesson(param: {junctionId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSCourseController.getCourseOptions" {
  export default function getCourseOptions(): Promise<any>;
}
declare module "@salesforce/apex/LMSCourseController.searchRecords" {
  export default function searchRecords(param: {objectName: any, searchTerm: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSCourseController.addClassToCourse" {
  export default function addClassToCourse(param: {courseId: any, classId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSCourseController.getRecentActivity" {
  export default function getRecentActivity(): Promise<any>;
}
