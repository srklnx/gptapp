import 'care_records.dart';
import '../../tasks/domain/farm_task.dart';

abstract interface class MedicationCatalogRepository {
  List<MedicationRecord> getMedications();
}

abstract interface class CareTreatmentRepository {
  List<TreatmentRecord> getTreatments({String? sheepId});
  void saveTreatment(TreatmentRecord treatment);
}

abstract interface class CareEventRepository {
  List<FarmEvent> getEvents({String? sheepId});
  void saveEvent(FarmEvent event);
  void removeEvents(Iterable<String> ids);
}

abstract interface class FollowUpTaskRepository {
  List<FollowUpTask> getFollowUpTasks({String? sheepId});
  void saveFollowUpTask(FollowUpTask task);
}

abstract interface class FarmTaskRepository {
  List<FarmTask> getFarmTasks();
  void saveFarmTask(FarmTask task);
  void removeFarmTask(String id);
  List<FarmProtocol> getProtocols();
}

abstract interface class CareRepository
    implements
        MedicationCatalogRepository,
        CareTreatmentRepository,
        CareEventRepository,
        FollowUpTaskRepository,
        FarmTaskRepository {}
