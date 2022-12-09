--Уменьшение количества оставшихся занятий на абонементе
CREATE OR REPLACE FUNCTION decrement_number_of_remaining_classes() RETURNS TRIGGER AS
$$
begin
    if (SELECT number_of_remaining_classes FROM client WHERE client.id = new.client_id) = 0
    then
        raise exception 'No classes';
    elsif (SELECT number_of_remaining_classes FROM client WHERE client.id = new.client_id) IS NOT NULL
              and (SELECT number_of_remaining_classes FROM client WHERE client.id = new.client_id) <> 2147483647
    then
        UPDATE client SET number_of_remaining_classes = number_of_remaining_classes - 1
        WHERE client.id = new.client_id;
    elsif (SELECT number_of_remaining_classes FROM client WHERE client.id = new.client_id) IS NULL
    then
        raise exception 'No subscription';
    end if;
end;
$$ LANGUAGE plpgsql;

--Уменьшение количества свободных мест на групповом занятии
CREATE OR REPLACE FUNCTION decrement_number_of_free_places_in_group() RETURNS TRIGGER AS
$$
begin
    if (SELECT number_of_free_places FROM class_schedule WHERE class_schedule.group_number = new.group_number) - 1 >= 0
    then
        UPDATE class_schedule SET number_of_free_places = number_of_free_places - 1
                              WHERE class_schedule.group_number = new.group_number;
    else
        raise exception 'No free places in the group %', new.group_number;
    end if;
end;
$$ LANGUAGE plpgsql;

--Функция для обозначения записи на индивидуальное занятие
CREATE OR REPLACE FUNCTION mark_slot_as_non_free() RETURNS TRIGGER AS
$$
begin
    UPDATE individual_class_schedule SET enrolling = true
                                     WHERE individual_class_schedule.id = new.slot_id;
end;
$$ LANGUAGE plpgsql;

--Уменьшение количества мест на курсе
CREATE OR REPLACE FUNCTION decrement_number_of_free_places_on_course() RETURNS TRIGGER AS
$$
begin
    if (SELECT number_of_free_places FROM course WHERE course.name = new.name) - 1 >= 0
    then
        UPDATE course SET number_of_free_places = number_of_free_places - 1
                      WHERE course.name = new.name;
    else
        raise exception 'No free places on the course %', new.name;
    end if;
end;
$$ LANGUAGE plpgsql;

--Увеличение количества оставшихся занятий на абонементе
CREATE OR REPLACE FUNCTION increment_number_of_remaining_classes() RETURNS TRIGGER AS
$$
begin
    if (SELECT number_of_remaining_classes FROM client WHERE client.id = new.client_id) IS NOT NULL
           and (SELECT number_of_remaining_classes FROM client WHERE client.id = new.client_id) <> 2147483647
    then
        UPDATE client SET number_of_remaining_classes = number_of_remaining_classes + 1
                      WHERE client.id = new.client_id;
    end if;
end;
$$ LANGUAGE plpgsql;

--Увеличение колиества оставшихся мест на групповом занятии
CREATE OR REPLACE FUNCTION increment_number_of_free_places_in_group() RETURNS TRIGGER AS
$$
begin
    UPDATE class_schedule SET number_of_free_places = number_of_free_places + 1
                          WHERE class_schedule.group_number = new.group_number;
end;
$$ LANGUAGE plpgsql;

--Функция для обозначения отмены записи с индивидуального занятия
CREATE OR REPLACE FUNCTION mark_slot_as_free() RETURNS TRIGGER AS
$$
begin
    UPDATE individual_class_schedule SET enrolling = false
                                     WHERE individual_class_schedule.id = new.slot_id;
end;
$$ LANGUAGE plpgsql;

--Увеличение количества оставшихся мест на курсе
CREATE OR REPLACE FUNCTION increment_number_of_free_places_on_course() RETURNS TRIGGER AS
$$
begin
    UPDATE course SET number_of_free_places = number_of_free_places + 1
                  WHERE course.name = new.name;
end;
$$ LANGUAGE plpgsql;

--Добавление занятий при покупке нового абонемента
CREATE OR REPLACE FUNCTION add_classes_to_client() RETURNS TRIGGER AS
$$
begin
    if new.id = 1 or new.id = 2
    then UPDATE client SET number_of_remaining_classes = 1
                       WHERE client.id = new.client_id;
    elsif new.id = 6 or new.id = 7
    then UPDATE client SET number_of_remaining_classes = 2147483647
                       WHERE client.id = new.client_id;
    elsif new.id = 3
    then UPDATE client SET number_of_remaining_classes = 4
                       WHERE client.id = new.client_id;
    elsif new.id = 4
    then UPDATE client SET number_of_remaining_classes = 8
                       WHERE client.id = new.client_id;
    elsif new.id = 5
    then UPDATE client SET number_of_remaining_classes = 12
                       WHERE client.id = new.client_id;
    end if;
end;
$$ LANGUAGE plpgsql;
