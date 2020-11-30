({
    /* checking whether it is a bundle product or normal product 
     * if it is a bundle product calling AccordianRecursive Component again
     */
    doInit: function(component,event,helper){
        console.log('attributes in accRecFirst doInit !!!'+JSON.stringify(component.get('v.attr')));
        component.set('v.priceSpinner',true);
        var recursiveFlag=component.get('v.recursiveCheck');
        var brkflag=component.get('v.breakflag');
        var childBundleBreak=component.get('v.childBundleBreakFlag');
        console.log('recursiveFlag .is. '+recursiveFlag + 'brkflag is.. '+brkflag + 'childBundleBreak is.. '+childBundleBreak);
        if(recursiveFlag){
            var pkgdata = component.get('v.packageKeyofFirstLevel');
            console.log('in recursive .. '+pkgdata);
            var overrideDatalist=component.get('v.dataOverrideList');
            console.log('response.dataOverrideList() at  **   ..   '+JSON.stringify(overrideDatalist));
            var items = [];
            var conMapData = component.get('v.con');
            console.log('response.getReturnValue() at  **   ..   '+JSON.stringify(conMapData));
            var response = conMapData;
            var overridenFlag = false;
            var innerChildsBundleBreakflag = false;
            for( var key in response) 
            {
                console.log('else key .. '+key);
                items.push({value:response[key], key:key}); 
                var internalBundle = response[key];
                if(overrideDatalist!=undefined && brkflag && !childBundleBreak){
                    for(var i=0;i<overrideDatalist.length;i++)
                    {
                        console.log('overrideDatalist[i].value.. '+overrideDatalist[i].value);
                        if(key == overrideDatalist[i].value)
                        {
                            overridenFlag = true;
                            component.set('v.breakflag',true);
                            component.set('v.childBundleBreakFlag',true);
                        }else{
                            var overridenVal = overrideDatalist[i].value;
                            console.log('internalBundle> is.. '+internalBundle);
                            console.log('internalBundle> is.. '+internalBundle.length);
                            overridenFlag=helper.tofindInternalChild(internalBundle,overridenFlag,overridenVal);
                        }
                    }
                    console.log('overridenFlag  ..   '+overridenFlag);
                    if(overridenFlag){
                        component.set('v.backAndForth',false);
                    }
                    else{
                        component.set('v.backAndForth',true);
                    }
                }
                
            }
            component.set('v.con',items); //commented for spinners
        }else{
            var firstLevelKey = component.get('v.con.key');
            console.log('firstLevelKey is.. '+firstLevelKey);
            component.set('v.packageKeyofFirstLevel',firstLevelKey);
            helper.getFlagForExpandOrCollapse(component,recursiveFlag);
        }
        component.set('v.initCheck',true);
        component.set('v.priceSpinner',false);
        
    },
    
    
    
   
    
    
    /*getting the attribute values*/
    setAttributeValue:function(component,event)
    {
        console.log("inside setAttributeValue");
        var attrvalue= event.getParam("Attribute");
        console.log('Attribute is..  '+JSON.stringify(attrvalue));
        for ( var key in attrvalue ) {
            attrListNew.push({value:attrvalue[key].attributes, key:attrvalue[key].product});
        }
        component.set('v.attr',attrListNew);
        component.set("v.isOpen", false);
        
    }
    
    
})