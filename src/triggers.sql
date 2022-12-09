--При записи на курс количество свобододных мест на курсе уменьшается
CREATE OR REPLACE TRIGGER reduce_free_places_on_course AFTER INSERT ON signing_up_for_courses
    FOR EACH ROW EXECUTE FUNCTION decrement_number_of_free_places_on_course();

--При отмене записи на курс количество свободных мест на курсе увеличивается
CREATE OR REPLACE TRIGGER increase_free_places_on_course AFTER DELETE ON signing_up_for_courses
    FOR EACH ROW EXECUTE FUNCTION increment_number_of_free_places_on_course();

--При приобретении абонемента клиенту добавляется соответствующее количество занятий
CREATE OR REPLACE TRIGGER push_classes_to_client AFTER INSERT ON acquisition_of_services
    FOR EACH ROW EXECUTE FUNCTION add_classes_to_client();

--При записи на групповое занятие количество свободных мест в группе уменьшается
CREATE OR REPLACE TRIGGER reduce_free_places_in_group AFTER INSERT ON signing_up_for_classes
    FOR EACH ROW EXECUTE FUNCTION decrement_number_of_free_places_in_group();

--При записи на групповое занятие количество оставшихся занятий на абонементе уменьшается
CREATE OR REPLACE TRIGGER reduce_remaining_classes AFTER INSERT ON signing_up_for_classes
    FOR EACH ROW EXECUTE FUNCTION decrement_number_of_remaining_classes();

--При отмене записи на групповое занятие количество свободных мест в группе увеличивается
CREATE OR REPLACE TRIGGER increase_free_places_in_group AFTER DELETE ON signing_up_for_classes
    FOR EACH ROW EXECUTE FUNCTION increment_number_of_free_places_in_group();

--При отмене записи на групповое занятие количество оставшихся занятий на абонементе увеличивается
CREATE OR REPLACE TRIGGER increase_remaining_classes AFTER DELETE ON signing_up_for_classes
    FOR EACH ROW EXECUTE FUNCTION increment_number_of_remaining_classes();

--При записи на индивидуальное занятие слот помечается как несвободный
CREATE OR REPLACE TRIGGER enroll_to_individual_class AFTER INSERT ON signing_up_for_individual_classes
    FOR EACH ROW EXECUTE FUNCTION mark_slot_as_non_free();

--При отмене записи на индивидуальное занятие слот помечается как свободный
CREATE OR REPLACE TRIGGER cancel_enrolling_to_individual_class AFTER INSERT ON signing_up_for_individual_classes
    FOR EACH ROW EXECUTE FUNCTION mark_slot_as_free();



