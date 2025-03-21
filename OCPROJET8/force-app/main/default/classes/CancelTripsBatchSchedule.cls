public class CancelTripsBatchSchedule implements Schedulable {
    // Méthode pour planifier le traitement par lots
    public static void scheduleBatch() {
        // Planifier le traitement par lots pour s'exécuter toutes les heures
        String cronExpression = '0 0 * * * ?'; // Exemple d'expression CRON pour exécuter toutes les heures
        String jobId = System.schedule('Cancel Trips Batch', cronExpression, new CancelTripsBatchSchedule());
        System.debug('Scheduled Job ID: ' + jobId);
    }

    // Implémentation de l'interface Schedulable
    public void execute(SchedulableContext sc) {
        // Exécuter le traitement par lots
        Id batchProcessId = Database.executeBatch(new CancelTripsBatch());
        System.debug('Batch Process ID: ' + batchProcessId);
    }
}
