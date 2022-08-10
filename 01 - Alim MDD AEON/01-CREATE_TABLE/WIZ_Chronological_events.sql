DROP TABLE IF EXISTS public.WIZ_chronological_events;

CREATE TABLE public.WIZ_chronological_events
(
    Type                   VARCHAR(500),
    Label                  VARCHAR(1000),
    OBJ_ID                 VARCHAR(500),
    chronological_position VARCHAR(30),
    Parent_OBJ_ID          VARCHAR(500),
    start_date             timestamp without time zone,
    duration               VARCHAR(100),
    end_date               timestamp without time zone,
    Blocked_BY             VARCHAR(30),
    Blocks                 VARCHAR(30),
    Evernote_LINk          VARCHAR(500),
    location               VARCHAR(500),
    ADDED_DATE timestamp
);



