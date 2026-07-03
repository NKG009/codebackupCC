declare module "@salesforce/apex/LMSLessonController.getLessonList" {
  export default function getLessonList(): Promise<any>;
}
declare module "@salesforce/apex/LMSLessonController.getLesson" {
  export default function getLesson(param: {lessonId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSLessonController.saveLesson" {
  export default function saveLesson(param: {lessonData: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSLessonController.deleteLesson" {
  export default function deleteLesson(param: {lessonId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSLessonController.searchLessons" {
  export default function searchLessons(param: {searchTerm: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSLessonController.addExistingLesson" {
  export default function addExistingLesson(param: {lessonId: any, classId: any, courseId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSLessonController.createAndAddLesson" {
  export default function createAndAddLesson(param: {lessonData: any, classId: any, courseId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSLessonController.getClass" {
  export default function getClass(param: {classId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSLessonController.saveClass" {
  export default function saveClass(param: {classData: any}): Promise<any>;
}
