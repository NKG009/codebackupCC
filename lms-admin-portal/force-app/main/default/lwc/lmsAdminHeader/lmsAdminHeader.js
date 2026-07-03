import { LightningElement, api } from 'lwc';
export default class LmsAdminHeader extends LightningElement {
    @api pageTitle;
    @api username;
}
