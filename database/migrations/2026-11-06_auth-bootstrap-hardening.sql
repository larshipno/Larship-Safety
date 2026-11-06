-- Larship Safety: controlled Auth profile and first-Captain bootstrap
-- Draft migration for isolated test environment only.
-- DO NOT run on production or the external Larship.no Safety project yet.
--
-- Design:
--   1. Every auth.users insert creates a profile and the default 'ansatt' role.
--   2. A separate service_role-only RPC promotes exactly one user to 'kaptein'.
--   3. A transaction-scoped advisory lock serializes competing first-Captain claims.
--   4. The RPC refuses if any Captain already exists or the profile is missing.
--
-- App code must be updated to call claim_first_captain after creating the first
-- Auth user, and delete that Auth user if the RPC fails. This SQL alone does
-- NOT complete the first-account flow.

begin;

-- 1. Replace the incomplete trigger function. Do not assign Captain here.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $function$
begin
  insert into public.profiler (id, navn, ansattnummer, stilling, epost)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'navn', ''),
    nullif(new.raw_user_meta_data ->> 'ansattnummer', ''),
    coalesce(new.raw_user_meta_data ->> 'stilling', ''),
    new.email
  )
  on conflict (id) do nothing;

  insert into public.brukerroller (user_id, rolle)
  values (new.id, 'ansatt'::public.app_role)
  on conflict (user_id, rolle) do nothing;

  -- Fail the Auth insert if either required row is absent.
  if not exists (select 1 from public.profiler where id = new.id) then
    raise exception 'Larship: brukerprofil ble ikke opprettet.' using errcode = '23503';
  end if;

  if not exists (
    select 1 from public.brukerroller
    where user_id = new.id and rolle = 'ansatt'::public.app_role
  ) then
    raise exception 'Larship: standardrolle ble ikke opprettet.' using errcode = '23503';
  end if;

  return new;
end
$function$;

-- 2. Install exactly one AFTER INSERT trigger on auth.users.
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 3. Atomically claim the first Captain role. Only service_role may invoke it.
create or replace function public.claim_first_captain(_user_id uuid)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $function$
begin
  if _user_id is null then
    raise exception 'Bruker-ID mangler.' using errcode = '22004';
  end if;

  -- Fixed, application-specific advisory lock key. Held until transaction end.
  perform pg_advisory_xact_lock(73190421, 1);

  if not exists (select 1 from public.profiler where id = _user_id) then
    raise exception 'Brukerprofilen finnes ikke.' using errcode = '23503';
  end if;

  if exists (
    select 1 from public.brukerroller
    where rolle = 'kaptein'::public.app_role
  ) then
    raise exception 'Første kapteinkonto er allerede opprettet.' using errcode = '23505';
  end if;

  delete from public.brukerroller
  where user_id = _user_id and rolle <> 'kaptein'::public.app_role;

  insert into public.brukerroller (user_id, rolle)
  values (_user_id, 'kaptein'::public.app_role)
  on conflict (user_id, rolle) do nothing;
end
$function$;

revoke all on function public.claim_first_captain(uuid) from public;
revoke all on function public.claim_first_captain(uuid) from anon;
revoke all on function public.claim_first_captain(uuid) from authenticated;
grant execute on function public.claim_first_captain(uuid) to service_role;

-- Trigger functions are not directly callable as ordinary RPC endpoints.
revoke all on function public.handle_new_user() from public;
revoke all on function public.handle_new_user() from anon;
revoke all on function public.handle_new_user() from authenticated;

commit;

-- 4. Verification queries (run after migration in the isolated test database):
-- SELECT tgname, pg_get_triggerdef(oid)
-- FROM pg_trigger
-- WHERE tgrelid = 'auth.users'::regclass AND NOT tgisinternal;
--
-- SELECT p.proname, p.prosecdef, p.proconfig
-- FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
-- WHERE n.nspname = 'public'
--   AND p.proname IN ('handle_new_user', 'claim_first_captain');
--
-- SELECT grantee, privilege_type
-- FROM information_schema.routine_privileges
-- WHERE routine_schema = 'public' AND routine_name = 'claim_first_captain'
-- ORDER BY grantee, privilege_type;
--
-- Required app follow-up (not included here):
--   - After auth.admin.createUser, call RPC claim_first_captain({ _user_id }).
--   - If RPC fails, delete the newly created Auth user and return a safe error.
--   - Check affected-row counts for profile updates in all account/activation flows.
--   - Do not enable public first-account registration until this app change is tested.
