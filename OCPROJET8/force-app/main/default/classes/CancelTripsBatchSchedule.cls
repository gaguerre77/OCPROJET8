public class CancelTripsBatchSchedule {
    public static void scheduleBatch() {
        Id batchProcessId = Database.executeBatch(new CancelTripsBatch());
        System.debug('Batch Process ID: ' + batchProcessId);
    }
}
