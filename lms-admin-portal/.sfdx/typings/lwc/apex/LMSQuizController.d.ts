declare module "@salesforce/apex/LMSQuizController.getQuestion" {
  export default function getQuestion(param: {questionId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSQuizController.saveQuestion" {
  export default function saveQuestion(param: {questionData: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSQuizController.getQuestionList" {
  export default function getQuestionList(param: {questionType: any, searchTerm: any, activeOnly: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSQuizController.getQuizDetail" {
  export default function getQuizDetail(param: {quizId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSQuizController.saveQuiz" {
  export default function saveQuiz(param: {quizData: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSQuizController.addQuestionToQuiz" {
  export default function addQuestionToQuiz(param: {quizId: any, questionId: any, sequenceNum: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSQuizController.removeQuizQuestion" {
  export default function removeQuizQuestion(param: {junctionId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSQuizController.getQuizList" {
  export default function getQuizList(): Promise<any>;
}
declare module "@salesforce/apex/LMSQuizController.deleteQuiz" {
  export default function deleteQuiz(param: {quizId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSQuizController.updateQuestionPoints" {
  export default function updateQuestionPoints(param: {junctionId: any, points: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSQuizController.duplicateQuestion" {
  export default function duplicateQuestion(param: {questionId: any}): Promise<any>;
}
declare module "@salesforce/apex/LMSQuizController.getQuizOptions" {
  export default function getQuizOptions(): Promise<any>;
}
