public class LoanCtrl {

    public List<SelectOption> TypeList { get; set; }
    public String selectedLtype { get; set; }
    public Loan__c loan {get;set;}   
    public List<Loan__C> loanlist; 
    public List<SelectOption> categoryList;
    public string str {get; set;}
    public boolean approve {get; set;}
    
    public LoanCtrl() {
       loan = new Loan__c();   
        str = 'Business';
    }    
    public List<selectOption> getCategoryvalues()
    {
        this.categoryList = new List<SelectOption>();
        this.categoryList.add(new selectoption('Home','Home'));
        this.categoryList.add(new selectoption('Business','Business'));
        this.categoryList.add(new selectoption('Agriculture','Agriculture'));
        this.categoryList.add(new selectoption('Education','Education'));
        return categoryList;
    }
    public List<selectOption> getTypeListvalues()
    {
        this.TypeList = new List<SelectOption>();
        this.TypeList.add(new selectoption('Personal','Personal'));
        this.TypeList.add(new selectoption('commercial','Commercial')); 
        return TypeList;
    }
    
    public List<Loan__C> getLoanList()
    {
        this.loanlist = new List<Loan__C>();
        this.loanlist = [select name__c,phone__c,loancategory__c,loantype__c,approved__c from loan__c 
                         where phone__C !=null];
        return this.loanlist;
    }
   
    public PageReference save()
    {                  
        loan.LoanCategory__c = str;
        loan.LoanType__c = selectedLtype;  
        loan.Approved__c = approve;      
        upsert loan;        
        return null;
    }

}