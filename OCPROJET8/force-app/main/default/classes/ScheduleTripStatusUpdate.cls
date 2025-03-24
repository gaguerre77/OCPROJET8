public without sharing class ScheduleTripStatusUpdate implements Schedulable {
    public void execute(SchedulableContext SC) {
        UpdateTripStatusBatch batch = new UpdateTripStatusBatch();
        Database.executeBatch(batch);
    }
}
