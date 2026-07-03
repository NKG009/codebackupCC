global with sharing class IntegrationProcedureInvocable {
    @InvocableMethod(label = 'Integration Procedure')
    global static List<IntegrationProcedureOutput> runIntegrationServiceInvocable(List<IntegrationProcedureInput> input) {
        if (input == null || input.isEmpty()) {
            return new List<IntegrationProcedureOutput>();
        }
        
        IntegrationProcedureOutput result = new IntegrationProcedureOutput();     
        result.output = JSON.serialize(
            vlocity_cmt.IntegrationProcedureService.runIntegrationService(input[0].procedureAPIName,new Map<String, Object> { 'Id' => input[0].input.split(',')[0], 'AttachmentName' => input[0].input.split(',')[1], 'DocumentLanguage' => input[0].input.split(',')[2]}, new Map<String, Object>())
        );
        
        return new List<IntegrationProcedureOutput>{ result };
    }
    
    global class IntegrationProcedureInput {
        @InvocableVariable(label = 'Procedure Name') global String procedureAPIName;
        @InvocableVariable(label = 'Input') global String input;
    }
    
    global class IntegrationProcedureOutput {
        @InvocableVariable(label = 'Output') global String output;
    }
}