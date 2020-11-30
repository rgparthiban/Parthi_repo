public class Admin_Tracking_Controller {

    public Admin_Tracking__c adminTracking { get; set; }

    public Admin_Tracking_Controller() {

    }

    public PageReference save() {
        //return new ApexPages.StandardController(adminTracking).save();
        insert adminTracking ;
        return null;
    }
}