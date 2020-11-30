({
       
    
    /*getting the name of the internal Bundle 
     * and continue till the Bundle does not end
     */
    tofindInternalChild : function(internalBundle,overridenFlag,overridenVal)
    {
        var comeOutloopFlag = false;
        for(var i=0;i<internalBundle.length;i++){
            console.log('internalbundle name is.. '+internalBundle[i].name + 'overridenVal.. '+overridenVal)
            if(!comeOutloopFlag && internalBundle[i].name == undefined){
                var internalChildBob=internalBundle[i];
                for( var keyInternalBob in internalChildBob){
                    console.log('keyInternalBob.. '+keyInternalBob);
                    if(keyInternalBob == overridenVal){
                        overridenFlag = true;
                        comeOutloopFlag = true;
                        break;
                    }else{
                        this.tofindInternalChild(internalChildBob,overridenFlag,overridenVal);
                    }
                }
                
                
            }else{
            }
            console.log('comeOutloopFlag..'+comeOutloopFlag + 'overridenFlag..'+overridenFlag);
            if(comeOutloopFlag){
                break;
            }
        }
        return overridenFlag;
        
    },
    
    
    /* for bundle level expand collapse whenever needed
     * it will expand only the level in which some operation is going on
     * other levels should be closed
     */
    getFlagForExpandOrCollapse : function(component,recursiveFlag){
        var pkgKey=component.get('v.packageKeyofFirstLevel');
        console.log('pkgKey is at .. '+pkgKey);
        var conMapData = component.get('v.con');
        var response = conMapData;
        console.log('response'+response);
        var overridenFlag = false;
        var overrideDatalist=component.get('v.dataOverrideList');
        console.log('response.dataOverrideList()   ..   '+overrideDatalist);
        console.log('response.dataOverrideList() at  getFlagForExpandOrCollapse   ..   '+JSON.stringify(overrideDatalist));
        var overrideDataLen=JSON.stringify(overrideDatalist);
        var flagbrk = false;
        if(overrideDatalist!=undefined && overrideDataLen.length > 0){
            for(var key in response) 
            {
                console.log('package key .is. '+pkgKey +  'key is.. '+key);
                
                for(var i=0;i<overrideDatalist.length;i++)
                {
                    console.log('overrideDatalist key .. '+overrideDatalist[i].key);
                    if(!recursiveFlag &&  pkgKey== overrideDatalist[i].key)
                    {
                        overridenFlag = true;
                        console.log('overrideDatalist[i].value in ctroller.. '+overrideDatalist[i].value);
                        component.set('v.breakflag',true);
                        if(pkgKey== overrideDatalist[i].value){
                            component.set('v.childBundleBreakFlag',true);
                        }
                        flagbrk = true;
                        break;
                    }
                }
                console.log('flagbrk is.. '+flagbrk);
                if(flagbrk){
                    break;
                }
                
            }
            if(overridenFlag){
                component.set('v.backAndForth',false);
            }
            else{
                component.set('v.backAndForth',true);
            }
        }
        else if(overrideDatalist!=undefined && overrideDataLen.length > 0 && !recursiveFlag){
            this.getFlagForExpandOrCollapse(component,recursiveFlag);
        }else if(overrideDatalist!=undefined && overrideDataLen.length == 0){
            component.set('v.backAndForth',true);
        }
    },
})