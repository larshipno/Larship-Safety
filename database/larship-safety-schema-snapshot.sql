-- Larship Safety database schema snapshot
-- Extracted from the clean, empty Lovable test database on 2026-11-06.
-- This file contains schema/security definitions only; no crew, account, or operational rows.
-- TARGET: a NEW, EMPTY Supabase project only. Do not run against production or a populated database.
-- Prerequisites: Supabase project with auth and storage schemas/extensions provisioned.
-- Review all RLS/functions and auth bootstrap flow before applying to any live test environment.
-- Note: no auth.users trigger was present in the source snapshot; handle_new_user() exists as a function only.

begin;

-- 1. Application enum types
create type public."app_role" as enum ('kaptein', 'overstyrmann', 'ansatt');

-- 2. Tables (constraints are added after all tables exist)
create table public."aktiveringskoder" (
  "id" uuid default gen_random_uuid() not null,
  "kode_hash" text not null,
  "skip_id" text not null,
  "ansatt_id" text not null,
  "rolle" app_role default 'ansatt'::app_role not null,
  "merkelapp" text default ''::text not null,
  "utloper" timestamp with time zone not null,
  "brukt" timestamp with time zone,
  "brukt_av" uuid,
  "tilbakekalt" timestamp with time zone,
  "opprettet_av" uuid,
  "opprettet" timestamp with time zone default now() not null
);
create table public."alarmruller" (
  "id" text not null,
  "rolle" text not null,
  "monstringsstasjon" text default ''::text not null,
  "alarmlyd" text default ''::text not null,
  "skip_id" text default 'skip-color-hybrid'::text not null,
  "oversettelser" jsonb default '{}'::jsonb not null
);
create table public."ansatt_aktivitet" (
  "id" text not null,
  "ansatt_id" text not null,
  "dato" date default CURRENT_DATE not null,
  "tekst" text not null
);
create table public."ansatt_opplaering" (
  "id" uuid default gen_random_uuid() not null,
  "ansatt_id" text not null,
  "prosedyre_id" text,
  "oppgave_id" text,
  "test_id" text,
  "status" text default 'fullfort'::text not null,
  "dato" date default CURRENT_DATE not null
);
create table public."ansatt_pakker" (
  "ansatt_id" text not null,
  "pakke_id" text not null
);
create table public."ansatt_utloper" (
  "id" text not null,
  "ansatt_id" text not null,
  "tittel" text not null,
  "forfaller" date
);
create table public."ansatte" (
  "id" text not null,
  "ansattnummer" text not null,
  "navn" text not null,
  "fornavn" text,
  "etternavn" text,
  "fodselsdato" date,
  "telefon" text,
  "epost" text,
  "stilling" text default ''::text not null,
  "avdeling" text,
  "beredskapsrolle" text default ''::text not null,
  "ansattype" text default 'permanent'::text not null,
  "midlertidig_fra" date,
  "midlertidig_til" date,
  "midlertidig_arsak" text,
  "kommentar" text,
  "kompetanse" text[] default '{}'::text[] not null,
  "status" text default 'critical'::text not null,
  "aktiv" boolean default true not null,
  "pa_vakt" boolean default false not null,
  "opprettet" timestamp with time zone default now() not null,
  "sist_endret" timestamp with time zone default now() not null,
  "skip_id" text default 'skip-color-hybrid'::text not null
);
create table public."brukerroller" (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "rolle" app_role not null,
  "opprettet" timestamp with time zone default now() not null
);
create table public."dagens_besetning" (
  "id" uuid default gen_random_uuid() not null,
  "dato" date default CURRENT_DATE not null,
  "ansatt_id" text not null,
  "vakt" text default 'Dagvakt'::text not null,
  "status" text default 'ok'::text not null,
  "skip_id" text default 'skip-color-hybrid'::text not null
);
create table public."dokumenter" (
  "id" text not null,
  "filnavn" text not null,
  "filtype" text default 'pdf'::text not null,
  "url" text default ''::text not null,
  "prosedyre_id" text,
  "oppgave_id" text,
  "test_id" text,
  "ansatt_id" text,
  "opprettet" timestamp with time zone default now() not null,
  "skip_id" text default 'skip-color-hybrid'::text not null,
  "storrelse" bigint,
  "mimetype" text
);
create table public."fartoy_tilknytning" (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "imo_nummer" text not null,
  "skip_id" text,
  "ansatt_id" text,
  "fra" date default CURRENT_DATE not null,
  "til" date,
  "opprettet" timestamp with time zone default now() not null
);
create table public."felles_testkode_bruk" (
  "id" uuid default gen_random_uuid() not null,
  "kode_id" uuid not null,
  "user_id" uuid not null,
  "ansatt_id" text not null,
  "nummer" integer not null,
  "tidspunkt" timestamp with time zone default now() not null
);
create table public."felles_testkoder" (
  "id" uuid default gen_random_uuid() not null,
  "kode_hash" text not null,
  "skip_id" text not null,
  "maks_bruk" integer default 5 not null,
  "antall_brukt" integer default 0 not null,
  "utloper" timestamp with time zone not null,
  "tilbakekalt" timestamp with time zone,
  "opprettet_av" uuid,
  "opprettet" timestamp with time zone default now() not null
);
create table public."oppgaver" (
  "id" text not null,
  "oppgavekode" text not null,
  "tittel" text not null,
  "kategori" text default ''::text not null,
  "ansvarlig_rolle" text default ''::text not null,
  "prosedyre_id" text,
  "intervall" text default 'Ved behov'::text not null,
  "beskrivelse" text default ''::text not null,
  "status" text default 'draft'::text not null,
  "steg" jsonb default '[]'::jsonb not null,
  "kontrollpunkter" jsonb default '[]'::jsonb not null,
  "koblede_prosedyrer" text[] default '{}'::text[] not null,
  "koblet_utstyr" text[] default '{}'::text[] not null,
  "koblede_tester" text[] default '{}'::text[] not null,
  "koblede_pakker" text[] default '{}'::text[] not null,
  "koblede_alarmruller" text[] default '{}'::text[] not null,
  "revisjon" text default '1.0'::text not null,
  "revisjoner" jsonb default '[]'::jsonb not null,
  "opprettet" timestamp with time zone default now() not null,
  "sist_endret" timestamp with time zone default now() not null,
  "skip_id" text default 'skip-color-hybrid'::text not null,
  "oversettelser" jsonb default '{}'::jsonb not null
);
create table public."opplaeringspakker" (
  "id" text not null,
  "navn" text not null,
  "beskrivelse" text,
  "opprettet" timestamp with time zone default now() not null,
  "skip_id" text default 'skip-color-hybrid'::text not null,
  "oversettelser" jsonb default '{}'::jsonb not null
);
create table public."opplaeringsplaner" (
  "ansatt_id" text not null,
  "opprettet" date default CURRENT_DATE not null,
  "prosedyre_ids" text[] default '{}'::text[] not null,
  "oppgave_ids" text[] default '{}'::text[] not null,
  "test_ids" text[] default '{}'::text[] not null,
  "utstyr_ids" text[] default '{}'::text[] not null,
  "alarmrulle_id" text,
  "krev_oppgave_for_test" boolean default false not null,
  "godkjent_dato" date,
  "godkjent_av" text
);
create table public."pakke_oppgaver" (
  "pakke_id" text not null,
  "oppgave_id" text not null
);
create table public."pakke_prosedyrer" (
  "pakke_id" text not null,
  "prosedyre_id" text not null
);
create table public."pakke_tester" (
  "pakke_id" text not null,
  "test_id" text not null
);
create table public."profiler" (
  "id" uuid not null,
  "navn" text default ''::text not null,
  "ansattnummer" text,
  "stilling" text default ''::text not null,
  "ansatt_id" text,
  "aktivt_skip_id" text,
  "aktivt_imo" text,
  "opprettet" timestamp with time zone default now() not null,
  "sist_endret" timestamp with time zone default now() not null,
  "epost" text,
  "sist_innlogget" timestamp with time zone,
  "sprak" text default 'nb'::text not null
);
create table public."prosedyrer" (
  "id" text not null,
  "prosedyrekode" text not null,
  "tittel" text not null,
  "kategori" text default ''::text not null,
  "beskrivelse" text default ''::text not null,
  "formaal" text default ''::text not null,
  "ansvar" text default ''::text not null,
  "steg" jsonb default '[]'::jsonb not null,
  "kontrollpunkter" jsonb default '[]'::jsonb not null,
  "koblede_oppgaver" text[] default '{}'::text[] not null,
  "koblede_tester" text[] default '{}'::text[] not null,
  "koblet_utstyr" text[] default '{}'::text[] not null,
  "koblede_pakker" text[] default '{}'::text[] not null,
  "revisjon" text default '1.0'::text not null,
  "revidert" date,
  "status" text default 'draft'::text not null,
  "opprettet" timestamp with time zone default now() not null,
  "sist_endret" timestamp with time zone default now() not null,
  "skip_id" text default 'skip-color-hybrid'::text not null,
  "revisjoner" jsonb default '[]'::jsonb not null,
  "oversettelser" jsonb default '{}'::jsonb not null
);
create table public."situasjonsrapporter" (
  "id" uuid default gen_random_uuid() not null,
  "skip_id" text not null,
  "rapportert_av" uuid,
  "ansatt_id" text,
  "rapportor_navn" text default ''::text not null,
  "beskrivelse" text not null,
  "bilde_sti" text,
  "status" text default 'ny'::text not null,
  "opprettet" timestamp with time zone default now() not null,
  "behandlet_av" uuid,
  "behandlet_tid" timestamp with time zone,
  "bilde_slettet" timestamp with time zone,
  "bilde_slettet_av" uuid
);
create table public."skip" (
  "id" text not null,
  "navn" text not null,
  "imo_nummer" text default ''::text not null,
  "mmsi" text default ''::text not null,
  "kallesignal" text default ''::text not null,
  "rederi" text default ''::text not null,
  "flaggstat" text default ''::text not null,
  "skipstype" text default ''::text not null,
  "antall_besetning" integer default 0 not null,
  "aktiv" boolean default true not null,
  "standard" boolean default false not null,
  "opprettet" timestamp with time zone default now() not null,
  "sist_endret" timestamp with time zone default now() not null
);
create table public."tester" (
  "id" text not null,
  "testkode" text not null,
  "tittel" text not null,
  "beskrivelse" text default ''::text not null,
  "antall_sporsmal" integer default 0 not null,
  "bestattgrense" integer default 80 not null,
  "sporsmal" jsonb default '[]'::jsonb not null,
  "status" text default 'active'::text not null,
  "opprettet" timestamp with time zone default now() not null,
  "sist_endret" timestamp with time zone default now() not null,
  "skip_id" text default 'skip-color-hybrid'::text not null,
  "oversettelser" jsonb default '{}'::jsonb not null
);
create table public."testresultater" (
  "id" text not null,
  "test_id" text not null,
  "ansatt_id" text,
  "ansatt_navn" text default ''::text not null,
  "poengsum" integer default 0 not null,
  "bestatt" boolean default false not null,
  "fullfort" timestamp with time zone default now() not null,
  "godkjent_av" text,
  "svar" jsonb default '[]'::jsonb not null
);
create table public."utstyr" (
  "id" text not null,
  "navn" text not null,
  "plassering_id" text default ''::text not null,
  "plassering" text default ''::text not null,
  "brannstasjon" text,
  "status" text default 'aktiv'::text not null,
  "kontrollpunkter" jsonb default '[]'::jsonb not null,
  "skip_id" text default 'skip-color-hybrid'::text not null,
  "oversettelser" jsonb default '{}'::jsonb not null
);

