create or replace function "WizeCosm".Alim_WIZ_globale() returns varchar
    language plpgsql
as
$$
begin

  execute "WizeCosm".alim_wiz_chronological_events();

  execute "WizeCosm".alim_wiz_geographie();

  execute"WizeCosm".alim_wiz_personnages();

END
$$;





