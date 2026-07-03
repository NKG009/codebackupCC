import { LightningElement, api, wire } from 'lwc';
import getLesson from '@salesforce/apex/LMSLessonController.getLesson';
export default class LmsLessonPreview extends LightningElement {
    @api lessonId;
    lesson = {};
    @wire(getLesson, { lessonId: '$lessonId' })
    wiredLesson({ data }) { if (data) this.lesson = data; }
    get isVideo() { return this.lesson.Content_Type__c === 'Video'; }
    get embedUrl() {
        const url = this.lesson.Content_URL__c || '';
        if (url.includes('youtube.com/watch')) return url.replace('watch?v=', 'embed/');
        if (url.includes('youtu.be/')) return url.replace('youtu.be/', 'youtube.com/embed/');
        if (url.includes('vimeo.com/')) return url.replace('vimeo.com/', 'player.vimeo.com/video/');
        return url;
    }
    handleClose() { this.dispatchEvent(new CustomEvent('close')); }
}
