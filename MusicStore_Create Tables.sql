CREATE TABLE album (
    album_id character varying(50) NOT NULL,
    title character varying(120),
    artist_id character varying(30)
);

CREATE TABLE artist (
    artist_id character varying(50) NOT NULL,
    name character varying(120)
);

CREATE TABLE customer (
    customer_id integer NOT NULL,
    first_name character(50),
    last_name character(50),
    company character varying(120),
    address character varying(120),
    city character varying(50),
    state character varying(50),
    country character varying(50),
    postal_code character varying(50),
    phone character varying(50),
    fax character varying(50),
    email character varying(50),
    support_rep_id integer
);

CREATE TABLE employee (
    employee_id character varying(50) NOT NULL,
    last_name character(50),
    first_name character(50),
    title character varying(50),
    reports_to character varying(30),
    levels character varying(10),
    birthdate timestamp,
    hire_date timestamp,
    address character varying(120),
    city character varying(50),
    state character varying(50),
    country character varying(30),
    postal_code character varying(30),
    phone character varying(30),
    fax character varying(30),
    email character varying(30)
);

CREATE TABLE genre (
    genre_id character varying(50) NOT NULL,
    name character varying(120)
);

CREATE TABLE invoice (
    invoice_id integer NOT NULL,
    customer_id integer,
    invoice_date timestamp,
    billing_address character varying(120),
    billing_city character varying(30),
    billing_state character varying(30),
    billing_country character varying(30),
    billing_postal character varying(30),
    total double precision
);

CREATE TABLE invoice_line (
    invoice_line_id character varying(50) NOT NULL,
    invoice_id integer,
    track_id integer,
    unit_price double precision,
    quantity double precision
);

CREATE TABLE media_type (
    media_type_id character varying(50) NOT NULL,
    name character varying(120)
);

CREATE TABLE playlist (
    playlist_id character varying(50) NOT NULL,
    name character varying(120)
);

CREATE TABLE playlist_track (
    playlist_id character varying(50),
    track_id integer
);

CREATE TABLE track (
    track_id integer NOT NULL,
    name character varying(150),
    album_id character varying(50),
    media_type_id character varying(50),
    genre_id character varying(50),
    composer character varying(190),
    milliseconds integer,
    bytes integer,
    unit_price double precision
);

