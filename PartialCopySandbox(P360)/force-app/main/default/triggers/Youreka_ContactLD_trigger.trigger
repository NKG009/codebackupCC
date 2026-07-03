/* This trigger was created by the Youreka package and is integral to it. 
Please do not delete */
trigger Youreka_ContactLD_trigger on Contact (after update){
    disco.Util.updateAnswersInLinkedSections(trigger.new,'Contact');
}