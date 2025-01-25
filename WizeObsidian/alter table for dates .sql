-- Add update_date column to politics table
ALTER TABLE wizeobsidian.politics
ADD COLUMN update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL;

-- Ensure update_date is updated automatically on row updates
CREATE OR REPLACE FUNCTION update_update_date_politics()
RETURNS TRIGGER AS $$
BEGIN
   NEW.update_date = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_update_date_politics
BEFORE UPDATE ON wizeobsidian.politics
FOR EACH ROW
EXECUTE FUNCTION update_update_date_politics();

-- Add update_date column to races table
ALTER TABLE wizeobsidian.races
ADD COLUMN update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL;

-- Ensure update_date is updated automatically on row updates
CREATE OR REPLACE FUNCTION update_update_date_races()
RETURNS TRIGGER AS $$
BEGIN
   NEW.update_date = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_update_date_races
BEFORE UPDATE ON wizeobsidian.races
FOR EACH ROW
EXECUTE FUNCTION update_update_date_races();
