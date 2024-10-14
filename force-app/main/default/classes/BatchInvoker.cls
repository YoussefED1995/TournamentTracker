public with sharing class BatchInvoker {
    @AuraEnabled
    public static void invokeBatch() {
        TournamentDataGenerator generator = new TournamentDataGenerator();
        Database.executeBatch(generator);
    }
}