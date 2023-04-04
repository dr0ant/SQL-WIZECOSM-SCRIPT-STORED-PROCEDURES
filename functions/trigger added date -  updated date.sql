-- Step 1: Create the function
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 2: Create the table
CREATE TABLE my_table (
  id SERIAL NOT NULL PRIMARY KEY,
  content TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Step 3: Create the trigger
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON my_table
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

-- Step 4: Profit
-- Now we can insert and update rows in the table, and both 
-- the created_at and updated_at columns will be saved correctly :)
select * from public.my_table;
insert into public.my_table (id,"content") values (default,'testtest')




