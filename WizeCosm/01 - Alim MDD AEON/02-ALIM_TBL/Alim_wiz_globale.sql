create procedure alim_wiz_globale()
    language plpgsql
as
$$
begin

 set search_path = wizecosm;

  perform wizecosm.alim_wiz_chronological_events();

  perform wizecosm.alim_wiz_geographie();

  perform wizecosm.alim_wiz_personnages();

END;

$$;

alter procedure alim_wiz_globale() owner to aoavfbel;

