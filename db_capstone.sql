--
-- PostgreSQL database dump
--

\restrict BAwRJrRlzfxSTrXYPqHDnVcPoaGjAJFLNOoBEaHy0TlayZccLY8HVsYlszILZ1O

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg13+1)
-- Dumped by pg_dump version 16.14 (Ubuntu 16.14-0ubuntu0.24.04.1)

-- Started on 2026-06-28 14:52:55 WIB

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 26502)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 872 (class 1247 OID 33670)
-- Name: ItemCategory; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ItemCategory" AS ENUM (
    'AVATAR',
    'FRAME',
    'STICKER',
    'THEME'
);


ALTER TYPE public."ItemCategory" OWNER TO postgres;

--
-- TOC entry 875 (class 1247 OID 33680)
-- Name: ItemRarity; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ItemRarity" AS ENUM (
    'COMMON',
    'RARE',
    'EPIC',
    'LEGENDARY'
);


ALTER TYPE public."ItemRarity" OWNER TO postgres;

--
-- TOC entry 890 (class 1247 OID 34555)
-- Name: LeaderboardPeriod; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."LeaderboardPeriod" AS ENUM (
    'WEEKLY',
    'MONTHLY',
    'SEASONAL',
    'ALL_TIME'
);


ALTER TYPE public."LeaderboardPeriod" OWNER TO postgres;

--
-- TOC entry 854 (class 1247 OID 26515)
-- Name: Role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."Role" AS ENUM (
    'USER',
    'ADMIN'
);


ALTER TYPE public."Role" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 26503)
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 26537)
-- Name: animals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animals (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "thumbnailUrl" text,
    "hintImageUrl" text,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    difficulty text DEFAULT 'easy'::text NOT NULL,
    "drawingTips" text[],
    "funFact" text,
    "traceImageUrl" text
);


ALTER TABLE public.animals OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 26563)
-- Name: game_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.game_sessions (
    id text NOT NULL,
    "userId" text NOT NULL,
    "animalId" text NOT NULL,
    "modelId" text NOT NULL,
    "predictionLabel" text NOT NULL,
    "confidenceScore" double precision NOT NULL,
    "gameScore" integer NOT NULL,
    "focusScore" double precision,
    "drawingDuration" integer NOT NULL,
    "startedAt" timestamp(3) without time zone NOT NULL,
    "finishedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "imageUrl" text
);


