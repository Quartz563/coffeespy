--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cafe_roaster; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cafe_roaster (
    id bigint NOT NULL,
    is_current boolean DEFAULT false NOT NULL,
    cafe_id bigint,
    roaster_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: cafe_roaster_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cafe_roaster_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cafe_roaster_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cafe_roaster_id_seq OWNED BY public.cafe_roaster.id;


--
-- Name: cafes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cafes (
    id bigint NOT NULL,
    name character varying(255),
    address character varying(255),
    latitude double precision,
    longitude double precision,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: cafes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cafes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cafes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cafes_id_seq OWNED BY public.cafes.id;


--
-- Name: confirmations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.confirmations (
    id bigint NOT NULL,
    price_report_id bigint,
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: confirmations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.confirmations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: confirmations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.confirmations_id_seq OWNED BY public.confirmations.id;


--
-- Name: price_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.price_reports (
    id bigint NOT NULL,
    drink_type character varying(255),
    milk_type character varying(255),
    size character varying(255),
    price numeric,
    cafe_id bigint,
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: price_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.price_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: price_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.price_reports_id_seq OWNED BY public.price_reports.id;


--
-- Name: roasters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roasters (
    id bigint NOT NULL,
    name character varying(255),
    location character varying(255),
    website character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: roasters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roasters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roasters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roasters_id_seq OWNED BY public.roasters.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(255),
    email character varying(255),
    password_hash character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: cafe_roaster id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cafe_roaster ALTER COLUMN id SET DEFAULT nextval('public.cafe_roaster_id_seq'::regclass);


--
-- Name: cafes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cafes ALTER COLUMN id SET DEFAULT nextval('public.cafes_id_seq'::regclass);


--
-- Name: confirmations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.confirmations ALTER COLUMN id SET DEFAULT nextval('public.confirmations_id_seq'::regclass);


--
-- Name: price_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_reports ALTER COLUMN id SET DEFAULT nextval('public.price_reports_id_seq'::regclass);


--
-- Name: roasters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roasters ALTER COLUMN id SET DEFAULT nextval('public.roasters_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: cafe_roaster cafe_roaster_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cafe_roaster
    ADD CONSTRAINT cafe_roaster_pkey PRIMARY KEY (id);


--
-- Name: cafes cafes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cafes
    ADD CONSTRAINT cafes_pkey PRIMARY KEY (id);


--
-- Name: confirmations confirmations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.confirmations
    ADD CONSTRAINT confirmations_pkey PRIMARY KEY (id);


--
-- Name: price_reports price_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_reports
    ADD CONSTRAINT price_reports_pkey PRIMARY KEY (id);


--
-- Name: roasters roasters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roasters
    ADD CONSTRAINT roasters_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: cafe_roaster_cafe_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cafe_roaster_cafe_id_index ON public.cafe_roaster USING btree (cafe_id);


--
-- Name: cafe_roaster_roaster_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cafe_roaster_roaster_id_index ON public.cafe_roaster USING btree (roaster_id);


--
-- Name: confirmations_price_report_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX confirmations_price_report_id_index ON public.confirmations USING btree (price_report_id);


--
-- Name: confirmations_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX confirmations_user_id_index ON public.confirmations USING btree (user_id);


--
-- Name: price_reports_cafe_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX price_reports_cafe_id_index ON public.price_reports USING btree (cafe_id);


--
-- Name: price_reports_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX price_reports_user_id_index ON public.price_reports USING btree (user_id);


--
-- Name: cafe_roaster cafe_roaster_cafe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cafe_roaster
    ADD CONSTRAINT cafe_roaster_cafe_id_fkey FOREIGN KEY (cafe_id) REFERENCES public.cafes(id);


--
-- Name: cafe_roaster cafe_roaster_roaster_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cafe_roaster
    ADD CONSTRAINT cafe_roaster_roaster_id_fkey FOREIGN KEY (roaster_id) REFERENCES public.roasters(id);


--
-- Name: confirmations confirmations_price_report_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.confirmations
    ADD CONSTRAINT confirmations_price_report_id_fkey FOREIGN KEY (price_report_id) REFERENCES public.price_reports(id);


--
-- Name: confirmations confirmations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.confirmations
    ADD CONSTRAINT confirmations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: price_reports price_reports_cafe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_reports
    ADD CONSTRAINT price_reports_cafe_id_fkey FOREIGN KEY (cafe_id) REFERENCES public.cafes(id);


--
-- Name: price_reports price_reports_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_reports
    ADD CONSTRAINT price_reports_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20260416091030);
INSERT INTO public."schema_migrations" (version) VALUES (20260416091142);
INSERT INTO public."schema_migrations" (version) VALUES (20260416091213);
INSERT INTO public."schema_migrations" (version) VALUES (20260416091214);
INSERT INTO public."schema_migrations" (version) VALUES (20260416091253);
INSERT INTO public."schema_migrations" (version) VALUES (20260416091648);
