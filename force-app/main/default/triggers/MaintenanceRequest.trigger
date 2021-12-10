trigger MaintenanceRequest on case (after insert, after update) {
    // when the trigger is activated it passes through the new update to the maintenace request helper
    MaintenanceRequestHelper.UpdateMaintenanceRequest(Trigger.new);
}