ALTER TABLE public.game_sessions OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 34563)
-- Name: leaderboard_snapshots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leaderboard_snapshots (
    id text NOT NULL,
    period public."LeaderboardPeriod" NOT NULL,
    "periodLabel" text NOT NULL,
    rankings jsonb NOT NULL,
    "generatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.leaderboard_snapshots OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 37285)
-- Name: learning_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.learning_profiles (
    id text NOT NULL,
    "userId" text NOT NULL,
    "animalId" text NOT NULL,
    "attemptCount" integer DEFAULT 0 NOT NULL,
    "avgScore" double precision DEFAULT 0.0 NOT NULL,
    "avgConfidence" double precision DEFAULT 0.0 NOT NULL,
    "lastPlayedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.learning_profiles OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 26546)
-- Name: ml_models; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ml_models (
    id text NOT NULL,
    name text NOT NULL,
    version text NOT NULL,
    "fileUrl" text NOT NULL,
    "labelsUrl" text,
    "inputSize" integer,
    framework text,
    accuracy double precision,
    "isActive" boolean DEFAULT true NOT NULL,
    "firebaseModelName" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "activatedAt" timestamp(3) without time zone
);


ALTER TABLE public.ml_models OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 33707)
-- Name: purchase_histories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_histories (
    id text NOT NULL,
    "userId" text NOT NULL,
    "itemId" text NOT NULL,
    price integer NOT NULL,
    "purchasedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.purchase_histories OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 26529)
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_tokens (
    id text NOT NULL,
    token text NOT NULL,
    "userId" text NOT NULL,
    "expiresAt" timestamp(3) without time zone NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.refresh_tokens OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 33689)
-- Name: shop_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shop_items (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "imageUrl" text,
    price integer NOT NULL,
    category public."ItemCategory" NOT NULL,
    rarity public."ItemRarity" NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.shop_items OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 33698)
-- Name: user_inventories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_inventories (
    id text NOT NULL,
    "userId" text NOT NULL,
    "itemId" text NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    "acquiredAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.user_inventories OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 34090)
-- Name: user_statistics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_statistics (
    "userId" text NOT NULL,
    "totalGames" integer DEFAULT 0 NOT NULL,
    "totalScore" integer DEFAULT 0 NOT NULL,
    "highestScore" integer DEFAULT 0 NOT NULL,
    "averageFocus" double precision DEFAULT 0.0 NOT NULL,
    "totalDrawingTime" integer DEFAULT 0 NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.user_statistics OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 26519)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id text NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    "passwordHash" text NOT NULL,
    "displayName" text,
    "avatarUrl" text,
    "totalPoint" integer DEFAULT 0 NOT NULL,
    role public."Role" DEFAULT 'USER'::public."Role" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "equippedAvatarId" text,
    "equippedFrameId" text,
    "equippedThemeId" text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 3541 (class 0 OID 26503)
-- Dependencies: 215
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
64814b49-f6da-4453-9a8d-bad15d50500c	a4db433ab7fd95b8d4fc4b589e384bfe740290698f8d31e6865c086fd6203140	2026-06-11 07:50:29.511521+00	20260611075029_init	\N	\N	2026-06-11 07:50:29.458077+00	1
f8928668-e016-461b-bb39-e140e564bebb	be13dd80660e31886b7223f59fc654cd9f756c140fea4d060e606575dd52f9bb	2026-06-18 03:39:22.358201+00	20260618033922_reward_system	\N	\N	2026-06-18 03:39:22.3121+00	1
f3d3e111-ad21-4d1c-9a0d-8649e8dd1bab	533de36fd822757d052c24e4f51667f42cc8b90d98ff607eb29c402b9dd35705	2026-06-18 04:16:54.544425+00	20260618041654_progress_system	\N	\N	2026-06-18 04:16:54.517922+00	1
4ed79342-20e7-4321-b9c7-e93967813233	a0aaff07406bb6a91fdc18394299a88742949d4eaa00873fa7338843ddcf2202	2026-06-18 04:27:09.275413+00	20260618042709_competitive_features	\N	\N	2026-06-18 04:27:09.243573+00	1
8ce5f828-12e2-42b1-8976-7da91608d728	dfcba42f5f3747907bb0203649450738226803c50b20a40461f8fd2d1ac7344c	2026-06-18 04:35:01.191023+00	20260618043501_remove_daily_challenge	\N	\N	2026-06-18 04:35:01.178249+00	1
4eef1631-0178-4393-b0b4-e6aa9639b57b	d08cad253f15b19bc0a2c3b99c59da0fe32e5bcd63911e8d23199b6d895f2323	2026-06-21 21:05:25.230048+00	20260621210525_add_user_statistic_index	\N	\N	2026-06-21 21:05:25.220202+00	1
a36772f2-6a47-4793-a936-50efd1deb527	e4c5dd25b044ba7a274cb358112f49d205fcb07ec7d202f13d2c0921e4b1726e	2026-06-21 21:13:35.727272+00	20260621211335_add_mlmodel_activated_at	\N	\N	2026-06-21 21:13:35.71637+00	1
87cd7c73-5b8f-4d2d-a4ab-557282ad3ba3	05981934e360201671bb0e3de5c5446d370adc7e4fec396d0ec4acead4052375	2026-06-21 21:15:35.059307+00	20260621211534_adaptive_learning	\N	\N	2026-06-21 21:15:34.90728+00	1
3eda30cd-ae9f-4192-8bc8-64e72c10f144	e912b117d10cc3886be3ea1d1dd25be65129a5599b8c03a72f54a777414f5243	2026-06-22 01:03:21.474857+00	20260622010321_add_game_session_image_url	\N	\N	2026-06-22 01:03:21.467135+00	1
d5df6d43-4e92-490b-bf29-86aa8464a2b4	cbc86e4c404c56e1099dc1742ce35fbbc9d479c548f4abbb52a4823e28cf818a	2026-06-22 11:08:58.717788+00	20260622110858_remove_achievement_feature	\N	\N	2026-06-22 11:08:58.695212+00	1
\.


--
-- TOC entry 3544 (class 0 OID 26537)
-- Dependencies: 218
-- Data for Name: animals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animals (id, name, description, "thumbnailUrl", "hintImageUrl", "isActive", "createdAt", "updatedAt", difficulty, "drawingTips", "funFact", "traceImageUrl") FROM stdin;
5077022a-162a-4f8d-b448-25227222771f	Bird	A warm-blooded egg-laying vertebrate distinguished by the possession of feathers, wings, and a beak.	\N	\N	f	2026-06-11 07:53:22.145	2026-06-15 06:39:58.807	easy	\N	\N	\N
2e052356-d6af-4893-9c1f-7ed7c03fdc88	Elephant	A heavy plant-eating mammal with a prehensile trunk.	\N	\N	f	2026-06-11 07:53:22.142	2026-06-15 06:40:02.643	easy	\N	\N	\N
98125074-82f0-48d5-866b-cfe5b9bdbbe9	Dog	A domesticated carnivorous mammal that typically has a long snout.	\N	\N	f	2026-06-11 07:53:22.14	2026-06-15 06:40:05.339	easy	\N	\N	\N
4618366c-a7eb-45d1-8ce8-e272eb02adae	Cat	A small domesticated carnivorous mammal with soft fur.	\N	\N	f	2026-06-11 07:53:22.137	2026-06-15 06:40:07.679	easy	\N	\N	\N
46bc3dc4-f27a-4dfb-a4b9-225795d0cec2	Burung Hantu	Burung nokturnal dengan mata tajam yang dapat memutar lehernya hingga 270 derajat.	\N	\N	f	2026-06-27 10:27:30.392	2026-06-27 10:29:04.172	easy	\N	\N	\N
14622a97-8e5d-4b21-a345-6525e7749940	Singa	Kucing besar yang dijuluki sebagai raja hutan dengan surai yang gagah.	\N	\N	f	2026-06-27 10:27:30.385	2026-06-27 10:29:06.953	easy	\N	\N	\N
7eacb633-0ada-4f5c-ae9b-6c760cbaf957	Gajah	Mamalia darat terbesar dengan belalai panjang dan gading yang khas.	\N	\N	f	2026-06-27 10:27:30.374	2026-06-27 10:29:12.461	easy	\N	\N	\N
38a9cbfd-94b1-47b3-bda4-1f7dfb52f469	Sapi	Hewan ternak herbivora penghasil susu dan daging.	https://capstone-image.furqonaugust.site/animals/thumbnails/38a9cbfd-94b1-47b3-bda4-1f7dfb52f469.png	https://capstone-image.furqonaugust.site/animals/hints/38a9cbfd-94b1-47b3-bda4-1f7dfb52f469.png	t	2026-06-15 06:34:19.352	2026-06-27 19:28:49.762	medium	{"Gambar bentuk kotak atau persegi panjang tumpul untuk badannya.","Tambahkan corak belang-belang asimetris khas sapi perah.","Jangan lupa gambar moncong hidung yang besar dan ekor dengan ujung berbulu."}	Sapi memiliki memori yang sangat baik dan bisa mengingat teman-teman mereka.	https://capstone-image.furqonaugust.site/animals/traces/38a9cbfd-94b1-47b3-bda4-1f7dfb52f469.png
ad310098-39fc-4010-b50f-37eb1104be60	Bebek	Unggas air berkaki selaput yang pandai berenang.	https://capstone-image.furqonaugust.site/animals/thumbnails/ad310098-39fc-4010-b50f-37eb1104be60.png	https://capstone-image.furqonaugust.site/animals/hints/ad310098-39fc-4010-b50f-37eb1104be60.png	t	2026-06-15 06:34:19.355	2026-06-27 19:31:33.34	easy	{"Bentuk dasar bebek menyerupai angka dua (2).","Gambarkan paruh yang pipih dan memanjang ke depan.","Buat kakinya berselaput dengan bentuk tiga jari menyatu."}	Bulu bebek dilapisi minyak khusus yang membuatnya tahan air.	https://capstone-image.furqonaugust.site/animals/traces/ad310098-39fc-4010-b50f-37eb1104be60.png
6a603e7a-12df-4e4e-a59d-00db6e5768db	Lumba-lumba	Mamalia laut yang sangat cerdas dan ramah.	https://capstone-image.furqonaugust.site/animals/thumbnails/6a603e7a-12df-4e4e-a59d-00db6e5768db.png	https://capstone-image.furqonaugust.site/animals/hints/6a603e7a-12df-4e4e-a59d-00db6e5768db.png	t	2026-06-15 06:34:19.362	2026-06-27 18:26:19.196	medium	{"Gunakan bentuk melengkung seperti pisang untuk badannya.","Buat sirip punggung melengkung dan paruh hidung yang sedikit menonjol.","Gambar garis mulut yang terlihat seperti selalu tersenyum."}	Lumba-lumba berkomunikasi satu sama lain menggunakan siulan yang unik.	https://capstone-image.furqonaugust.site/animals/traces/6a603e7a-12df-4e4e-a59d-00db6e5768db.png
d19f7812-d39c-4902-9ed2-51c055cb4667	Kucing	Kucing peliharaan dengan bulu yang lembut.	https://capstone-image.furqonaugust.site/animals/thumbnails/d19f7812-d39c-4902-9ed2-51c055cb4667.png	https://capstone-image.furqonaugust.site/animals/hints/d19f7812-d39c-4902-9ed2-51c055cb4667.png	t	2026-06-15 06:34:19.343	2026-06-27 18:26:27.155	easy	{"Mulai dengan bentuk lingkaran untuk kepala dan oval untuk badan.","Gunakan dua segitiga kecil untuk telinga di atas kepala.","Tambahkan kumis panjang di area pipi agar terlihat lebih nyata."}	Kucing menghabiskan sekitar 70% dari hidupnya untuk tidur.	https://capstone-image.furqonaugust.site/animals/traces/d19f7812-d39c-4902-9ed2-51c055cb4667.png
371e809c-8d06-49d2-b2f5-96bb7c024460	Ikan	Hewan air yang bernapas menggunakan insang.	https://capstone-image.furqonaugust.site/animals/thumbnails/371e809c-8d06-49d2-b2f5-96bb7c024460.png	https://capstone-image.furqonaugust.site/animals/hints/371e809c-8d06-49d2-b2f5-96bb7c024460.png	t	2026-06-15 06:34:19.358	2026-06-27 19:01:04.336	easy	{"Buat bentuk oval memanjang untuk badan utamanya.","Tambahkan sirip segitiga di punggung, bawah badan, dan ekor.","Gambarkan sisik menggunakan garis-garis melengkung (seperti huruf C)."}	Beberapa spesies ikan mas bisa hidup hingga puluhan tahun.	https://capstone-image.furqonaugust.site/animals/traces/371e809c-8d06-49d2-b2f5-96bb7c024460.png
\.


--
-- TOC entry 3546 (class 0 OID 26563)
-- Dependencies: 220
-- Data for Name: game_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.game_sessions (id, "userId", "animalId", "modelId", "predictionLabel", "confidenceScore", "gameScore", "focusScore", "drawingDuration", "startedAt", "finishedAt", "createdAt", "imageUrl") FROM stdin;
a1fb0dbd-49ac-4495-89a4-ec7413f455e3	a0319560-3ed4-4e39-a355-ab368c50fbd7	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.9454694214088528	63	0.8703554356963434	72	2026-06-07 06:40:52.015	2026-06-07 06:41:52.015	2026-06-07 06:41:52.015	\N
17eddc74-9771-42f1-b786-ff0ffb7c8ee7	62959381-bc0b-4dfe-a410-280f5d56fb71	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.7317892739488813	68	0.7702852335130035	40	2026-06-07 07:38:52.02	2026-06-07 07:39:52.02	2026-06-07 07:39:52.02	\N
9d97b788-20ef-4f45-944e-aa2054c9a3da	cc72551f-9f88-4141-9efe-518d3aab4d01	4618366c-a7eb-45d1-8ce8-e272eb02adae	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Cat	0.7392664019856382	88	0.5598403188378175	56	2026-06-07 22:15:52.022	2026-06-07 22:16:52.022	2026-06-07 22:16:52.022	\N
ae0c63d0-f502-46d7-8cd1-d37b9054b2f7	62959381-bc0b-4dfe-a410-280f5d56fb71	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.8723230195676472	92	0.5527145497197545	52	2026-06-07 05:32:52.025	2026-06-07 05:33:52.025	2026-06-07 05:33:52.025	\N
bb9bd906-07fb-4498-ae36-b3875ac5a3bd	d2678738-0c2a-4243-8100-e63a95c86a9b	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.8660021552491626	95	0.8925302350708331	37	2026-06-09 01:25:52.027	2026-06-09 01:26:52.027	2026-06-09 01:26:52.027	\N
9fcd12b0-3979-4011-a826-01e950cc1c78	a0319560-3ed4-4e39-a355-ab368c50fbd7	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.8156841378156829	90	0.5997704514199804	70	2026-06-07 23:56:52.029	2026-06-07 23:57:52.029	2026-06-07 23:57:52.029	\N
da0408ba-4971-4aba-85a0-cf23fc3b94ab	a22e7f9f-4421-4040-a1fd-c892712b9bcb	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.850288687051598	57	0.8277925925992913	51	2026-06-05 22:39:52.03	2026-06-05 22:40:52.03	2026-06-05 22:40:52.03	\N
fea96264-7db2-44c8-8fbc-abf3fd784f8a	cc72551f-9f88-4141-9efe-518d3aab4d01	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.7426337304512858	90	0.5628970687322992	69	2026-06-09 19:24:52.032	2026-06-09 19:25:52.032	2026-06-09 19:25:52.032	\N
3717558a-1193-41cd-99c0-8a8c35bb0c0b	a0319560-3ed4-4e39-a355-ab368c50fbd7	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.8902306752388291	59	0.9088416310307765	73	2026-06-11 09:28:52.033	2026-06-11 09:29:52.033	2026-06-11 09:29:52.033	\N
9cd1aaa6-ee28-4488-8311-5c2f22e2bc06	cc72551f-9f88-4141-9efe-518d3aab4d01	4618366c-a7eb-45d1-8ce8-e272eb02adae	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Cat	0.9229171002609947	79	0.6153477061031566	25	2026-06-11 09:03:52.035	2026-06-11 09:04:52.035	2026-06-11 09:04:52.035	\N
d53556f5-e274-4952-91a7-2249e7f281ee	d2678738-0c2a-4243-8100-e63a95c86a9b	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.9237342871884058	73	0.9367816690477777	19	2026-06-11 09:26:52.037	2026-06-11 09:27:52.037	2026-06-11 09:27:52.037	\N
887187c5-1c45-4936-a434-d130f93bb6b7	a22e7f9f-4421-4040-a1fd-c892712b9bcb	98125074-82f0-48d5-866b-cfe5b9bdbbe9	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Dog	0.795570395546036	70	0.853295066138269	21	2026-06-04 22:11:52.038	2026-06-04 22:12:52.038	2026-06-04 22:12:52.038	\N
b4688ee2-ab10-4ccf-8374-24f8f281eb90	cc72551f-9f88-4141-9efe-518d3aab4d01	98125074-82f0-48d5-866b-cfe5b9bdbbe9	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Dog	0.8259188266483296	82	0.5805891792360709	38	2026-06-04 23:53:52.04	2026-06-04 23:54:52.04	2026-06-04 23:54:52.04	\N
2a5de4bc-903f-4b2a-81dd-59eb505a7369	a0319560-3ed4-4e39-a355-ab368c50fbd7	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.9409646185690375	74	0.5797478281731574	29	2026-06-08 11:16:52.041	2026-06-08 11:17:52.041	2026-06-08 11:17:52.041	\N
aa064f40-bff2-4174-8399-e16173675bd0	d2678738-0c2a-4243-8100-e63a95c86a9b	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.9721389123694385	80	0.5326069229060626	40	2026-06-09 21:22:52.042	2026-06-09 21:23:52.042	2026-06-09 21:23:52.042	\N
2276ed44-140d-409c-9e3f-2e74253ff7d8	a0319560-3ed4-4e39-a355-ab368c50fbd7	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.9928315280671914	80	0.5687054552909248	55	2026-06-09 14:06:52.044	2026-06-09 14:07:52.044	2026-06-09 14:07:52.044	\N
edb887b1-b5a5-4c5e-8a51-97ebb2ec935d	a22e7f9f-4421-4040-a1fd-c892712b9bcb	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.8671930327581465	72	0.6898022133055665	47	2026-06-09 07:10:52.045	2026-06-09 07:11:52.045	2026-06-09 07:11:52.045	\N
55fb61d6-86fa-4032-9314-92ab0b2873ff	d2678738-0c2a-4243-8100-e63a95c86a9b	98125074-82f0-48d5-866b-cfe5b9bdbbe9	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Dog	0.9241309377995295	85	0.5986784865961776	46	2026-06-09 06:09:52.046	2026-06-09 06:10:52.046	2026-06-09 06:10:52.046	\N
6d7c9ac4-f6d5-4ee5-9b38-e953a1393d03	a22e7f9f-4421-4040-a1fd-c892712b9bcb	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.7619545632646336	67	0.9951943609060909	37	2026-06-10 09:34:52.048	2026-06-10 09:35:52.048	2026-06-10 09:35:52.048	\N
f4848f88-14ad-443e-8698-2baf09385dbe	a0319560-3ed4-4e39-a355-ab368c50fbd7	98125074-82f0-48d5-866b-cfe5b9bdbbe9	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Dog	0.8371061882522196	64	0.8182568839885018	29	2026-06-05 01:52:52.05	2026-06-05 01:53:52.05	2026-06-05 01:53:52.05	\N
8c5f62c3-45b3-4f76-b6b1-f4f0ef9787f2	62959381-bc0b-4dfe-a410-280f5d56fb71	4618366c-a7eb-45d1-8ce8-e272eb02adae	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Cat	0.6581307191527904	95	0.5671688245504474	15	2026-06-07 19:41:52.051	2026-06-07 19:42:52.051	2026-06-07 19:42:52.051	\N
659d8167-77cd-4511-8cb6-9682c7ad4442	62959381-bc0b-4dfe-a410-280f5d56fb71	4618366c-a7eb-45d1-8ce8-e272eb02adae	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Cat	0.9845692371559874	65	0.6279255731028615	58	2026-06-11 03:56:52.053	2026-06-11 03:57:52.053	2026-06-11 03:57:52.053	\N
308725f9-bfcf-4674-8d43-8885b379612c	62959381-bc0b-4dfe-a410-280f5d56fb71	98125074-82f0-48d5-866b-cfe5b9bdbbe9	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Dog	0.677281938541801	65	0.9404400356680473	15	2026-06-09 16:28:52.055	2026-06-09 16:29:52.055	2026-06-09 16:29:52.055	\N
f8275d68-7e70-4358-bb64-66dcf4891af6	a22e7f9f-4421-4040-a1fd-c892712b9bcb	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.8903188165927296	70	0.999056227922011	45	2026-06-06 21:16:52.056	2026-06-06 21:17:52.056	2026-06-06 21:17:52.056	\N
43bdbe19-36d8-4865-bace-a044c0a5b7f5	d2678738-0c2a-4243-8100-e63a95c86a9b	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.969875178947751	85	0.7302402357180374	55	2026-06-04 19:14:52.057	2026-06-04 19:15:52.057	2026-06-04 19:15:52.057	\N
5e90ea9f-7222-4101-9ce1-70ca3b56c80f	a22e7f9f-4421-4040-a1fd-c892712b9bcb	4618366c-a7eb-45d1-8ce8-e272eb02adae	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Cat	0.9411974680169297	91	0.974362372271611	17	2026-06-06 15:39:52.059	2026-06-06 15:40:52.059	2026-06-06 15:40:52.059	\N
9c204ec2-0498-4879-8e8c-38bf81f60567	62959381-bc0b-4dfe-a410-280f5d56fb71	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.9445909473441279	67	0.8277531369315728	55	2026-06-10 14:46:52.06	2026-06-10 14:47:52.06	2026-06-10 14:47:52.06	\N
a879ed31-0451-422e-936a-0b1a425adfff	d2678738-0c2a-4243-8100-e63a95c86a9b	98125074-82f0-48d5-866b-cfe5b9bdbbe9	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Dog	0.9145388584915698	92	0.8788610587927651	25	2026-06-09 20:05:52.061	2026-06-09 20:06:52.061	2026-06-09 20:06:52.061	\N
4c13455d-1361-402d-b27f-20e2a221d35b	62959381-bc0b-4dfe-a410-280f5d56fb71	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.6154354024455632	72	0.801353806445269	55	2026-06-10 18:44:52.063	2026-06-10 18:45:52.063	2026-06-10 18:45:52.063	\N
3b15f3b2-2de2-463e-8177-4b1620b45210	cc72551f-9f88-4141-9efe-518d3aab4d01	98125074-82f0-48d5-866b-cfe5b9bdbbe9	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Dog	0.741537275574449	70	0.6652147412636419	71	2026-06-11 12:15:52.064	2026-06-11 12:16:52.064	2026-06-11 12:16:52.064	\N
52dd3523-6221-4bc2-a400-fdcdf8b019e8	cc72551f-9f88-4141-9efe-518d3aab4d01	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.6457040373620947	81	0.9171775780051961	50	2026-06-05 17:13:52.065	2026-06-05 17:14:52.065	2026-06-05 17:14:52.065	\N
9df5f1da-42e8-468c-85ee-ffb41cfedc14	d2678738-0c2a-4243-8100-e63a95c86a9b	4618366c-a7eb-45d1-8ce8-e272eb02adae	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Cat	0.7680031024218748	54	0.8946862045838238	37	2026-06-07 03:23:52.067	2026-06-07 03:24:52.067	2026-06-07 03:24:52.067	\N
94abc54a-87b2-46a9-b414-022746ca7aa3	a22e7f9f-4421-4040-a1fd-c892712b9bcb	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.8293332838777333	59	0.5865871647217057	44	2026-06-09 03:26:52.069	2026-06-09 03:27:52.069	2026-06-09 03:27:52.069	\N
f23678cb-ff12-4e2d-a2ca-2ca00efa0631	cc72551f-9f88-4141-9efe-518d3aab4d01	98125074-82f0-48d5-866b-cfe5b9bdbbe9	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Dog	0.7730054570018507	96	0.5612770086787097	41	2026-06-08 07:36:52.071	2026-06-08 07:37:52.071	2026-06-08 07:37:52.071	\N
fff7fe14-6d9f-4379-bdf5-02b2a5f99a9a	d2678738-0c2a-4243-8100-e63a95c86a9b	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.8309884598718384	96	0.5946810413715772	15	2026-06-09 17:31:52.072	2026-06-09 17:32:52.072	2026-06-09 17:32:52.072	\N
bbf6fc80-8df9-4ac2-aecf-85f62ad513b6	62959381-bc0b-4dfe-a410-280f5d56fb71	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.7463205136510395	51	0.808968889121388	57	2026-06-09 20:54:52.074	2026-06-09 20:55:52.074	2026-06-09 20:55:52.074	\N
bc22df1c-b80c-4cae-8174-8580c82fc574	a0319560-3ed4-4e39-a355-ab368c50fbd7	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.9534322775684232	74	0.5336309403799662	32	2026-06-05 12:13:52.076	2026-06-05 12:14:52.076	2026-06-05 12:14:52.076	\N
72c05429-46ae-4792-b982-7ec8938723c6	d2678738-0c2a-4243-8100-e63a95c86a9b	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.8504950665942862	63	0.6894982174199235	15	2026-06-10 15:06:52.077	2026-06-10 15:07:52.077	2026-06-10 15:07:52.077	\N
8c3b8a28-58c5-46da-883c-66e6f1210440	cc72551f-9f88-4141-9efe-518d3aab4d01	98125074-82f0-48d5-866b-cfe5b9bdbbe9	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Dog	0.7714760318909593	53	0.8145981885032512	51	2026-06-06 13:42:52.078	2026-06-06 13:43:52.078	2026-06-06 13:43:52.078	\N
07a3b37f-8fa6-46cb-a78c-a3e85e136f20	d2678738-0c2a-4243-8100-e63a95c86a9b	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.7613337098401499	51	0.9839164974730354	42	2026-06-06 10:44:52.08	2026-06-06 10:45:52.08	2026-06-06 10:45:52.08	\N
5a344112-cd0c-4ca6-a9da-c8bf14146989	a22e7f9f-4421-4040-a1fd-c892712b9bcb	4618366c-a7eb-45d1-8ce8-e272eb02adae	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Cat	0.636128475637536	88	0.8947581123832777	58	2026-06-07 21:08:52.081	2026-06-07 21:09:52.081	2026-06-07 21:09:52.081	\N
f9dab6ab-d762-4f1e-a10e-6980911f159e	62959381-bc0b-4dfe-a410-280f5d56fb71	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.9370540763417293	95	0.7951239144430863	62	2026-06-09 17:36:52.083	2026-06-09 17:37:52.083	2026-06-09 17:37:52.083	\N
188de33d-5d6c-41f8-a613-7d0b696cfec0	62959381-bc0b-4dfe-a410-280f5d56fb71	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.6521821725898248	94	0.5208102337710816	70	2026-06-07 16:37:52.084	2026-06-07 16:38:52.084	2026-06-07 16:38:52.084	\N
c922bc62-8647-4d2a-9d13-e9a1384a9ac1	cc72551f-9f88-4141-9efe-518d3aab4d01	4618366c-a7eb-45d1-8ce8-e272eb02adae	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Cat	0.6841334883106199	91	0.6489681402866678	54	2026-06-09 19:01:52.085	2026-06-09 19:02:52.085	2026-06-09 19:02:52.085	\N
e5408a9f-8ff7-4b05-bcc8-d774b295433c	a22e7f9f-4421-4040-a1fd-c892712b9bcb	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.6196669810888836	97	0.9601904792069633	72	2026-06-04 23:12:52.087	2026-06-04 23:13:52.087	2026-06-04 23:13:52.087	\N
d7af1b72-f62c-4158-88cb-d13917d822d2	a0319560-3ed4-4e39-a355-ab368c50fbd7	98125074-82f0-48d5-866b-cfe5b9bdbbe9	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Dog	0.6693928841113282	83	0.7275840011219514	32	2026-06-10 19:54:52.09	2026-06-10 19:55:52.09	2026-06-10 19:55:52.09	\N
d059dd4b-e9cb-4f6d-81d3-b8a5262fa26f	d2678738-0c2a-4243-8100-e63a95c86a9b	98125074-82f0-48d5-866b-cfe5b9bdbbe9	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Dog	0.871893734035351	78	0.80475065911172	60	2026-06-06 05:47:52.091	2026-06-06 05:48:52.091	2026-06-06 05:48:52.091	\N
637896bd-3784-4c37-9bdf-60b2047e17c4	d2678738-0c2a-4243-8100-e63a95c86a9b	2e052356-d6af-4893-9c1f-7ed7c03fdc88	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Elephant	0.68778519736623	85	0.5261765426285547	57	2026-06-09 20:06:52.093	2026-06-09 20:07:52.093	2026-06-09 20:07:52.093	\N
3550fd0d-f198-4a98-9947-ae51a6908a8c	a22e7f9f-4421-4040-a1fd-c892712b9bcb	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.9792252642493682	70	0.7453345008349483	43	2026-06-08 21:56:52.094	2026-06-08 21:57:52.094	2026-06-08 21:57:52.094	\N
543d6bfc-070a-4e01-8834-ab78dadbf786	d2678738-0c2a-4243-8100-e63a95c86a9b	5077022a-162a-4f8d-b448-25227222771f	aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	Bird	0.9624285451486422	76	0.9633203477229081	60	2026-06-10 01:45:52.096	2026-06-10 01:46:52.096	2026-06-10 01:46:52.096	\N
664ff6cf-fc6c-454e-9064-9f9821a20383	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	d19f7812-d39c-4902-9ed2-51c055cb4667	29930ef9-06e7-4663-8ce8-5567a253dec1	ikan	0.9686274509803922	10	0	20	2026-06-18 03:08:49.035	2026-06-18 03:09:10.309	2026-06-18 03:09:10.309	\N
ddd27097-3ffa-49f4-9518-b3cc9120b54b	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	6a603e7a-12df-4e4e-a59d-00db6e5768db	29930ef9-06e7-4663-8ce8-5567a253dec1	lumba-lumba	0.8974568247795105	127	0	21	2026-06-21 20:39:38.996	2026-06-21 20:40:00.255	2026-06-21 20:40:00.255	https://capstone-image.furqonaugust.site/sessions/572a491a-9bdb-4ac4-a714-f4fb71c82bc9/1782094397182.png
41dc4213-53d8-4d18-9cec-c01b3a7445c4	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	6a603e7a-12df-4e4e-a59d-00db6e5768db	29930ef9-06e7-4663-8ce8-5567a253dec1	ikan	0.592156862745098	10	0	2	2026-06-23 12:07:08.549	2026-06-23 12:07:19.205	2026-06-23 12:07:19.205	https://capstone-image.furqonaugust.site/sessions/572a491a-9bdb-4ac4-a714-f4fb71c82bc9/1782216438031.png
2c3d202c-df6e-49cd-95e5-42550ff64134	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	371e809c-8d06-49d2-b2f5-96bb7c024460	29930ef9-06e7-4663-8ce8-5567a253dec1	kucing	0.9529411764705882	10	0	23	2026-06-23 13:28:25.163	2026-06-23 13:28:56.755	2026-06-23 13:28:56.755	https://capstone-image.furqonaugust.site/sessions/572a491a-9bdb-4ac4-a714-f4fb71c82bc9/1782221335414.png
8f22332f-2a7b-40ee-8ab2-ef002e38c1ac	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	6a603e7a-12df-4e4e-a59d-00db6e5768db	29930ef9-06e7-4663-8ce8-5567a253dec1	kucing	0.6941176470588235	10	0	9	2026-06-25 03:50:49.229	2026-06-25 03:51:09.938	2026-06-25 03:51:09.938	https://capstone-image.furqonaugust.site/sessions/572a491a-9bdb-4ac4-a714-f4fb71c82bc9/1782359468810.png
2d6333c4-7c41-4e2d-bb76-7f6d1d0ff115	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	6a603e7a-12df-4e4e-a59d-00db6e5768db	29930ef9-06e7-4663-8ce8-5567a253dec1	kucing	0.7607843137254902	10	0	9	2026-06-25 03:55:53.74	2026-06-25 03:56:12.832	2026-06-25 03:56:12.832	https://capstone-image.furqonaugust.site/sessions/572a491a-9bdb-4ac4-a714-f4fb71c82bc9/1782359772466.png
f1d8b82f-75cb-469e-9bc6-5489d57833b2	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	6a603e7a-12df-4e4e-a59d-00db6e5768db	29930ef9-06e7-4663-8ce8-5567a253dec1	lumba-lumba	0.7797548174858093	115	0	7	2026-06-25 04:12:11.863	2026-06-25 04:12:20.947	2026-06-25 04:12:20.947	https://capstone-image.furqonaugust.site/sessions/572a491a-9bdb-4ac4-a714-f4fb71c82bc9/1782360740003.png
b3ae410b-f194-4357-9dbd-f4da0d93a5d3	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	d19f7812-d39c-4902-9ed2-51c055cb4667	29930ef9-06e7-4663-8ce8-5567a253dec1	kucing	0.9176470588235294	133	0	13	2026-06-25 04:18:29.514	2026-06-25 04:18:43.142	2026-06-25 04:18:43.142	https://capstone-image.furqonaugust.site/sessions/572a491a-9bdb-4ac4-a714-f4fb71c82bc9/1782361122671.png
ce0fe4b4-e296-49e4-87d4-b16610c8e74a	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	38a9cbfd-94b1-47b3-bda4-1f7dfb52f469	29930ef9-06e7-4663-8ce8-5567a253dec1	kucing	0.984313725490196	10	0	24	2026-06-25 04:23:53.552	2026-06-25 04:24:18.58	2026-06-25 04:24:18.58	https://capstone-image.furqonaugust.site/sessions/572a491a-9bdb-4ac4-a714-f4fb71c82bc9/1782361458208.png
ad753449-878c-4ac4-85a1-f2d7c2abda76	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	6a603e7a-12df-4e4e-a59d-00db6e5768db	29930ef9-06e7-4663-8ce8-5567a253dec1	kucing	1	10	0	9	2026-06-25 04:28:38.667	2026-06-25 04:28:50.383	2026-06-25 04:28:50.383	https://capstone-image.furqonaugust.site/sessions/572a491a-9bdb-4ac4-a714-f4fb71c82bc9/1782361727809.png
a68a76aa-2913-4711-be58-086d8f23a0ea	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	371e809c-8d06-49d2-b2f5-96bb7c024460	29930ef9-06e7-4663-8ce8-5567a253dec1	kucing	1	10	0	6	2026-06-25 04:30:42.399	2026-06-25 04:30:49.408	2026-06-25 04:30:49.408	https://capstone-image.furqonaugust.site/sessions/572a491a-9bdb-4ac4-a714-f4fb71c82bc9/1782361848819.png
db0bc2af-42d4-4398-b54a-6bd4918776cd	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	6a603e7a-12df-4e4e-a59d-00db6e5768db	29930ef9-06e7-4663-8ce8-5567a253dec1	lumba-lumba	0.6880167126655579	101	0	8	2026-06-25 04:48:27.416	2026-06-25 04:48:37.129	2026-06-25 04:48:37.129	https://capstone-image.furqonaugust.site/sessions/572a491a-9bdb-4ac4-a714-f4fb71c82bc9/1782362915706.png
621cdc84-af17-4801-b30e-d7f7d1cace74	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	6a603e7a-12df-4e4e-a59d-00db6e5768db	29930ef9-06e7-4663-8ce8-5567a253dec1	kucing	0.8862745098039215	10	0	8	2026-06-25 05:05:18.716	2026-06-25 05:05:27.725	2026-06-25 05:05:27.725	https://capstone-image.furqonaugust.site/sessions/572a491a-9bdb-4ac4-a714-f4fb71c82bc9/1782363926695.png
f4bc8834-d3b7-45cc-b02d-4175489bc9f0	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	6a603e7a-12df-4e4e-a59d-00db6e5768db	29930ef9-06e7-4663-8ce8-5567a253dec1	kucing	0.9058823529411765	10	0	9	2026-06-25 05:23:23.991	2026-06-25 05:23:34.059	2026-06-25 05:23:34.059	https://capstone-image.furqonaugust.site/sessions/572a491a-9bdb-4ac4-a714-f4fb71c82bc9/1782365013592.png
\.


--
-- TOC entry 3551 (class 0 OID 34563)
-- Dependencies: 225
-- Data for Name: leaderboard_snapshots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leaderboard_snapshots (id, period, "periodLabel", rankings, "generatedAt") FROM stdin;
64a6c4a6-b71c-4a79-bcc6-cf7814e64fbc	WEEKLY	Week-41	[{"rank": 1, "userId": "0002434b-e140-417c-8ec4-c84a76392e0a", "username": "player_6_1782201226396", "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=player_6", "totalGames": 24, "totalScore": 10126, "displayName": "Player 6"}, {"rank": 2, "userId": "d6ff1d2a-9f0f-4e61-8f6e-c9d53ac7096f", "username": "player_14_1782201226436", "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=player_14", "totalGames": 97, "totalScore": 9808, "displayName": "Player 14"}, {"rank": 3, "userId": "fd657e0e-ee8b-47d8-8055-fcfd2f21376e", "username": "player_7_1782201226400", "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=player_7", "totalGames": 55, "totalScore": 9690, "displayName": "Player 7"}, {"rank": 4, "userId": "cdeb7326-bb0d-4346-b9ca-3002160cca2d", "username": "player_13_1782201226429", "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=player_13", "totalGames": 78, "totalScore": 9533, "displayName": "Player 13"}, {"rank": 5, "userId": "1928e4ba-ffd9-4496-abc3-6b42242228f7", "username": "player_1_1782201226221", "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=player_1", "totalGames": 91, "totalScore": 9277, "displayName": "Player 1"}, {"rank": 6, "userId": "0febfc41-cdc8-487a-8f5d-387e09082b04", "username": "player_8_1782201226405", "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=player_8", "totalGames": 96, "totalScore": 9017, "displayName": "Player 8"}, {"rank": 7, "userId": "2ac77a25-eb26-4256-9cdc-cc4bc7d7e844", "username": "player_9_1782201226410", "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=player_9", "totalGames": 30, "totalScore": 8633, "displayName": "Player 9"}, {"rank": 8, "userId": "eed06cfb-ad6d-454c-9e23-c90d57f28111", "username": "player_12_1782201226424", "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=player_12", "totalGames": 79, "totalScore": 7631, "displayName": "Player 12"}, {"rank": 9, "userId": "b170fe82-0e54-4029-bc1d-11d45bb01872", "username": "player_11_1782201226419", "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=player_11", "totalGames": 102, "totalScore": 6759, "displayName": "Player 11"}, {"rank": 10, "userId": "e8575ce9-1dd3-41ba-85b9-0d3fdbb9da63", "username": "player_10_1782201226414", "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=player_10", "totalGames": 11, "totalScore": 6432, "displayName": "Player 10"}]	2026-06-23 07:53:46.475
\.


--
-- TOC entry 3552 (class 0 OID 37285)
-- Dependencies: 226
-- Data for Name: learning_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.learning_profiles (id, "userId", "animalId", "attemptCount", "avgScore", "avgConfidence", "lastPlayedAt", "createdAt", "updatedAt") FROM stdin;
826f1853-aec8-4a33-b655-f729165454f5	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	d19f7812-d39c-4902-9ed2-51c055cb4667	1	133	0.9176470588235294	2026-06-25 04:18:43.164	2026-06-25 04:18:43.164	2026-06-25 04:18:43.164
901a03a6-c73a-41f6-91f4-5e4032a29646	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	38a9cbfd-94b1-47b3-bda4-1f7dfb52f469	1	10	0.984313725490196	2026-06-25 04:24:18.596	2026-06-25 04:24:18.596	2026-06-25 04:24:18.596
959b14a7-bcd7-49ef-99c5-556019898a8f	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	371e809c-8d06-49d2-b2f5-96bb7c024460	2	10	0.9764705882352941	2026-06-25 04:30:49.433	2026-06-23 13:28:56.872	2026-06-25 04:30:49.433
8aa27f32-5fb8-43ad-9286-75d972bfcff1	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	6a603e7a-12df-4e4e-a59d-00db6e5768db	8	34.5	0.7883734020532347	2026-06-25 05:23:34.077	2026-06-23 12:07:19.299	2026-06-25 05:23:34.078
\.


--
-- TOC entry 3545 (class 0 OID 26546)
-- Dependencies: 219
-- Data for Name: ml_models; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ml_models (id, name, version, "fileUrl", "labelsUrl", "inputSize", framework, accuracy, "isActive", "firebaseModelName", "createdAt", "updatedAt", "activatedAt") FROM stdin;
aae5eb6d-d41e-4b4d-9bd8-a659b241ef83	CNN Sketch Animal	1.0.0	https://example.com/dummy.tflite	\N	224	\N	92.5	f	\N	2026-06-11 14:47:52.008	2026-06-12 15:15:02.501	\N
29930ef9-06e7-4663-8ce8-5567a253dec1	Model-V2.4	1.2.0	https://capstone-image.furqonaugust.site/models/Model-V2.4-v1.2.0.tflite	\N	\N	\N	0.89	t	\N	2026-06-12 15:00:42.649	2026-06-12 15:15:02.503	\N
\.


--
-- TOC entry 3549 (class 0 OID 33707)
-- Dependencies: 223
-- Data for Name: purchase_histories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_histories (id, "userId", "itemId", price, "purchasedAt") FROM stdin;
10689abd-a073-4a05-aed4-478074c8ed3a	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	49c16b2e-2fab-4931-aaca-242c7bcfa8c6	100	2026-06-23 08:55:04.674
783a347c-563e-4ae7-9244-bd9310ae047c	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	17f7dcb7-a35d-455f-b882-3f3f57980632	1000	2026-06-23 12:56:17.618
3cb522d9-701e-4502-ac75-2ca9713eb853	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	7e0061f6-2ddd-4225-87b4-51e23575df70	500	2026-06-23 13:56:36.985
b06b1a03-25ec-441d-abca-7b85ae0e90db	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	7e0061f6-2ddd-4225-87b4-51e23575df70	500	2026-06-23 16:33:07.568
eb264722-070a-4904-b51c-4bbbb3a06f5f	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	7e0061f6-2ddd-4225-87b4-51e23575df70	500	2026-06-23 17:00:51.99
d875bf22-047a-46c5-9d7c-843c353b1335	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	17f7dcb7-a35d-455f-b882-3f3f57980632	1000	2026-06-23 17:09:25.369
fae992cd-0bbc-4c02-badb-00bdfa320e02	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	7e0061f6-2ddd-4225-87b4-51e23575df70	500	2026-06-23 17:12:53.93
2980b82d-2850-40ed-b5ad-ce3ddf45e838	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	d7dacffe-3ec6-448c-816b-25431cd87fbc	200	2026-06-27 11:05:19.886
434d2949-c289-4c2f-acf0-36a2a689c540	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	ffd2619b-6d1c-4e7c-a768-09327f6eddd2	1000	2026-06-27 11:22:08.219
\.


--
-- TOC entry 3543 (class 0 OID 26529)
-- Dependencies: 217
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (id, token, "userId", "expiresAt", "createdAt") FROM stdin;
147f6ef9-7da6-46f8-b817-4e742ebc61bb	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI1NzJhNDkxYS05YmRiLTRhYzQtYTcxNC1mNGZiNzFjODJiYzkiLCJyb2xlIjoiVVNFUiIsImlhdCI6MTc4MjE5OTA4MiwiZXhwIjoxNzgyODAzODgyfQ.QYqZCYB00IN2GSHa6eckHJHMhYpeymI4rTbJJpwLO38	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	2026-06-30 07:18:02.753	2026-06-23 07:18:02.773
b713bb30-b68d-4d86-9c43-c5755d6f48f6	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxNWU2ODg0MC1iNzcxLTQzM2ItOTFhNC0wYWRlY2EyZDMwYzQiLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3ODIyODQ2MDksImV4cCI6MTc4Mjg4OTQwOX0.bVg4F8wnxdN2FZ1xkrEEpDB5MikAGG66cEIANZAtE3Y	15e68840-b771-433b-91a4-0adeca2d30c4	2026-07-01 07:03:29.828	2026-06-24 07:03:29.844
6c3e2358-1f45-4270-b948-3b139e6285c8	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxNWU2ODg0MC1iNzcxLTQzM2ItOTFhNC0wYWRlY2EyZDMwYzQiLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3ODIyOTczODksImV4cCI6MTc4MjkwMjE4OX0.2rOawDSKqn4SFzRAD5Wm4iFowFUCj-FTy3E6MVzs62w	15e68840-b771-433b-91a4-0adeca2d30c4	2026-07-01 10:36:29.766	2026-06-24 10:36:29.779
d11d0ade-b321-4040-a91d-9cecf2fd9a14	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxNWU2ODg0MC1iNzcxLTQzM2ItOTFhNC0wYWRlY2EyZDMwYzQiLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3ODIzMDIwMjgsImV4cCI6MTc4MjkwNjgyOH0.NXpeqLs4uCkbL8sYXA5YMMI0L-hPig8aVd3_cCDuJj4	15e68840-b771-433b-91a4-0adeca2d30c4	2026-07-01 11:53:48.871	2026-06-24 11:53:48.884
69a09f8f-ca54-4f7c-8507-652865f2f94d	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxNWU2ODg0MC1iNzcxLTQzM2ItOTFhNC0wYWRlY2EyZDMwYzQiLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3ODIzMjEzNjgsImV4cCI6MTc4MjkyNjE2OH0.QsuWknkjgDrwvwlnvcUaJWva-cGwB1gTDlnGhp9phJY	15e68840-b771-433b-91a4-0adeca2d30c4	2026-07-01 17:16:08.819	2026-06-24 17:16:08.866
2e91b224-8dd8-4969-9eb9-5f75207677dd	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxNWU2ODg0MC1iNzcxLTQzM2ItOTFhNC0wYWRlY2EyZDMwYzQiLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3ODIzMjM1NTcsImV4cCI6MTc4MjkyODM1N30.lI9jGmFkFwveSuFSyBNdeaRG5iM3HPJgbxsqh6MB0L0	15e68840-b771-433b-91a4-0adeca2d30c4	2026-07-01 17:52:37.791	2026-06-24 17:52:37.793
695c5376-9973-40ae-bc45-0a084ac14391	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI1NzJhNDkxYS05YmRiLTRhYzQtYTcxNC1mNGZiNzFjODJiYzkiLCJyb2xlIjoiVVNFUiIsImlhdCI6MTc4MjM2NDk5OSwiZXhwIjoxNzgyOTY5Nzk5fQ.tYVTnYo9w2zJvK65JLr7Qp0jmVtNpkBqEZrmwD388ns	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	2026-07-02 05:23:19.267	2026-06-25 05:23:19.269
a8fd5e9c-100a-4c55-9372-dd8eabcec436	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxNWU2ODg0MC1iNzcxLTQzM2ItOTFhNC0wYWRlY2EyZDMwYzQiLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3ODI0ODQ1MzUsImV4cCI6MTc4MzA4OTMzNX0.vrtu2M8C9YRqYh3e-pAowiEzOKmJxo2NyVCj6K5sEo0	15e68840-b771-433b-91a4-0adeca2d30c4	2026-07-03 14:35:35.951	2026-06-26 14:35:35.956
7e3d2cd2-aab7-45d3-9e41-8d41658e37e2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxNWU2ODg0MC1iNzcxLTQzM2ItOTFhNC0wYWRlY2EyZDMwYzQiLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3ODI1NDgzNDUsImV4cCI6MTc4MzE1MzE0NX0.gvPUN7aFULbjZdw2oQNzxmmG-tF3Z3PsaLm4o9Qy9Yc	15e68840-b771-433b-91a4-0adeca2d30c4	2026-07-04 08:19:05.932	2026-06-27 08:19:05.981
5a1092b4-454b-454c-9eef-2943494a1b81	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI1NzJhNDkxYS05YmRiLTRhYzQtYTcxNC1mNGZiNzFjODJiYzkiLCJyb2xlIjoiVVNFUiIsImlhdCI6MTc4MjU0ODM1MCwiZXhwIjoxNzgzMTUzMTUwfQ.A6D3IfVYo2FRu4grZMAHSvSizdXNEzScVAgJ7SjIus8	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	2026-07-04 08:19:10.628	2026-06-27 08:19:10.633
78b4010d-6a9a-41d9-9974-52735f6989f5	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI1NzJhNDkxYS05YmRiLTRhYzQtYTcxNC1mNGZiNzFjODJiYzkiLCJyb2xlIjoiVVNFUiIsImlhdCI6MTc4MjU4MDk4MywiZXhwIjoxNzgzMTg1NzgzfQ.w4bTJ52DOHxnfyHnEKi1YOczeMUMsnXpqmDF7cDv7Qw	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	2026-07-04 17:23:03.236	2026-06-27 17:23:03.257
\.


--
-- TOC entry 3547 (class 0 OID 33689)
-- Dependencies: 221
-- Data for Name: shop_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shop_items (id, name, description, "imageUrl", price, category, rarity, "isActive", "createdAt", "updatedAt") FROM stdin;
d7dacffe-3ec6-448c-816b-25431cd87fbc	Ocean Blue Theme	Tema laut biru yang menyegarkan pikiran	https://capstone-image.furqonaugust.site/shop/d7dacffe-3ec6-448c-816b-25431cd87fbc.png	200	THEME	RARE	t	2026-06-27 10:27:30.477	2026-06-27 11:04:58.14
cf2bcdd8-fa83-4a83-a7ad-6fff914d5bdf	Dark Mode Theme	Elegan dan ramah di mata untuk bermain malam hari	https://capstone-image.furqonaugust.site/shop/cf2bcdd8-fa83-4a83-a7ad-6fff914d5bdf.png	100	THEME	COMMON	t	2026-06-27 10:27:30.47	2026-06-27 11:06:29.391
b96e4a2e-87fb-4f3a-88f2-7a0b8a2f74b0	Cute Cat Avatar	Avatar kucing lucu yang cocok untuk profilmu	https://capstone-image.furqonaugust.site/shop/b96e4a2e-87fb-4f3a-88f2-7a0b8a2f74b0.png	500	AVATAR	EPIC	t	2026-06-27 10:27:30.482	2026-06-27 11:14:56.863
f8966abc-07fa-4ae4-a7a6-d99705654dd4	Fierce Tiger Avatar	Tunjukkan jiwa petarungmu dengan avatar ini	https://capstone-image.furqonaugust.site/shop/f8966abc-07fa-4ae4-a7a6-d99705654dd4.png	750	AVATAR	EPIC	t	2026-06-27 10:27:30.487	2026-06-27 11:17:39.204
ffd2619b-6d1c-4e7c-a768-09327f6eddd2	Golden Dragon Frame	Bingkai naga emas yang melegenda	https://capstone-image.furqonaugust.site/shop/ffd2619b-6d1c-4e7c-a768-09327f6eddd2.png	1000	FRAME	LEGENDARY	t	2026-06-27 10:27:30.492	2026-06-27 11:21:52.966
39369ee4-c6d9-4e0d-b261-8034c5a3dbcf	Wooden Classic Frame	Bingkai kayu klasik yang estetik	https://capstone-image.furqonaugust.site/shop/39369ee4-c6d9-4e0d-b261-8034c5a3dbcf.png	150	FRAME	COMMON	t	2026-06-27 10:27:30.497	2026-06-27 11:37:29.663
17f7dcb7-a35d-455f-b882-3f3f57980632	Golden Frame	Gold profile frame	https://capstone-image.furqonaugust.site/shop/17f7dcb7-a35d-455f-b882-3f3f57980632.png	1000	FRAME	LEGENDARY	f	2026-06-18 03:44:07.35	2026-06-27 18:17:58.032
7e0061f6-2ddd-4225-87b4-51e23575df70	Cat Avatar	Cute cat avatar	https://capstone-image.furqonaugust.site/shop/7e0061f6-2ddd-4225-87b4-51e23575df70.png	500	AVATAR	EPIC	f	2026-06-18 03:44:07.348	2026-06-27 18:18:06.348
b668751c-7f4f-41c5-918f-124db64c2443	Blue Theme	Blue app theme	https://capstone-image.furqonaugust.site/shop/b668751c-7f4f-41c5-918f-124db64c2443.jpg	200	THEME	RARE	f	2026-06-18 03:44:07.345	2026-06-27 18:18:09.294
49c16b2e-2fab-4931-aaca-242c7bcfa8c6	Red Theme	Red app theme	https://capstone-image.furqonaugust.site/shop/49c16b2e-2fab-4931-aaca-242c7bcfa8c6.jpg	100	THEME	COMMON	f	2026-06-18 03:44:07.339	2026-06-27 18:18:12.711
\.


--
-- TOC entry 3548 (class 0 OID 33698)
-- Dependencies: 222
-- Data for Name: user_inventories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_inventories (id, "userId", "itemId", quantity, "acquiredAt") FROM stdin;
c90284cb-84e2-4154-9d13-799e0d8a02ec	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	49c16b2e-2fab-4931-aaca-242c7bcfa8c6	1	2026-06-23 08:55:04.659
649ba8e0-a812-485f-b7c6-0791986e1ab3	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	17f7dcb7-a35d-455f-b882-3f3f57980632	2	2026-06-23 12:56:17.608
2f7788a3-8aed-4572-95f6-bc6c98f33495	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	7e0061f6-2ddd-4225-87b4-51e23575df70	4	2026-06-23 13:56:36.978
cf91efec-84fd-4bce-90b2-0f1d0a7625c7	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	d7dacffe-3ec6-448c-816b-25431cd87fbc	1	2026-06-27 11:05:19.867
93c4651f-d0ee-4cc1-b960-856401064686	572a491a-9bdb-4ac4-a714-f4fb71c82bc9	ffd2619b-6d1c-4e7c-a768-09327f6eddd2	1	2026-06-27 11:22:08.048
\.


--
-- TOC entry 3550 (class 0 OID 34090)
-- Dependencies: 224
-- Data for Name: user_statistics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_statistics ("userId", "totalGames", "totalScore", "highestScore", "averageFocus", "totalDrawingTime", "updatedAt") FROM stdin;
1928e4ba-ffd9-4496-abc3-6b42242228f7	91	9277	83	0.39765805906853835	4185	2026-06-23 07:53:46.367
cdd98d68-d368-4006-af2a-1c2c39c44661	48	4725	72	0.8789893843324352	4596	2026-06-23 07:53:46.376
c7fbec79-385e-4397-a976-2e553e2e9da7	86	3321	140	0.4653133304447452	4473	2026-06-23 07:53:46.381
bcd5640e-9421-4db0-b542-abe2ad817004	27	4253	60	0.6221695820193225	2223	2026-06-23 07:53:46.387
101fe115-9b41-44bb-b1ef-023a5e2c9a52	70	747	100	0.7998362470026026	5706	2026-06-23 07:53:46.393
0002434b-e140-417c-8ec4-c84a76392e0a	24	10126	138	0.9284883581059529	5102	2026-06-23 07:53:46.398
fd657e0e-ee8b-47d8-8055-fcfd2f21376e	55	9690	122	0.5389473324776096	5200	2026-06-23 07:53:46.403
0febfc41-cdc8-487a-8f5d-387e09082b04	96	9017	114	0.9062230505825515	4418	2026-06-23 07:53:46.407
2ac77a25-eb26-4256-9cdc-cc4bc7d7e844	30	8633	118	0.010434988329499184	4336	2026-06-23 07:53:46.412
e8575ce9-1dd3-41ba-85b9-0d3fdbb9da63	11	6432	54	0.3139798410686775	3862	2026-06-23 07:53:46.417
b170fe82-0e54-4029-bc1d-11d45bb01872	102	6759	60	0.045885455882481385	1233	2026-06-23 07:53:46.422
572a491a-9bdb-4ac4-a714-f4fb71c82bc9	13	11439	133	0	148	2026-06-25 05:23:34.07
\.


--
-- TOC entry 3542 (class 0 OID 26519)
-- Dependencies: 216
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, "passwordHash", "displayName", "avatarUrl", "totalPoint", role, "createdAt", "updatedAt", "equippedAvatarId", "equippedFrameId", "equippedThemeId") FROM stdin;
15e68840-b771-433b-91a4-0adeca2d30c4	admin	admin@animaldrawing.com	$2b$10$7Vq/V.B62ZUtkU6qEHqRVewa.N1qJtoAp5E0FbXUZBeH.QZRSSORO	System Admin	\N	0	ADMIN	2026-06-11 07:53:22.123	2026-06-11 07:53:22.123	\N	\N	\N
d2678738-0c2a-4243-8100-e63a95c86a9b	player1	player1@animaldrawing.com	$2b$10$IdOpCD/zUqJK8DEj.iy/n.RGvnBZv3awuXlkkcXxkOzAMKzNWBlsy	Player 1	\N	1063	USER	2026-06-11 14:47:51.994	2026-06-11 14:47:51.994	\N	\N	\N
62959381-bc0b-4dfe-a410-280f5d56fb71	player2	player2@animaldrawing.com	$2b$10$IdOpCD/zUqJK8DEj.iy/n.RGvnBZv3awuXlkkcXxkOzAMKzNWBlsy	Player 2	\N	996	USER	2026-06-11 14:47:51.998	2026-06-11 14:47:51.998	\N	\N	\N
a22e7f9f-4421-4040-a1fd-c892712b9bcb	player3	player3@animaldrawing.com	$2b$10$IdOpCD/zUqJK8DEj.iy/n.RGvnBZv3awuXlkkcXxkOzAMKzNWBlsy	Player 3	\N	414	USER	2026-06-11 14:47:52.001	2026-06-11 14:47:52.001	\N	\N	\N
cc72551f-9f88-4141-9efe-518d3aab4d01	player4	player4@animaldrawing.com	$2b$10$IdOpCD/zUqJK8DEj.iy/n.RGvnBZv3awuXlkkcXxkOzAMKzNWBlsy	Player 4	\N	1026	USER	2026-06-11 14:47:52.003	2026-06-11 14:47:52.003	\N	\N	\N
a0319560-3ed4-4e39-a355-ab368c50fbd7	player5	player5@animaldrawing.com	$2b$10$IdOpCD/zUqJK8DEj.iy/n.RGvnBZv3awuXlkkcXxkOzAMKzNWBlsy	Player 5	\N	513	USER	2026-06-11 14:47:52.005	2026-06-11 14:47:52.005	\N	\N	\N
1928e4ba-ffd9-4496-abc3-6b42242228f7	player_1_1782201226221	player_1_1782201226221@example.com	dummyhash	Player 1	https://api.dicebear.com/7.x/avataaars/svg?seed=player_1	9277	USER	2026-06-23 07:53:46.326	2026-06-23 07:53:46.326	\N	\N	\N
cdd98d68-d368-4006-af2a-1c2c39c44661	player_2_1782201226372	player_2_1782201226372@example.com	dummyhash	Player 2	https://api.dicebear.com/7.x/avataaars/svg?seed=player_2	4725	USER	2026-06-23 07:53:46.372	2026-06-23 07:53:46.372	\N	\N	\N
c7fbec79-385e-4397-a976-2e553e2e9da7	player_3_1782201226378	player_3_1782201226378@example.com	dummyhash	Player 3	https://api.dicebear.com/7.x/avataaars/svg?seed=player_3	3321	USER	2026-06-23 07:53:46.378	2026-06-23 07:53:46.378	\N	\N	\N
bcd5640e-9421-4db0-b542-abe2ad817004	player_4_1782201226384	player_4_1782201226384@example.com	dummyhash	Player 4	https://api.dicebear.com/7.x/avataaars/svg?seed=player_4	4253	USER	2026-06-23 07:53:46.384	2026-06-23 07:53:46.384	\N	\N	\N
101fe115-9b41-44bb-b1ef-023a5e2c9a52	player_5_1782201226390	player_5_1782201226390@example.com	dummyhash	Player 5	https://api.dicebear.com/7.x/avataaars/svg?seed=player_5	747	USER	2026-06-23 07:53:46.39	2026-06-23 07:53:46.39	\N	\N	\N
0002434b-e140-417c-8ec4-c84a76392e0a	player_6_1782201226396	player_6_1782201226396@example.com	dummyhash	Player 6	https://api.dicebear.com/7.x/avataaars/svg?seed=player_6	10126	USER	2026-06-23 07:53:46.396	2026-06-23 07:53:46.396	\N	\N	\N
fd657e0e-ee8b-47d8-8055-fcfd2f21376e	player_7_1782201226400	player_7_1782201226400@example.com	dummyhash	Player 7	https://api.dicebear.com/7.x/avataaars/svg?seed=player_7	9690	USER	2026-06-23 07:53:46.401	2026-06-23 07:53:46.401	\N	\N	\N
0febfc41-cdc8-487a-8f5d-387e09082b04	player_8_1782201226405	player_8_1782201226405@example.com	dummyhash	Player 8	https://api.dicebear.com/7.x/avataaars/svg?seed=player_8	9017	USER	2026-06-23 07:53:46.405	2026-06-23 07:53:46.405	\N	\N	\N
2ac77a25-eb26-4256-9cdc-cc4bc7d7e844	player_9_1782201226410	player_9_1782201226410@example.com	dummyhash	Player 9	https://api.dicebear.com/7.x/avataaars/svg?seed=player_9	8633	USER	2026-06-23 07:53:46.41	2026-06-23 07:53:46.41	\N	\N	\N
e8575ce9-1dd3-41ba-85b9-0d3fdbb9da63	player_10_1782201226414	player_10_1782201226414@example.com	dummyhash	Player 10	https://api.dicebear.com/7.x/avataaars/svg?seed=player_10	6432	USER	2026-06-23 07:53:46.415	2026-06-23 07:53:46.415	\N	\N	\N
b170fe82-0e54-4029-bc1d-11d45bb01872	player_11_1782201226419	player_11_1782201226419@example.com	dummyhash	Player 11	https://api.dicebear.com/7.x/avataaars/svg?seed=player_11	6759	USER	2026-06-23 07:53:46.419	2026-06-23 07:53:46.419	\N	\N	\N
3aaec2e3-f94c-4506-8c44-a5bed7185075	BudiSantoso	budisantoso@animaldrawing.com	$2b$10$0Vwjag454ATN/6/XhAokiefRdUIej.iyO8DGCfC1VOKPkFFzuQrR6	Budi Santoso	https://api.dicebear.com/7.x/avataaars/svg?seed=BudiSantoso	600	USER	2026-06-27 10:27:30.402	2026-06-27 10:27:30.402	\N	\N	\N
71497705-d29e-47cd-96ff-c82ba25749de	SitiAisyah	sitiaisyah@animaldrawing.com	$2b$10$0Vwjag454ATN/6/XhAokiefRdUIej.iyO8DGCfC1VOKPkFFzuQrR6	Siti Aisyah	https://api.dicebear.com/7.x/avataaars/svg?seed=SitiAisyah	1885	USER	2026-06-27 10:27:30.416	2026-06-27 10:27:30.416	\N	\N	\N
dd593c06-fd52-496c-ad99-929fec0d0e87	AhmadFauzi	ahmadfauzi@animaldrawing.com	$2b$10$0Vwjag454ATN/6/XhAokiefRdUIej.iyO8DGCfC1VOKPkFFzuQrR6	Ahmad Fauzi	https://api.dicebear.com/7.x/avataaars/svg?seed=AhmadFauzi	2334	USER	2026-06-27 10:27:30.423	2026-06-27 10:27:30.423	\N	\N	\N
7d1f6626-2da5-4451-93c3-6bfbbebb4539	RinaWijaya	rinawijaya@animaldrawing.com	$2b$10$0Vwjag454ATN/6/XhAokiefRdUIej.iyO8DGCfC1VOKPkFFzuQrR6	Rina Wijaya	https://api.dicebear.com/7.x/avataaars/svg?seed=RinaWijaya	1753	USER	2026-06-27 10:27:30.428	2026-06-27 10:27:30.428	\N	\N	\N
02338e3c-8fc7-486c-b43d-a2fcd96d35a2	DimasPratama	dimaspratama@animaldrawing.com	$2b$10$0Vwjag454ATN/6/XhAokiefRdUIej.iyO8DGCfC1VOKPkFFzuQrR6	Dimas Pratama	https://api.dicebear.com/7.x/avataaars/svg?seed=DimasPratama	2157	USER	2026-06-27 10:27:30.437	2026-06-27 10:27:30.437	\N	\N	\N
572a491a-9bdb-4ac4-a714-f4fb71c82bc9	Samsudin	samsudin@gmail.com	$2b$10$t.unXZ18bC6sOqlho6jQ6eF70JhKEchstHPqpEpHp2pO9xaMXkiLC	Samsudin	\N	229	USER	2026-06-12 16:17:39.628	2026-06-27 14:33:03.592	\N	\N	\N
\.


--
-- TOC entry 3352 (class 2606 OID 26511)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3361 (class 2606 OID 26545)
-- Name: animals animals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animals
    ADD CONSTRAINT animals_pkey PRIMARY KEY (id);


--
-- TOC entry 3367 (class 2606 OID 26571)
-- Name: game_sessions game_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT game_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 3380 (class 2606 OID 34570)
-- Name: leaderboard_snapshots leaderboard_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leaderboard_snapshots
    ADD CONSTRAINT leaderboard_snapshots_pkey PRIMARY KEY (id);


--
-- TOC entry 3382 (class 2606 OID 37296)
-- Name: learning_profiles learning_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_profiles
    ADD CONSTRAINT learning_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 3363 (class 2606 OID 26554)
-- Name: ml_models ml_models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ml_models
    ADD CONSTRAINT ml_models_pkey PRIMARY KEY (id);


--
-- TOC entry 3375 (class 2606 OID 33714)
-- Name: purchase_histories purchase_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_histories
    ADD CONSTRAINT purchase_histories_pkey PRIMARY KEY (id);


--
-- TOC entry 3358 (class 2606 OID 26536)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3370 (class 2606 OID 33697)
-- Name: shop_items shop_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shop_items
    ADD CONSTRAINT shop_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3372 (class 2606 OID 33706)
-- Name: user_inventories user_inventories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_inventories
    ADD CONSTRAINT user_inventories_pkey PRIMARY KEY (id);


--
-- TOC entry 3377 (class 2606 OID 34101)
-- Name: user_statistics user_statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_statistics
    ADD CONSTRAINT user_statistics_pkey PRIMARY KEY ("userId");


--
-- TOC entry 3355 (class 2606 OID 26528)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3364 (class 1259 OID 26577)
-- Name: game_sessions_animalId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "game_sessions_animalId_idx" ON public.game_sessions USING btree ("animalId");


--
-- TOC entry 3365 (class 1259 OID 26578)
-- Name: game_sessions_modelId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "game_sessions_modelId_idx" ON public.game_sessions USING btree ("modelId");


--
-- TOC entry 3368 (class 1259 OID 26576)
-- Name: game_sessions_userId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "game_sessions_userId_idx" ON public.game_sessions USING btree ("userId");


--
-- TOC entry 3383 (class 1259 OID 37297)
-- Name: learning_profiles_userId_animalId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "learning_profiles_userId_animalId_key" ON public.learning_profiles USING btree ("userId", "animalId");


--
-- TOC entry 3359 (class 1259 OID 26574)
-- Name: refresh_tokens_token_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX refresh_tokens_token_key ON public.refresh_tokens USING btree (token);


--
-- TOC entry 3373 (class 1259 OID 33715)
-- Name: user_inventories_userId_itemId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "user_inventories_userId_itemId_key" ON public.user_inventories USING btree ("userId", "itemId");


--
-- TOC entry 3378 (class 1259 OID 36212)
-- Name: user_statistics_totalScore_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "user_statistics_totalScore_idx" ON public.user_statistics USING btree ("totalScore" DESC);


--
-- TOC entry 3353 (class 1259 OID 26573)
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- TOC entry 3356 (class 1259 OID 26572)
-- Name: users_username_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_username_key ON public.users USING btree (username);


--
-- TOC entry 3388 (class 2606 OID 26599)
-- Name: game_sessions game_sessions_animalId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT "game_sessions_animalId_fkey" FOREIGN KEY ("animalId") REFERENCES public.animals(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3389 (class 2606 OID 26604)
-- Name: game_sessions game_sessions_modelId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT "game_sessions_modelId_fkey" FOREIGN KEY ("modelId") REFERENCES public.ml_models(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3390 (class 2606 OID 26594)
-- Name: game_sessions game_sessions_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT "game_sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3396 (class 2606 OID 37303)
-- Name: learning_profiles learning_profiles_animalId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_profiles
    ADD CONSTRAINT "learning_profiles_animalId_fkey" FOREIGN KEY ("animalId") REFERENCES public.animals(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3397 (class 2606 OID 37298)
-- Name: learning_profiles learning_profiles_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_profiles
    ADD CONSTRAINT "learning_profiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3393 (class 2606 OID 33731)
-- Name: purchase_histories purchase_histories_itemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_histories
    ADD CONSTRAINT "purchase_histories_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES public.shop_items(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3394 (class 2606 OID 33726)
-- Name: purchase_histories purchase_histories_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_histories
    ADD CONSTRAINT "purchase_histories_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3387 (class 2606 OID 26579)
-- Name: refresh_tokens refresh_tokens_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT "refresh_tokens_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3391 (class 2606 OID 33721)
-- Name: user_inventories user_inventories_itemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_inventories
    ADD CONSTRAINT "user_inventories_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES public.shop_items(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3392 (class 2606 OID 33716)
-- Name: user_inventories user_inventories_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_inventories
    ADD CONSTRAINT "user_inventories_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3395 (class 2606 OID 34113)
-- Name: user_statistics user_statistics_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_statistics
    ADD CONSTRAINT "user_statistics_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3384 (class 2606 OID 39682)
-- Name: users users_equippedAvatarId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "users_equippedAvatarId_fkey" FOREIGN KEY ("equippedAvatarId") REFERENCES public.shop_items(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3385 (class 2606 OID 39687)
-- Name: users users_equippedFrameId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "users_equippedFrameId_fkey" FOREIGN KEY ("equippedFrameId") REFERENCES public.shop_items(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3386 (class 2606 OID 39692)
-- Name: users users_equippedThemeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "users_equippedThemeId_fkey" FOREIGN KEY ("equippedThemeId") REFERENCES public.shop_items(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2026-06-28 14:52:55 WIB

--
-- PostgreSQL database dump complete
--

\unrestrict BAwRJrRlzfxSTrXYPqHDnVcPoaGjAJFLNOoBEaHy0TlayZccLY8HVsYlszILZ1O

