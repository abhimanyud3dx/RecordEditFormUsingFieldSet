({
    doInit : function(component, event, helper) {
        var action = component.get("c.retrieveAccountFields");
        action.setCallback(this, function( response ) {
            var state = response.getState();
            if ( state === "SUCCESS") {
                var fieldsList = response.getReturnValue();
                component.set( "v.accountFieldSet",fieldsList);
            }
            else {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})