-- 3. Primary, unique, check and foreign-key constraints
alter table public."aktiveringskoder" add constraint "aktiveringskoder_ansatt_id_fkey" FOREIGN KEY (ansatt_id) REFERENCES ansatte(id);
alter table public."aktiveringskoder" add constraint "aktiveringskoder_kode_hash_key" UNIQUE (kode_hash);
alter table public."aktiveringskoder" add constraint "aktiveringskoder_pkey" PRIMARY KEY (id);
alter table public."aktiveringskoder" add constraint "aktiveringskoder_skip_id_fkey" FOREIGN KEY (skip_id) REFERENCES skip(id);
alter table public."alarmruller" add constraint "alarmruller_pkey" PRIMARY KEY (id);
alter table public."alarmruller" add constraint "alarmruller_skip_id_fkey" FOREIGN KEY (skip_id) REFERENCES skip(id) ON DELETE CASCADE;
alter table public."ansatt_aktivitet" add constraint "ansatt_aktivitet_ansatt_id_fkey" FOREIGN KEY (ansatt_id) REFERENCES ansatte(id) ON DELETE CASCADE;
alter table public."ansatt_aktivitet" add constraint "ansatt_aktivitet_pkey" PRIMARY KEY (id);
alter table public."ansatt_opplaering" add constraint "ansatt_opplaering_ansatt_id_fkey" FOREIGN KEY (ansatt_id) REFERENCES ansatte(id) ON DELETE CASCADE;
alter table public."ansatt_opplaering" add constraint "ansatt_opplaering_oppgave_id_fkey" FOREIGN KEY (oppgave_id) REFERENCES oppgaver(id) ON DELETE CASCADE;
alter table public."ansatt_opplaering" add constraint "ansatt_opplaering_pkey" PRIMARY KEY (id);
alter table public."ansatt_opplaering" add constraint "ansatt_opplaering_prosedyre_id_fkey" FOREIGN KEY (prosedyre_id) REFERENCES prosedyrer(id) ON DELETE CASCADE;
alter table public."ansatt_opplaering" add constraint "ansatt_opplaering_test_id_fkey" FOREIGN KEY (test_id) REFERENCES tester(id) ON DELETE CASCADE;
alter table public."ansatt_pakker" add constraint "ansatt_pakker_ansatt_id_fkey" FOREIGN KEY (ansatt_id) REFERENCES ansatte(id) ON DELETE CASCADE;
alter table public."ansatt_pakker" add constraint "ansatt_pakker_pakke_id_fkey" FOREIGN KEY (pakke_id) REFERENCES opplaeringspakker(id) ON DELETE CASCADE;
alter table public."ansatt_pakker" add constraint "ansatt_pakker_pkey" PRIMARY KEY (ansatt_id, pakke_id);
alter table public."ansatt_utloper" add constraint "ansatt_utloper_ansatt_id_fkey" FOREIGN KEY (ansatt_id) REFERENCES ansatte(id) ON DELETE CASCADE;
alter table public."ansatt_utloper" add constraint "ansatt_utloper_pkey" PRIMARY KEY (id);
alter table public."ansatte" add constraint "ansatte_ansattnummer_key" UNIQUE (ansattnummer);
alter table public."ansatte" add constraint "ansatte_ansattype_check" CHECK (ansattype = ANY (ARRAY['permanent'::text, 'temporary'::text]));
alter table public."ansatte" add constraint "ansatte_pkey" PRIMARY KEY (id);
alter table public."ansatte" add constraint "ansatte_skip_id_fkey" FOREIGN KEY (skip_id) REFERENCES skip(id) ON DELETE CASCADE;
alter table public."ansatte" add constraint "ansatte_status_check" CHECK (status = ANY (ARRAY['ok'::text, 'warning'::text, 'critical'::text]));
alter table public."brukerroller" add constraint "brukerroller_pkey" PRIMARY KEY (id);
alter table public."brukerroller" add constraint "brukerroller_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
alter table public."brukerroller" add constraint "brukerroller_user_id_rolle_key" UNIQUE (user_id, rolle);
alter table public."dagens_besetning" add constraint "dagens_besetning_ansatt_id_fkey" FOREIGN KEY (ansatt_id) REFERENCES ansatte(id) ON DELETE CASCADE;
alter table public."dagens_besetning" add constraint "dagens_besetning_dato_ansatt_id_key" UNIQUE (dato, ansatt_id);
alter table public."dagens_besetning" add constraint "dagens_besetning_pkey" PRIMARY KEY (id);
alter table public."dagens_besetning" add constraint "dagens_besetning_skip_id_fkey" FOREIGN KEY (skip_id) REFERENCES skip(id) ON DELETE CASCADE;
alter table public."dokumenter" add constraint "dokumenter_ansatt_id_fkey" FOREIGN KEY (ansatt_id) REFERENCES ansatte(id) ON DELETE CASCADE;
alter table public."dokumenter" add constraint "dokumenter_oppgave_id_fkey" FOREIGN KEY (oppgave_id) REFERENCES oppgaver(id) ON DELETE CASCADE;
alter table public."dokumenter" add constraint "dokumenter_pkey" PRIMARY KEY (id);
alter table public."dokumenter" add constraint "dokumenter_prosedyre_id_fkey" FOREIGN KEY (prosedyre_id) REFERENCES prosedyrer(id) ON DELETE CASCADE;
alter table public."dokumenter" add constraint "dokumenter_skip_id_fkey" FOREIGN KEY (skip_id) REFERENCES skip(id) ON DELETE CASCADE;
alter table public."dokumenter" add constraint "dokumenter_test_id_fkey" FOREIGN KEY (test_id) REFERENCES tester(id) ON DELETE CASCADE;
alter table public."fartoy_tilknytning" add constraint "fartoy_tilknytning_ansatt_id_fkey" FOREIGN KEY (ansatt_id) REFERENCES ansatte(id) ON DELETE SET NULL;
alter table public."fartoy_tilknytning" add constraint "fartoy_tilknytning_pkey" PRIMARY KEY (id);
alter table public."fartoy_tilknytning" add constraint "fartoy_tilknytning_skip_id_fkey" FOREIGN KEY (skip_id) REFERENCES skip(id) ON DELETE SET NULL;
alter table public."fartoy_tilknytning" add constraint "fartoy_tilknytning_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
alter table public."felles_testkode_bruk" add constraint "felles_testkode_bruk_ansatt_id_fkey" FOREIGN KEY (ansatt_id) REFERENCES ansatte(id);
alter table public."felles_testkode_bruk" add constraint "felles_testkode_bruk_kode_id_fkey" FOREIGN KEY (kode_id) REFERENCES felles_testkoder(id) ON DELETE CASCADE;
alter table public."felles_testkode_bruk" add constraint "felles_testkode_bruk_pkey" PRIMARY KEY (id);
alter table public."felles_testkoder" add constraint "felles_testkoder_grense" CHECK (antall_brukt >= 0 AND antall_brukt <= maks_bruk AND maks_bruk >= 1 AND maks_bruk <= 5);
alter table public."felles_testkoder" add constraint "felles_testkoder_kode_hash_key" UNIQUE (kode_hash);
alter table public."felles_testkoder" add constraint "felles_testkoder_pkey" PRIMARY KEY (id);
alter table public."felles_testkoder" add constraint "felles_testkoder_skip_id_fkey" FOREIGN KEY (skip_id) REFERENCES skip(id);
alter table public."oppgaver" add constraint "oppgaver_pkey" PRIMARY KEY (id);
alter table public."oppgaver" add constraint "oppgaver_prosedyre_id_fkey" FOREIGN KEY (prosedyre_id) REFERENCES prosedyrer(id) ON DELETE SET NULL;
alter table public."oppgaver" add constraint "oppgaver_skip_id_fkey" FOREIGN KEY (skip_id) REFERENCES skip(id) ON DELETE CASCADE;
alter table public."oppgaver" add constraint "oppgaver_status_check" CHECK (status = ANY (ARRAY['draft'::text, 'active'::text, 'archived'::text]));
alter table public."opplaeringspakker" add constraint "opplaeringspakker_pkey" PRIMARY KEY (id);
alter table public."opplaeringspakker" add constraint "opplaeringspakker_skip_id_fkey" FOREIGN KEY (skip_id) REFERENCES skip(id) ON DELETE CASCADE;
alter table public."opplaeringsplaner" add constraint "opplaeringsplaner_alarmrulle_id_fkey" FOREIGN KEY (alarmrulle_id) REFERENCES alarmruller(id) ON DELETE SET NULL;
alter table public."opplaeringsplaner" add constraint "opplaeringsplaner_ansatt_id_fkey" FOREIGN KEY (ansatt_id) REFERENCES ansatte(id) ON DELETE CASCADE;
alter table public."opplaeringsplaner" add constraint "opplaeringsplaner_pkey" PRIMARY KEY (ansatt_id);
alter table public."pakke_oppgaver" add constraint "pakke_oppgaver_oppgave_id_fkey" FOREIGN KEY (oppgave_id) REFERENCES oppgaver(id) ON DELETE CASCADE;
alter table public."pakke_oppgaver" add constraint "pakke_oppgaver_pakke_id_fkey" FOREIGN KEY (pakke_id) REFERENCES opplaeringspakker(id) ON DELETE CASCADE;
alter table public."pakke_oppgaver" add constraint "pakke_oppgaver_pkey" PRIMARY KEY (pakke_id, oppgave_id);
alter table public."pakke_prosedyrer" add constraint "pakke_prosedyrer_pakke_id_fkey" FOREIGN KEY (pakke_id) REFERENCES opplaeringspakker(id) ON DELETE CASCADE;
alter table public."pakke_prosedyrer" add constraint "pakke_prosedyrer_pkey" PRIMARY KEY (pakke_id, prosedyre_id);
alter table public."pakke_prosedyrer" add constraint "pakke_prosedyrer_prosedyre_id_fkey" FOREIGN KEY (prosedyre_id) REFERENCES prosedyrer(id) ON DELETE CASCADE;
alter table public."pakke_tester" add constraint "pakke_tester_pakke_id_fkey" FOREIGN KEY (pakke_id) REFERENCES opplaeringspakker(id) ON DELETE CASCADE;
alter table public."pakke_tester" add constraint "pakke_tester_pkey" PRIMARY KEY (pakke_id, test_id);
alter table public."pakke_tester" add constraint "pakke_tester_test_id_fkey" FOREIGN KEY (test_id) REFERENCES tester(id) ON DELETE CASCADE;
alter table public."profiler" add constraint "profiler_aktivt_skip_id_fkey" FOREIGN KEY (aktivt_skip_id) REFERENCES skip(id) ON DELETE SET NULL;
alter table public."profiler" add constraint "profiler_ansatt_id_fkey" FOREIGN KEY (ansatt_id) REFERENCES ansatte(id) ON DELETE SET NULL;
alter table public."profiler" add constraint "profiler_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;
alter table public."profiler" add constraint "profiler_pkey" PRIMARY KEY (id);
alter table public."prosedyrer" add constraint "prosedyrer_pkey" PRIMARY KEY (id);
alter table public."prosedyrer" add constraint "prosedyrer_skip_id_fkey" FOREIGN KEY (skip_id) REFERENCES skip(id) ON DELETE CASCADE;
alter table public."prosedyrer" add constraint "prosedyrer_status_check" CHECK (status = ANY (ARRAY['draft'::text, 'active'::text, 'archived'::text]));
alter table public."situasjonsrapporter" add constraint "situasjonsrapporter_ansatt_id_fkey" FOREIGN KEY (ansatt_id) REFERENCES ansatte(id) ON DELETE SET NULL;
alter table public."situasjonsrapporter" add constraint "situasjonsrapporter_pkey" PRIMARY KEY (id);
alter table public."situasjonsrapporter" add constraint "situasjonsrapporter_skip_id_fkey" FOREIGN KEY (skip_id) REFERENCES skip(id) ON DELETE CASCADE;
alter table public."skip" add constraint "skip_pkey" PRIMARY KEY (id);
alter table public."tester" add constraint "tester_pkey" PRIMARY KEY (id);
alter table public."tester" add constraint "tester_skip_id_fkey" FOREIGN KEY (skip_id) REFERENCES skip(id) ON DELETE CASCADE;
alter table public."testresultater" add constraint "testresultater_ansatt_id_fkey" FOREIGN KEY (ansatt_id) REFERENCES ansatte(id) ON DELETE SET NULL;
alter table public."testresultater" add constraint "testresultater_pkey" PRIMARY KEY (id);
alter table public."testresultater" add constraint "testresultater_test_id_fkey" FOREIGN KEY (test_id) REFERENCES tester(id) ON DELETE CASCADE;
alter table public."utstyr" add constraint "utstyr_pkey" PRIMARY KEY (id);
alter table public."utstyr" add constraint "utstyr_skip_id_fkey" FOREIGN KEY (skip_id) REFERENCES skip(id) ON DELETE CASCADE;

