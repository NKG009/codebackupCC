import { LightningElement, api } from 'lwc';

const STATUS_MAP = {
    'Certified': 'badge--certified',
    'Completed': 'badge--completed',
    'In Progress': 'badge--inprogress',
    'Not Started': 'badge--notstarted',
    'Withdrawn': 'badge--withdrawn',
    'Published': 'badge--published',
    'Draft': 'badge--draft',
    'Pending Review': 'badge--pending',
    'Graded': 'badge--graded',
    'Auto-Graded': 'badge--autograded',
    'Disputed': 'badge--disputed',
    'MCQ': 'badge--type-mcq',
    'True/False': 'badge--type-tf',
    'Open-Ended': 'badge--type-open',
    'Upload': 'badge--type-upload',
    'Video': 'badge--type-video',
    'Article': 'badge--type-article',
    'PDF': 'badge--type-pdf',
    'Admin': 'badge--role-admin',
    'Instructor': 'badge--role-instructor',
    'Instructor-Student': 'badge--role-hybrid',
    'Student': 'badge--role-student',
};

export default class LmsStatusBadge extends LightningElement {
    @api label;
    @api variant;

    get badgeClass() {
        const key = STATUS_MAP[this.label] || 'badge--default';
        return `badge ${key}`;
    }
}
