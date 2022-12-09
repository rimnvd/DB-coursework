CREATE INDEX client_idx ON client USING hash(id);

CREATE INDEX class_schedule_idx ON class_schedule USING hash(number_of_free_places);

CREATE INDEX course_idx ON course USING hash(number_of_free_places);