-- 4. Additional indexes
CREATE INDEX aktiveringskoder_skip_idx ON public.aktiveringskoder USING btree (skip_id);
CREATE INDEX idx_alarmruller_skip ON public.alarmruller USING btree (skip_id);
CREATE INDEX ansatt_aktivitet_ansatt_idx ON public.ansatt_aktivitet USING btree (ansatt_id);
CREATE INDEX ansatt_opplaering_ansatt_idx ON public.ansatt_opplaering USING btree (ansatt_id);
CREATE INDEX idx_ansatte_skip ON public.ansatte USING btree (skip_id);
CREATE INDEX idx_dagens_besetning_skip ON public.dagens_besetning USING btree (skip_id);
CREATE INDEX idx_dokumenter_skip ON public.dokumenter USING btree (skip_id);
CREATE UNIQUE INDEX fartoy_tilknytning_aktiv_idx ON public.fartoy_tilknytning USING btree (user_id) WHERE (til IS NULL);
CREATE INDEX fartoy_tilknytning_bruker_idx ON public.fartoy_tilknytning USING btree (user_id, til);
CREATE UNIQUE INDEX fartoy_tilknytning_ett_aktivt ON public.fartoy_tilknytning USING btree (user_id) WHERE (til IS NULL);
CREATE INDEX idx_oppgaver_skip ON public.oppgaver USING btree (skip_id);
CREATE INDEX idx_opplaeringspakker_skip ON public.opplaeringspakker USING btree (skip_id);
CREATE INDEX idx_prosedyrer_skip ON public.prosedyrer USING btree (skip_id);
CREATE INDEX idx_situasjonsrapporter_skip ON public.situasjonsrapporter USING btree (skip_id, opprettet DESC);
CREATE UNIQUE INDEX skip_imo_nummer_unik ON public.skip USING btree (imo_nummer);
CREATE INDEX idx_tester_skip ON public.tester USING btree (skip_id);
CREATE INDEX idx_utstyr_skip ON public.utstyr USING btree (skip_id);

