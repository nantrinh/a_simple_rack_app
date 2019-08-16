--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.19
-- Dumped by pg_dump version 9.5.19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cards; Type: TABLE; Schema: public; Owner: nancy
--

CREATE TABLE public.cards (
    id integer NOT NULL,
    set_id integer NOT NULL,
    term text,
    definition text
);


ALTER TABLE public.cards OWNER TO nancy;

--
-- Name: cards_id_seq; Type: SEQUENCE; Schema: public; Owner: nancy
--

CREATE SEQUENCE public.cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cards_id_seq OWNER TO nancy;

--
-- Name: cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nancy
--

ALTER SEQUENCE public.cards_id_seq OWNED BY public.cards.id;


--
-- Name: sets; Type: TABLE; Schema: public; Owner: nancy
--

CREATE TABLE public.sets (
    id integer NOT NULL,
    display_title character varying(255) NOT NULL,
    url_title character varying(255) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.sets OWNER TO nancy;

--
-- Name: sets_id_seq; Type: SEQUENCE; Schema: public; Owner: nancy
--

CREATE SEQUENCE public.sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sets_id_seq OWNER TO nancy;

--
-- Name: sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nancy
--

ALTER SEQUENCE public.sets_id_seq OWNED BY public.sets.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: nancy
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.users OWNER TO nancy;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: nancy
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO nancy;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nancy
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: nancy
--

ALTER TABLE ONLY public.cards ALTER COLUMN id SET DEFAULT nextval('public.cards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: nancy
--

ALTER TABLE ONLY public.sets ALTER COLUMN id SET DEFAULT nextval('public.sets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: nancy
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: nancy
--

COPY public.cards (id, set_id, term, definition) FROM stdin;
1	1	What is the DOM (Document Object Model)?	An in-memory object representation of an HTML document.\nA hierarchy of nodes.\nIt provides a way to interact with a web page using JavaScript and provides the functionality needed to build modern interactive user experiences.
2	1	Why do browsers insert elements into the DOM that are missing from the HTML?	A fundamental tenet of the web is permissiveness. Browsers always do their best to display HTML, even when it has errors.
3	1	Are all text nodes the same?	Yes. However, developers sometimes make a distinction between empty nodes (spaces, tabs, newlines, etc.) and text nodes that contain content (words, numbers, symbols, etc.).
4	1	Are empty nodes reflected visually in the browser?	No, but they are in the DOM, so do not neglect them.
5	1	True or False: there is a direct one-to-one mapping between the tags that appear in an HTML file and the nodes in the DOM.	False. The browser may insert nodes that don't appear in the HTML due to invalid markup or the omission of optional tags. Text, including whitespace, also creates nodes that don't map to tags.
6	1	Does this JavaScript run?	alert('Hello world!');\n
7	2	What is XMLHttpRequest?	One of the browser APIs that provide network programming functionality to JavaScript applications. Libraries or utility functions often wrap this web API.\nThe name comes from its original use, which was to fetch XML documents over HTTP. Today, we use this object to load any data (typically HTML or JSON) and can use other protocols (including file://) as well.
8	2	What is AJAX?	AJAX is short for Asynchronous JavaScript and XML. Its main feature is that it allows browsers to issue requests and process responses without a full page refresh.\n\nAJAX requests are just like normal requests: they are sent to the server with all the normal components of an HTTP request, and the server handles them like any other request. The only difference is that instead of the browser refreshing and processing the response, the response is processed by a callback function, which is usually some client-side JavaScript code.
9	2	What is an API?	API stands for Application Programming Interface.\nThey provide functionality for use by another program.\n\nExamples:\n- Every programming language has a built-in API that is used to write programs.\n- Mobile devices provide APIs to provide access to location or other sensor data, such as the device's GPS location or the orientation of the device.\n- Operating systems have APIs that programs can use to open files, access memory, draw text on the screen, etc.
10	2	What are web APIs?	APIs that use the HTTP protocol.
11	2	What is an API provider? What is an API consumer?	API provider: the system that provides an API for other parties to use.\nGitHub is the provider of the GitHub API, and Dropbox is the provider of the Dropbox API.\n\nAPI consumer: the system that uses the API to accomplish some work.\nWhen you check the weather on your phone, it is running a program that is consuming a weather API to retrieve forecast data.
12	2	Freedom is a word used by many.	Liberty is another one.
13	2	What about dom dom be dom?	It's a good song.\n
14	3	Why is the system version of Ruby on Linux suboptimal for development?	1. The installation is usually an older version of Ruby\n2. You may need root access to install and manipulate other Ruby components.
15	3	Your system version of Ruby is suboptimal for development. What should you do?	Install a Ruby version manager.\nUse the version manager to install the Ruby version(s) you need.
16	3	Besides the `ruby` command, what other files and tools does a Ruby installation contain? Name 6.	1. The core library\n2. The standard Library\n3. The irb REPL (Read Evaluate Print Loop)\n4. The rake utility: a tool to automate Ruby development tasks\n5. The gem command: a tool to manage RubyGems\n6. Documentation tools (rdoc and ri)
17	3	What are Gems?	Packages that you can download, install, and use in your Ruby programs or from the command line.
18	3	What happens when you run `gem&nbsp;install&nbsp;GEM_NAME`?	The `gem` command connects to the remote library, downlaods the appropriate Gems, and installs them.
19	3	Where are gems installed on your computer?	The exact location depends on your setup. Run `gem&nbsp;env` and look for "INSTALLATION DIRECTORY" to see where `gem` installs Gems by default.  \n
20	4	What are indexes?	A mechanism that SQL engines use to speed up queries.
21	4	How do you implement indexes?	Indexes are automatically created when you define a PRIMARY KEY constraint or a UNIQUE constraint on a column. You can also use the CREATE INDEX command to create an index. `CREATE&nbsp;INDEX&nbsp;index_name&nbsp;ON&nbsp;table_name&nbsp;(field_name);` The index is the mechanism by which these constraints enforce uniqueness. 
22	4	What are the trade-offs involved in using indexes?	If you build an index of a field, reads become faster, but every time a row is updated or inserted, the index must be updated as well. You would be updating not only the table but also the index.\nSome useful rules of thumb:\n- Indexes are best used in cases where sequential reading is inadequate. For example: columns that aid in mapping relationships (such as Foreign Key columns), or columns that are frequently used as part of an ORDER BY clause, are good candidates for indexing.\n- They are best used in tables and/ or columns where the data will be read much more frequently than it is created or updated.
23	4	What is the default type of index used in PostgreSQL?	b-tree
24	4	What is the only type of index available for unique indexes?	b-tree
25	4	Do FOREIGN KEY constrains automatically create an index on a column?	No
26	4	The dominatrix says "hello".	but what dominates? freedom.\n
27	5	This is a test.\n```\nclass&nbsp;TestMe\n&nbsp;&nbsp;def&nbsp;test\n&nbsp;&nbsp;&nbsp;&nbsp;&lt;script&gt;alert('Hello');&lt;/script&gt;\n&nbsp;&nbsp;&nbsp;&nbsp;&lt;a&nbsp;href="http://www.unicode.org/charts/PDF/U0000.pdf"&gt;CLICK&nbsp;ME&lt;/a&gt;\n&nbsp;&nbsp;end\nend\n```	Flip side of card
28	5	What does the following code output?\n```\nclass&nbsp;Person\n&nbsp;&nbsp;def&nbsp;initialize(name)\n&nbsp;&nbsp;&nbsp;&nbsp;@name&nbsp;=&nbsp;name\n&nbsp;&nbsp;end\nend\n\nbob&nbsp;=&nbsp;Person.new("Bob")\nputs&nbsp;bob.name\n```	NoMethodError
29	5	Which of the following modifications would cause the code to output `"Bob"`? Mark all that apply.\n```\nclass&nbsp;Person\n&nbsp;&nbsp;def&nbsp;initialize(name)\n&nbsp;&nbsp;&nbsp;&nbsp;@name&nbsp;=&nbsp;name\n&nbsp;&nbsp;end\nend\n\nbob&nbsp;=&nbsp;Person.new("Bob")\nputs&nbsp;bob.name\n```\nA.&nbsp;Add&nbsp;`attr_reader :name`\nB.&nbsp;Add&nbsp;`attr_writer :name`\nC.&nbsp;Add&nbsp;`attr_accessor :name`\nD.&nbsp;Define&nbsp;a&nbsp;method&nbsp;`def name; @name; end`\nE.&nbsp;Define&nbsp;a&nbsp;method&nbsp;`def name; name; end`	A, C, D
30	5	What kind of variable is `@name`?	instance variable
31	5	What kind of variable is `@@name`?	class variable
32	5	What does the following code output? \n```\nclass&nbsp;Person\n&nbsp;&nbsp;@@counter&nbsp;=&nbsp;0\n&nbsp;&nbsp;attr_reader&nbsp;:name\n\n&nbsp;&nbsp;def&nbsp;initialize(name)\n&nbsp;&nbsp;&nbsp;&nbsp;@name&nbsp;=&nbsp;name\n&nbsp;&nbsp;&nbsp;&nbsp;@@counter&nbsp;+=&nbsp;1\n&nbsp;&nbsp;end\n\n&nbsp;&nbsp;def&nbsp;self.counter\n&nbsp;&nbsp;&nbsp;&nbsp;@@counter\n&nbsp;&nbsp;end\nend\n\nlisa&nbsp;=&nbsp;Person.new("Lisa")\nruth&nbsp;=&nbsp;Person.new("Ruth")\nputs&nbsp;Person.counter\nputs&nbsp;lisa.counter\n```	2, NoMethodError
33	5	What does the following code output?\n```\nclass&nbsp;Animal\n&nbsp;&nbsp;def&nbsp;speak\n&nbsp;&nbsp;&nbsp;&nbsp;"I&nbsp;am&nbsp;an&nbsp;animal"\n&nbsp;&nbsp;end\nend\n\nclass&nbsp;Cow&nbsp;&lt;&nbsp;Animal\n&nbsp;&nbsp;def&nbsp;speak\n&nbsp;&nbsp;&nbsp;&nbsp;"Moo"\n&nbsp;&nbsp;end\nend\n\nCow.new.speak\n```	"Moo"
34	5	What is the term for what is happening here?\n```\nclass&nbsp;Animal\n&nbsp;&nbsp;def&nbsp;speak\n&nbsp;&nbsp;&nbsp;&nbsp;"I&nbsp;am&nbsp;an&nbsp;animal"\n&nbsp;&nbsp;end\nend\n\nclass&nbsp;Cow&nbsp;&lt;&nbsp;Animal\n&nbsp;&nbsp;def&nbsp;speak\n&nbsp;&nbsp;&nbsp;&nbsp;"Moo"\n&nbsp;&nbsp;end\nend\n\nCow.new.speak\n```	method overriding
35	5	Which of the following modifications would cause the code to output `100`? Mark all that apply.\n```\nclass&nbsp;BankAccount&nbsp;\n&nbsp;&nbsp;attr_reader&nbsp;:amount\n\n&nbsp;&nbsp;def&nbsp;initialize(amount)\n&nbsp;&nbsp;&nbsp;&nbsp;@amount\n&nbsp;&nbsp;end\nend\n\nnew_account&nbsp;=&nbsp;BankAccount.new(10)\nnew_account.amount&nbsp;=&nbsp;100\nputs&nbsp;new_account.amount\n```\nA.&nbsp;No&nbsp;modification&nbsp;is&nbsp;needed.\nB.&nbsp;Change&nbsp;`attr_reader`&nbsp;to&nbsp;`attr_writer`&nbsp;\nC.&nbsp;Change&nbsp;`attr_reader`&nbsp;to&nbsp;`attr_accessor`\nD.&nbsp;Add&nbsp;`attr_writer :amount`\nE.&nbsp;Define&nbsp;a&nbsp;method&nbsp;`def amount(value); @amount = value; end`\nF.&nbsp;Define&nbsp;a&nbsp;method&nbsp;`def amount=(value); @amount = value; end`	C, D, F
36	5	What does the following code output?\n```\nclass&nbsp;LivingThing\nend\n\nclass&nbsp;Plant&nbsp;&lt;&nbsp;LivingThing\nend\n\nclass&nbsp;Animal&nbsp;&lt;&nbsp;LivingThing\nend\n\nclass&nbsp;Dog&nbsp;&lt;&nbsp;Animal\nend\n\nclass&nbsp;Cat&nbsp;&lt;&nbsp;Animal\nend\n\nclass&nbsp;Bengal&nbsp;&lt;&nbsp;Cat\nend\n\np&nbsp;Bengal.ancestors\n```	[Bengal, Cat, Animal, LivingThing, Object, Kernel, BasicObject]
37	5	What does the following code output?\n```\nclass&nbsp;LivingThing\nend\n\nclass&nbsp;Plant&nbsp;&lt;&nbsp;LivingThing\nend\n\nclass&nbsp;Animal&nbsp;&lt;&nbsp;LivingThing\nend\n\nclass&nbsp;Dog&nbsp;&lt;&nbsp;Animal\nend\n\nclass&nbsp;Cat&nbsp;&lt;&nbsp;Animal\nend\n\nclass&nbsp;Bengal&nbsp;&lt;&nbsp;Cat\nend\n\np&nbsp;Plant.ancestors\n```	[Plant, LivingThing, Object, Kernel, BasicObject]
38	5	What does the following code output?\n```\nclass&nbsp;Cat\n&nbsp;&nbsp;def&nbsp;initialize(name)\n&nbsp;&nbsp;&nbsp;&nbsp;@name&nbsp;=&nbsp;name\n&nbsp;&nbsp;end\nend\n\ngemma&nbsp;=&nbsp;Cat.new("Gemma")\nputs&nbsp;gemma\n```\nA.&nbsp;`"Gemma"`\nB.&nbsp;`NoMethodError`\nC.&nbsp;A&nbsp;string&nbsp;representation&nbsp;of&nbsp;the&nbsp;calling&nbsp;object&nbsp;(e.g.,&nbsp;`#&lt;Cat:0x0000561e68d77698&gt;`	C
39	5	What does the following code output?\n```\nclass&nbsp;Cat\n&nbsp;&nbsp;def&nbsp;initialize(name)\n&nbsp;&nbsp;&nbsp;&nbsp;@name&nbsp;=&nbsp;name\n&nbsp;&nbsp;end\n\n&nbsp;&nbsp;def&nbsp;to_s\n&nbsp;&nbsp;&nbsp;&nbsp;@name\n&nbsp;&nbsp;end\nend\n\ngemma&nbsp;=&nbsp;Cat.new("Gemma")\nputs&nbsp;gemma\n```\nA.&nbsp;`"Gemma"`\nB.&nbsp;`NoMethodError`\nC.&nbsp;A&nbsp;string&nbsp;representation&nbsp;of&nbsp;the&nbsp;calling&nbsp;object&nbsp;(e.g.,&nbsp;`#&lt;Cat:0x0000561e68d77698&gt;`	A
40	5	What does the following code output?\n```\nclass&nbsp;Cat\n&nbsp;&nbsp;def&nbsp;initialize(name)\n&nbsp;&nbsp;&nbsp;&nbsp;@name&nbsp;=&nbsp;name\n&nbsp;&nbsp;end\n\n&nbsp;&nbsp;def&nbsp;to_s\n&nbsp;&nbsp;&nbsp;&nbsp;@name\n&nbsp;&nbsp;end\nend\n\nclass&nbsp;Bengal&nbsp;&lt;&nbsp;Cat\n&nbsp;&nbsp;def&nbsp;to_s\n&nbsp;&nbsp;&nbsp;&nbsp;"I&nbsp;am&nbsp;a&nbsp;Bengal&nbsp;and&nbsp;my&nbsp;name&nbsp;is&nbsp;#{@name}."\n&nbsp;&nbsp;end\nend\n\ngemma&nbsp;=&nbsp;Bengal.new("Gemma")\nputs&nbsp;gemma\n```\nA.&nbsp;`"Gemma"`\nB.&nbsp;`NoMethodError`\nC.&nbsp;A&nbsp;string&nbsp;representation&nbsp;of&nbsp;the&nbsp;calling&nbsp;object&nbsp;(e.g.,&nbsp;`#&lt;Cat:0x0000561e68d77698&gt;`\nD.&nbsp;`"I am a Bengal and my name is #{@name}."`	D
41	5	What does the following code output?\n```\nclass&nbsp;Cat\n&nbsp;&nbsp;def&nbsp;initialize(name)\n&nbsp;&nbsp;&nbsp;&nbsp;@name&nbsp;=&nbsp;name\n&nbsp;&nbsp;end\nend\n\ngemma&nbsp;=&nbsp;Cat.new("Gemma")\nrosie&nbsp;=&nbsp;Cat.new("Rosie")\n\ndef&nbsp;gemma.fly\n&nbsp;&nbsp;"I&nbsp;can&nbsp;fly!"\nend\n\nputs&nbsp;gemma.fly\nputs&nbsp;rosie.fly\n```	"I can fly!"; NoMethodError
42	5	What does `self` refer to in the following code? \n```\nclass&nbsp;Person\n&nbsp;&nbsp;@@counter&nbsp;=&nbsp;0\n\n&nbsp;&nbsp;def&nbsp;initialize\n&nbsp;&nbsp;&nbsp;&nbsp;@@counter&nbsp;+=&nbsp;1\n&nbsp;&nbsp;end\n\n&nbsp;&nbsp;def&nbsp;self.counter\n&nbsp;&nbsp;&nbsp;&nbsp;@@counter\n&nbsp;&nbsp;end\nend\n```	the Person class
43	5	What does `self` refer to in the following code? \n```\nclass&nbsp;Person\n&nbsp;&nbsp;def&nbsp;initialize(name)\n&nbsp;&nbsp;&nbsp;&nbsp;@name&nbsp;=&nbsp;name\n&nbsp;&nbsp;end\n\n&nbsp;&nbsp;def&nbsp;my_method&nbsp;\n&nbsp;&nbsp;&nbsp;&nbsp;self\n&nbsp;&nbsp;end\nend\n``` 	the calling object; an instance of Person
44	5	What does `self` refer to in the following code? \n```\nclass&nbsp;Person\n&nbsp;&nbsp;self\n\n&nbsp;&nbsp;def&nbsp;initialize(name)\n&nbsp;&nbsp;&nbsp;&nbsp;@name&nbsp;=&nbsp;name\n&nbsp;&nbsp;end\nend\n``` 	the Person class\n
\.


--
-- Name: cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nancy
--

SELECT pg_catalog.setval('public.cards_id_seq', 44, true);


--
-- Data for Name: sets; Type: TABLE DATA; Schema: public; Owner: nancy
--

COPY public.sets (id, display_title, url_title, user_id) FROM stdin;
1	The DOM	the-dom	1
2	APIs	apis	1
3	Core Ruby Tools	core-ruby-tools	1
4	A Unique Name BTS	a-unique-name-bts	1
5	Ruby Code	ruby-code	1
\.


--
-- Name: sets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nancy
--

SELECT pg_catalog.setval('public.sets_id_seq', 5, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: nancy
--

COPY public.users (id, name) FROM stdin;
1	public
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nancy
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: cards_pkey; Type: CONSTRAINT; Schema: public; Owner: nancy
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: sets_pkey; Type: CONSTRAINT; Schema: public; Owner: nancy
--

ALTER TABLE ONLY public.sets
    ADD CONSTRAINT sets_pkey PRIMARY KEY (id);


--
-- Name: sets_url_title_user_id_key; Type: CONSTRAINT; Schema: public; Owner: nancy
--

ALTER TABLE ONLY public.sets
    ADD CONSTRAINT sets_url_title_user_id_key UNIQUE (url_title, user_id);


--
-- Name: users_name_key; Type: CONSTRAINT; Schema: public; Owner: nancy
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_name_key UNIQUE (name);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: nancy
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: cards_set_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nancy
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_set_id_fkey FOREIGN KEY (set_id) REFERENCES public.sets(id) ON DELETE CASCADE;


--
-- Name: sets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nancy
--

ALTER TABLE ONLY public.sets
    ADD CONSTRAINT sets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

