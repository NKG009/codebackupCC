/**
 * Created by mrahman on 2021-02-25.
 */
({
    doInit : function(cmp, event, helper){
        var currentYear = $A.localizationService.formatDate(new Date(), "YYYY");
        cmp.set("v.year", currentYear);

        var bDetails = cmp.get("v.brandDetails");
        console.log("brandDetails >> " + cmp.get("v.brandDetails"));
        //if(bDetails === null) {
            helper.getBrandDetails(cmp, event);
        //}
    }
})