-- 5. Application functions
CREATE OR REPLACE FUNCTION public.admin_pa_skip(_user_id uuid, _skip_id text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select _user_id = auth.uid() and public.er_admin(_user_id) and _skip_id is not null and (
    exists (select 1 from public.profiler where id = _user_id and aktivt_skip_id = _skip_id)
    or exists (select 1 from public.fartoy_tilknytning where user_id = _user_id and skip_id = _skip_id and til is null)
  )
$function$
;
CREATE OR REPLACE FUNCTION public.aktivt_skip(_user_id uuid)
 RETURNS text
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select case
    when _user_id = auth.uid() or public.er_admin(auth.uid())
      then (select aktivt_skip_id from public.profiler where id = _user_id)
    else null
  end
$function$
;
CREATE OR REPLACE FUNCTION public.angre_felles_testkode(_id uuid)
 RETURNS void
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  update public.felles_testkoder set antall_brukt = greatest(antall_brukt - 1, 0) where id = _id
$function$
;
CREATE OR REPLACE FUNCTION public.beskytt_ansattfelt()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if current_user in ('postgres', 'service_role', 'supabase_admin')
     or (auth.uid() is not null and public.er_admin(auth.uid())) then
    return new;
  end if;
  new.ansattnummer := old.ansattnummer;
  new.stilling := old.stilling;
  new.beredskapsrolle := old.beredskapsrolle;
  new.avdeling := old.avdeling;
  new.ansattype := old.ansattype;
  new.midlertidig_fra := old.midlertidig_fra;
  new.midlertidig_til := old.midlertidig_til;
  new.aktiv := old.aktiv;
  new.pa_vakt := old.pa_vakt;
  new.skip_id := old.skip_id;
  return new;
end $function$
;
CREATE OR REPLACE FUNCTION public.beskytt_profilfelt()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  betrodd boolean;
begin
  -- Betrodde kilder: serverfunksjoner (service_role), vedlikehold (postgres)
  -- og innloggede ledere. Alle andre får kun endre navn.
  betrodd := current_user in ('postgres', 'service_role', 'supabase_admin')
             or (auth.uid() is not null and public.er_admin(auth.uid()));
  if not betrodd then
    new.ansattnummer := old.ansattnummer;
    new.stilling := old.stilling;
    new.ansatt_id := old.ansatt_id;
    new.aktivt_skip_id := old.aktivt_skip_id;
    new.aktivt_imo := old.aktivt_imo;
    new.epost := old.epost;
  end if;
  if new.aktivt_skip_id is not null then
    select imo_nummer into new.aktivt_imo from public.skip where id = new.aktivt_skip_id;
  else
    new.aktivt_imo := null;
  end if;
  new.sist_endret := now();
  return new;
end $function$
;
CREATE OR REPLACE FUNCTION public.er_admin(_user_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select exists (
    select 1 from public.brukerroller
    where user_id = _user_id and rolle in ('kaptein', 'overstyrmann')
  )
$function$
;
CREATE OR REPLACE FUNCTION public.fjern_rapportbilde(_rapport_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_skip text;
begin
  select skip_id into v_skip from public.situasjonsrapporter where id = _rapport_id;
  if v_skip is null then raise exception 'Fant ikke rapporten.' using errcode = 'P0002'; end if;
  if auth.uid() is null or not public.admin_pa_skip(auth.uid(), v_skip) then
    raise exception 'Kun Kaptein eller Overstyrmann på skipet kan slette rapportbilder.' using errcode = '42501';
  end if;
  perform set_config('larship.fjern_bilde', _rapport_id::text, true);
  update public.situasjonsrapporter set bilde_sti = null where id = _rapport_id;
  perform set_config('larship.fjern_bilde', '', true);
end $function$
;
CREATE OR REPLACE FUNCTION public.fyll_profil_imo()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if new.aktivt_skip_id is not null then
    select imo_nummer into new.aktivt_imo from public.skip where id = new.aktivt_skip_id;
  end if;
  return new;
end $function$
;
CREATE OR REPLACE FUNCTION public.fyll_tilknytning_imo()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if new.skip_id is not null then
    select imo_nummer into new.imo_nummer from public.skip where id = new.skip_id;
  end if;
  if new.imo_nummer is null or new.imo_nummer = '' then
    raise exception 'Fartøystilknytning krever et gyldig IMO-nummer.' using errcode = '23514';
  end if;
  return new;
end $function$
;
CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  forste boolean;
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

  select not exists (select 1 from public.brukerroller) into forste;

  insert into public.brukerroller (user_id, rolle)
  values (new.id, case when forste then 'kaptein'::public.app_role else 'ansatt'::public.app_role end)
  on conflict (user_id, rolle) do nothing;

  return new;
end $function$
;
CREATE OR REPLACE FUNCTION public.har_rolle(_user_id uuid, _rolle app_role)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select exists (select 1 from public.brukerroller where user_id = _user_id and rolle = _rolle)
$function$
;
CREATE OR REPLACE FUNCTION public.kan_lese_skip(_user_id uuid, _skip_id text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select _user_id = auth.uid() and _skip_id is not null and (
    public.er_admin(_user_id)
    or exists (select 1 from public.profiler where id = _user_id and aktivt_skip_id = _skip_id)
    or exists (select 1 from public.fartoy_tilknytning where user_id = _user_id and skip_id = _skip_id and til is null)
  )
$function$
;
CREATE OR REPLACE FUNCTION public.krev_felles_testkode(_hash text)
 RETURNS TABLE(id uuid, skip_id text, nummer integer)
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  update public.felles_testkoder k
     set antall_brukt = k.antall_brukt + 1
   where k.kode_hash = _hash and k.tilbakekalt is null and k.utloper > now() and k.antall_brukt < k.maks_bruk
  returning k.id, k.skip_id, k.antall_brukt
$function$
;
CREATE OR REPLACE FUNCTION public.krev_fodselsdato_ny_ansatt()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'public'
AS $function$
begin
  if new.fodselsdato is null then
    raise exception 'Fødselsdato er påkrevd for nye ansatte.' using errcode = '23502';
  end if;
  return new;
end
$function$
;
CREATE OR REPLACE FUNCTION public.lever_test(_test_id text, _svar jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_ansatt text := public.min_ansatt_id(auth.uid());
  v_test public.tester;
  v_answers jsonb;
  v_total int;
  v_riktig int;
  v_score int;
  v_id text := gen_random_uuid()::text;
  v_navn text;
  v_tid timestamptz := now();
begin
  if auth.uid() is null or v_ansatt is null then
    raise exception 'Ingen ansattprofil er knyttet til brukeren.';
  end if;
  if not public.test_pa_aktivt_skip(_test_id) then
    raise exception 'Testen finnes ikke på aktivt skip.';
  end if;
  select * into v_test from public.tester where id = _test_id;
  select coalesce(jsonb_agg(jsonb_build_object(
      'questionId', q->>'id',
      'optionId', _svar->>(q->>'id'),
      'correct', coalesce(_svar->>(q->>'id') = q->>'correctOptionId', false))), '[]'::jsonb),
    count(*),
    count(*) filter (where _svar->>(q->>'id') = q->>'correctOptionId')
  into v_answers, v_total, v_riktig
  from jsonb_array_elements(v_test.sporsmal) q;
  if v_total = 0 then
    raise exception 'Testen har ingen spørsmål.';
  end if;
  v_score := round(v_riktig * 100.0 / v_total);
  select navn into v_navn from public.ansatte where id = v_ansatt;
  insert into public.testresultater (id, test_id, ansatt_id, ansatt_navn, poengsum, bestatt, fullfort, godkjent_av, svar)
  values (v_id, _test_id, v_ansatt, coalesce(v_navn, ''), v_score, v_score >= v_test.bestattgrense, v_tid, null, v_answers);
  return jsonb_build_object('id', v_id, 'score', v_score, 'passed', v_score >= v_test.bestattgrense,
    'completedAt', v_tid, 'employeeId', v_ansatt, 'employeeName', coalesce(v_navn, ''), 'answers', v_answers);
end;
$function$
;
CREATE OR REPLACE FUNCTION public.min_ansatt_id(_user_id uuid)
 RETURNS text
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select case
    when _user_id = auth.uid() or public.er_admin(auth.uid())
      then coalesce(
        (select ansatt_id from public.fartoy_tilknytning
          where user_id = _user_id and til is null order by fra desc limit 1),
        (select ansatt_id from public.profiler where id = _user_id))
    else null
  end
$function$
;
CREATE OR REPLACE FUNCTION public.pakke_pa_aktivt_skip(_pakke_id text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select exists (
    select 1 from public.opplaeringspakker p
    where p.id = _pakke_id and p.skip_id = public.aktivt_skip(auth.uid())
  )
$function$
;
CREATE OR REPLACE FUNCTION public.sett_sist_endret()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'public'
AS $function$
begin
  new.sist_endret := now();
  return new;
end $function$
;
CREATE OR REPLACE FUNCTION public.situasjonsrapport_fyll()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if tg_op = 'INSERT' then
    if auth.uid() is null then raise exception 'Innlogging kreves.' using errcode = '42501'; end if;
    new.rapportert_av := auth.uid();
    new.skip_id := (select aktivt_skip_id from public.profiler where id = auth.uid());
    if new.skip_id is null then raise exception 'Du er ikke knyttet til et skip.' using errcode = '23514'; end if;
    new.ansatt_id := public.min_ansatt_id(auth.uid());
    new.rapportor_navn := coalesce(
      (select navn from public.ansatte where id = new.ansatt_id),
      (select navn from public.profiler where id = auth.uid()), '');
    new.status := 'ny'; new.behandlet_av := null; new.behandlet_tid := null;
    new.opprettet := now();
    new.bilde_slettet := null; new.bilde_slettet_av := null;
    if length(trim(new.beskrivelse)) = 0 then raise exception 'Beskrivelse må fylles ut.' using errcode = '23514'; end if;
    if new.bilde_sti is not null and new.bilde_sti not like new.skip_id || '/' || auth.uid()::text || '/%' then
      raise exception 'Ugyldig bildesti.' using errcode = '23514';
    end if;
  else
    if new.status not in ('ny','behandlet') then raise exception 'Ugyldig status.' using errcode = '23514'; end if;
    new.id := old.id; new.skip_id := old.skip_id; new.rapportert_av := old.rapportert_av;
    new.ansatt_id := old.ansatt_id; new.rapportor_navn := old.rapportor_navn;
    new.beskrivelse := old.beskrivelse; new.opprettet := old.opprettet;
    -- Bildereferansen kan bare fjernes via fjern_rapportbilde().
    if coalesce(current_setting('larship.fjern_bilde', true), '') = old.id::text then
      new.bilde_sti := null; new.bilde_slettet := now(); new.bilde_slettet_av := auth.uid();
    else
      new.bilde_sti := old.bilde_sti; new.bilde_slettet := old.bilde_slettet; new.bilde_slettet_av := old.bilde_slettet_av;
    end if;
    if new.status = 'behandlet' and old.status <> 'behandlet' then
      new.behandlet_av := auth.uid(); new.behandlet_tid := now();
    elsif new.status = 'ny' then
      new.behandlet_av := null; new.behandlet_tid := null;
    else
      new.behandlet_av := old.behandlet_av; new.behandlet_tid := old.behandlet_tid;
    end if;
  end if;
  return new;
end $function$
;
CREATE OR REPLACE FUNCTION public.test_pa_aktivt_skip(_test_id text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select exists (
    select 1 from public.tester t
    where t.id = _test_id and t.skip_id = public.aktivt_skip(auth.uid())
  )
$function$
;
CREATE OR REPLACE FUNCTION public.tester_uten_fasit(_skip_id text)
 RETURNS SETOF tester
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select t.id, t.testkode, t.tittel, t.beskrivelse, t.antall_sporsmal, t.bestattgrense,
    coalesce((select jsonb_agg(q - 'correctOptionId') from jsonb_array_elements(t.sporsmal) q), '[]'::jsonb),
    t.status, t.opprettet, t.sist_endret, t.skip_id, t.oversettelser
  from public.tester t
  where t.skip_id = _skip_id
    and (public.er_admin(auth.uid()) or t.skip_id = public.aktivt_skip(auth.uid()))
  order by t.testkode
$function$
;
CREATE OR REPLACE FUNCTION public.valider_aktiveringskode()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'public'
AS $function$
begin
  if not exists (select 1 from public.ansatte where id = new.ansatt_id and skip_id = new.skip_id) then
    raise exception 'Aktiveringskoden må gjelde en ansatt på samme fartøy.' using errcode = '23514';
  end if;
  return new;
end $function$
;
CREATE OR REPLACE FUNCTION public.valider_fodselsdato()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'public'
AS $function$
begin
  if new.fodselsdato is not null then
    if new.fodselsdato > current_date then
      raise exception 'Fødselsdato kan ikke være frem i tid.' using errcode = '23514';
    end if;
    if new.fodselsdato < date '1900-01-01' then
      raise exception 'Fødselsdato må være etter 01.01.1900.' using errcode = '23514';
    end if;
  end if;
  if tg_op = 'UPDATE' and old.fodselsdato is not null and new.fodselsdato is null then
    raise exception 'Fødselsdato kan ikke fjernes fra en ansatt.' using errcode = '23514';
  end if;
  return new;
end
$function$
;
CREATE OR REPLACE FUNCTION public.valider_skip()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'public'
AS $function$
begin
  new.imo_nummer := trim(new.imo_nummer);
  if new.imo_nummer !~ '^[0-9]{7}$' then
    raise exception 'IMO-nummer må bestå av nøyaktig 7 siffer.' using errcode = '23514';
  end if;
  return new;
end $function$
;

-- 6. Triggers
CREATE TRIGGER aktiveringskoder_valider BEFORE INSERT OR UPDATE ON aktiveringskoder FOR EACH ROW EXECUTE FUNCTION valider_aktiveringskode();
CREATE TRIGGER ansatte_beskytt_felt BEFORE UPDATE ON ansatte FOR EACH ROW EXECUTE FUNCTION beskytt_ansattfelt();
CREATE TRIGGER ansatte_krev_fodselsdato AFTER INSERT ON ansatte FOR EACH ROW EXECUTE FUNCTION krev_fodselsdato_ny_ansatt();
CREATE TRIGGER ansatte_sist_endret BEFORE UPDATE ON ansatte FOR EACH ROW EXECUTE FUNCTION sett_sist_endret();
CREATE TRIGGER ansatte_valider_fodselsdato BEFORE INSERT OR UPDATE ON ansatte FOR EACH ROW EXECUTE FUNCTION valider_fodselsdato();
CREATE TRIGGER fartoy_tilknytning_fyll_imo BEFORE INSERT OR UPDATE ON fartoy_tilknytning FOR EACH ROW EXECUTE FUNCTION fyll_tilknytning_imo();
CREATE TRIGGER oppgaver_sist_endret BEFORE UPDATE ON oppgaver FOR EACH ROW EXECUTE FUNCTION sett_sist_endret();
CREATE TRIGGER profiler_beskytt_felt BEFORE UPDATE ON profiler FOR EACH ROW EXECUTE FUNCTION beskytt_profilfelt();
CREATE TRIGGER profiler_fyll_imo BEFORE INSERT ON profiler FOR EACH ROW EXECUTE FUNCTION fyll_profil_imo();
CREATE TRIGGER prosedyrer_sist_endret BEFORE UPDATE ON prosedyrer FOR EACH ROW EXECUTE FUNCTION sett_sist_endret();
CREATE TRIGGER situasjonsrapporter_fyll BEFORE INSERT OR UPDATE ON situasjonsrapporter FOR EACH ROW EXECUTE FUNCTION situasjonsrapport_fyll();
CREATE TRIGGER skip_sist_endret BEFORE UPDATE ON skip FOR EACH ROW EXECUTE FUNCTION sett_sist_endret();
CREATE TRIGGER skip_valider BEFORE INSERT OR UPDATE ON skip FOR EACH ROW EXECUTE FUNCTION valider_skip();
CREATE TRIGGER tester_sist_endret BEFORE UPDATE ON tester FOR EACH ROW EXECUTE FUNCTION sett_sist_endret();

-- 7. Enable row-level security
alter table public."aktiveringskoder" enable row level security;
alter table public."alarmruller" enable row level security;
alter table public."ansatt_aktivitet" enable row level security;
alter table public."ansatt_opplaering" enable row level security;
alter table public."ansatt_pakker" enable row level security;
alter table public."ansatt_utloper" enable row level security;
alter table public."ansatte" enable row level security;
alter table public."brukerroller" enable row level security;
alter table public."dagens_besetning" enable row level security;
alter table public."dokumenter" enable row level security;
alter table public."fartoy_tilknytning" enable row level security;
alter table public."felles_testkode_bruk" enable row level security;
alter table public."felles_testkoder" enable row level security;
alter table public."oppgaver" enable row level security;
alter table public."opplaeringspakker" enable row level security;
alter table public."opplaeringsplaner" enable row level security;
alter table public."pakke_oppgaver" enable row level security;
alter table public."pakke_prosedyrer" enable row level security;
alter table public."pakke_tester" enable row level security;
alter table public."profiler" enable row level security;
alter table public."prosedyrer" enable row level security;
alter table public."situasjonsrapporter" enable row level security;
alter table public."skip" enable row level security;
alter table public."tester" enable row level security;
alter table public."testresultater" enable row level security;
alter table public."utstyr" enable row level security;

-- 8. Row-level security policies
create policy "Leder ser aktiveringskoder" on "public"."aktiveringskoder" as permissive for select to "authenticated" using (er_admin(auth.uid()));
create policy "Leder tilbakekaller aktiveringskoder" on "public"."aktiveringskoder" as permissive for update to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Bibliotek leses paa eget fartoy" on "public"."alarmruller" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR (skip_id = aktivt_skip(auth.uid()))));
create policy "Leder styrer bibliotek" on "public"."alarmruller" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Ansatt skriver egen aktivitet" on "public"."ansatt_aktivitet" as permissive for insert to "authenticated" with check ((ansatt_id = min_ansatt_id(auth.uid())));
create policy "Egne rader leses" on "public"."ansatt_aktivitet" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR (ansatt_id = min_ansatt_id(auth.uid()))));
create policy "Leder styrer rader" on "public"."ansatt_aktivitet" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Ansatt oppdaterer egen opplaering" on "public"."ansatt_opplaering" as permissive for update to "authenticated" using ((ansatt_id = min_ansatt_id(auth.uid()))) with check ((ansatt_id = min_ansatt_id(auth.uid())));
create policy "Ansatt registrerer egen opplaering" on "public"."ansatt_opplaering" as permissive for insert to "authenticated" with check ((ansatt_id = min_ansatt_id(auth.uid())));
create policy "Ansatt sletter egen opplaering" on "public"."ansatt_opplaering" as permissive for delete to "authenticated" using ((ansatt_id = min_ansatt_id(auth.uid())));
create policy "Egne rader leses" on "public"."ansatt_opplaering" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR (ansatt_id = min_ansatt_id(auth.uid()))));
create policy "Leder styrer rader" on "public"."ansatt_opplaering" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Egne rader leses" on "public"."ansatt_pakker" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR (ansatt_id = min_ansatt_id(auth.uid()))));
create policy "Leder styrer rader" on "public"."ansatt_pakker" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Egne rader leses" on "public"."ansatt_utloper" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR (ansatt_id = min_ansatt_id(auth.uid()))));
create policy "Leder styrer rader" on "public"."ansatt_utloper" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Ansatt oppdaterer egen framdrift" on "public"."ansatte" as permissive for update to "authenticated" using ((id = min_ansatt_id(auth.uid()))) with check ((id = min_ansatt_id(auth.uid())));
create policy "Leder ser ansatte paa fartoyet" on "public"."ansatte" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR (id = min_ansatt_id(auth.uid()))));
create policy "Leder styrer ansatte" on "public"."ansatte" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Egne roller leses" on "public"."brukerroller" as permissive for select to "authenticated" using (((user_id = auth.uid()) OR er_admin(auth.uid())));
create policy "Leder styrer roller" on "public"."brukerroller" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Bibliotek leses paa eget fartoy" on "public"."dagens_besetning" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR (skip_id = aktivt_skip(auth.uid()))));
create policy "Leder styrer bibliotek" on "public"."dagens_besetning" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Dokumenter leses" on "public"."dokumenter" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR (ansatt_id = min_ansatt_id(auth.uid())) OR ((ansatt_id IS NULL) AND (skip_id = aktivt_skip(auth.uid())))));
create policy "Leder styrer dokumenter" on "public"."dokumenter" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Egen tilknytning leses" on "public"."fartoy_tilknytning" as permissive for select to "authenticated" using (((user_id = auth.uid()) OR er_admin(auth.uid())));
create policy "Leder styrer tilknytning" on "public"."fartoy_tilknytning" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Leder ser bruk av testkoder" on "public"."felles_testkode_bruk" as permissive for select to "authenticated" using (er_admin(auth.uid()));
create policy "Leder ser felles testkoder" on "public"."felles_testkoder" as permissive for select to "authenticated" using (er_admin(auth.uid()));
create policy "Leder tilbakekaller felles testkoder" on "public"."felles_testkoder" as permissive for update to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Bibliotek leses paa eget fartoy" on "public"."oppgaver" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR (skip_id = aktivt_skip(auth.uid()))));
create policy "Leder styrer bibliotek" on "public"."oppgaver" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Bibliotek leses paa eget fartoy" on "public"."opplaeringspakker" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR (skip_id = aktivt_skip(auth.uid()))));
create policy "Leder styrer bibliotek" on "public"."opplaeringspakker" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Egne rader leses" on "public"."opplaeringsplaner" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR (ansatt_id = min_ansatt_id(auth.uid()))));
create policy "Leder styrer rader" on "public"."opplaeringsplaner" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Koblinger leses" on "public"."pakke_oppgaver" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR pakke_pa_aktivt_skip(pakke_id)));
create policy "Leder styrer koblinger" on "public"."pakke_oppgaver" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Koblinger leses" on "public"."pakke_prosedyrer" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR pakke_pa_aktivt_skip(pakke_id)));
create policy "Leder styrer koblinger" on "public"."pakke_prosedyrer" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Koblinger leses" on "public"."pakke_tester" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR pakke_pa_aktivt_skip(pakke_id)));
create policy "Leder styrer koblinger" on "public"."pakke_tester" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Egen profil leses" on "public"."profiler" as permissive for select to "authenticated" using (((id = auth.uid()) OR er_admin(auth.uid())));
create policy "Egen profil oppdateres" on "public"."profiler" as permissive for update to "authenticated" using (((id = auth.uid()) OR er_admin(auth.uid()))) with check (((id = auth.uid()) OR er_admin(auth.uid())));
create policy "Leder oppretter profil" on "public"."profiler" as permissive for insert to "authenticated" with check (er_admin(auth.uid()));
create policy "Bibliotek leses paa eget fartoy" on "public"."prosedyrer" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR (skip_id = aktivt_skip(auth.uid()))));
create policy "Leder styrer bibliotek" on "public"."prosedyrer" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Ansatt sender rapport" on "public"."situasjonsrapporter" as permissive for insert to "authenticated" with check ((auth.uid() IS NOT NULL));
create policy "Egne rapporter leses" on "public"."situasjonsrapporter" as permissive for select to "authenticated" using (((rapportert_av = auth.uid()) OR admin_pa_skip(auth.uid(), skip_id)));
create policy "Leder behandler rapport" on "public"."situasjonsrapporter" as permissive for update to "authenticated" using (admin_pa_skip(auth.uid(), skip_id)) with check (admin_pa_skip(auth.uid(), skip_id));
create policy "Fartoy leses av tilknyttet bruker" on "public"."skip" as permissive for select to "authenticated" using (kan_lese_skip(auth.uid(), id));
create policy "Leder styrer fartoy" on "public"."skip" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Leder styrer bibliotek" on "public"."tester" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Tester leses av admin" on "public"."tester" as permissive for select to "authenticated" using (er_admin(auth.uid()));
create policy "Leder styrer testresultater" on "public"."testresultater" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Testresultater leses" on "public"."testresultater" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR ((ansatt_id = min_ansatt_id(auth.uid())) AND test_pa_aktivt_skip(test_id))));
create policy "Bibliotek leses paa eget fartoy" on "public"."utstyr" as permissive for select to "authenticated" using ((er_admin(auth.uid()) OR (skip_id = aktivt_skip(auth.uid()))));
create policy "Leder styrer bibliotek" on "public"."utstyr" as permissive for all to "authenticated" using (er_admin(auth.uid())) with check (er_admin(auth.uid()));
create policy "Dokumenter admin endrer" on "storage"."objects" as permissive for update to "authenticated" using (((bucket_id = 'dokumenter'::text) AND er_admin(auth.uid())));
create policy "Dokumenter admin laster opp" on "storage"."objects" as permissive for insert to "authenticated" with check (((bucket_id = 'dokumenter'::text) AND admin_pa_skip(auth.uid(), (storage.foldername(name))[1])));
create policy "Dokumenter admin sletter" on "storage"."objects" as permissive for delete to "authenticated" using (((bucket_id = 'dokumenter'::text) AND admin_pa_skip(auth.uid(), (storage.foldername(name))[1])));
create policy "Dokumenter lese eget skip" on "storage"."objects" as permissive for select to "authenticated" using (((bucket_id = 'dokumenter'::text) AND (((storage.foldername(name))[1] = aktivt_skip(auth.uid())) OR er_admin(auth.uid()))));
create policy "Situasjonsbilder lastes opp" on "storage"."objects" as permissive for insert to "authenticated" with check (((bucket_id = 'situasjonsbilder'::text) AND ((storage.foldername(name))[1] = aktivt_skip(auth.uid())) AND ((storage.foldername(name))[2] = (auth.uid())::text)));
create policy "Situasjonsbilder leses" on "storage"."objects" as permissive for select to "authenticated" using (((bucket_id = 'situasjonsbilder'::text) AND (((storage.foldername(name))[2] = (auth.uid())::text) OR admin_pa_skip(auth.uid(), (storage.foldername(name))[1]))));

-- 9. Storage buckets (private by design)
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types) values ('dokumenter','dokumenter',false,209715200,null) on conflict (id) do update set name=excluded.name, public=excluded.public, file_size_limit=excluded.file_size_limit, allowed_mime_types=excluded.allowed_mime_types;
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types) values ('situasjonsbilder','situasjonsbilder',false,15728640,null) on conflict (id) do update set name=excluded.name, public=excluded.public, file_size_limit=excluded.file_size_limit, allowed_mime_types=excluded.allowed_mime_types;

-- 10. Table grants. RLS remains the row-level gate.
grant usage on schema public to authenticated, service_role;
grant select, insert, update, delete on all tables in schema public to authenticated, service_role;
grant all on all tables in schema public to service_role;

commit;

-- END. Run verification queries after application; do not seed the first Captain account until bootstrap is secured.