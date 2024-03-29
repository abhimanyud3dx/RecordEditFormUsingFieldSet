public class AccountFormController {
    
    /**
    * @description This Method will fetch the fields related to Account Fieldset
    * @author Abhimanyu Tanwar | 8/8/2019
    * @return List<FieldWrapper>
    */
    @AuraEnabled 
    public static List<FieldWrapper> retrieveAccountFields() {
        return getFieldSet('Account_Field_Set','Account');
    }
    
    /**
    * @description This Method will fetch the fields related to selected Fieldset
    * @author Abhimanyu Tanwar | 8/8/2019
    * @param String fieldSetName
    * @param String ObjectName
    * @return List<FieldWrapper>
    */
    private static List<FieldWrapper> getFieldSet(String fieldSetName, String ObjectName) {
        List<FieldWrapper> lstfieldWrapper = new List<FieldWrapper>();
        if (String.isNotBlank(fieldSetName) && String.isNotBlank(ObjectName)) {
            Schema.DescribeSObjectResult describeSObjectResult = Schema.getGlobalDescribe().get(ObjectName).getDescribe();
            Map<String,Schema.SObjectField> objFieldMap = describeSObjectResult.fields.getMap();
            Schema.FieldSet fieldSetObj = describeSObjectResult.FieldSets.getMap().get(fieldSetName);
            if (fieldSetObj != null) {
                for(Schema.FieldSetMember fieldSet : fieldSetObj.getFields() ) {
                    lstfieldWrapper.add( new FieldWrapper(
                        String.ValueOf(fieldSet.getLabel()),
                        String.ValueOf(fieldSet.getFieldPath()), 
                        (fieldSet.getDBRequired() || fieldSet.getRequired()),
                        objFieldMap.get(String.ValueOf(fieldSet.getFieldPath())).getDescribe().getInlineHelpText(),
                        objFieldMap.get(String.ValueOf(fieldSet.getFieldPath())).getDescribe().isHtmlFormatted() &&
                        objFieldMap.get(String.ValueOf(fieldSet.getFieldPath())).getDescribe().isCalculated()
                    ));
                }
            }
        }
        return lstfieldWrapper; 
    }
    
    public class FieldWrapper {
        @AuraEnabled public String fieldName {get;set;}
        @AuraEnabled public String fieldLabel {get;set;}
        @AuraEnabled public Boolean isRequired {get;set;}
        @AuraEnabled public String helpText {get;set;}
        @AuraEnabled public Boolean isHtmlFormatted {get;set;}
        
        public FieldWrapper(String fieldLabel,String fieldName,Boolean isRequired, String helpText, Boolean isHtmlFormatted ) {
            this.fieldLabel  = fieldLabel;
            this.fieldName   = fieldName;
            this.isRequired  = isRequired;
            this.helpText    = helpText;
            this.isHtmlFormatted = isHtmlFormatted;
        }
    }
}