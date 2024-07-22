
# Basics

## Why Airflow



## Core Components

- Web Server: Flask server with Gunicorn serving the UI
- Scheduler: Daemon in charge of scheduling worklows
- Metastore: Database where metadata are stored
- Executor: Class defining how your tasks should be executed
- Worker: Process/sub process executing your task

## DAG - Direct Acyclic Graphs

- Entity that represents a data pipeline.
- It's not allowed loops.


## Operators

## One Node Architecture

**Single Node**
- Web Server
- Scheduler
- Metastore
- Executor + Queue

## Multi Nodes Architecture (Celery)

**Node 1**
- Web Server
- Schedule
- Executor

**Node 2**
- Metastore
- Queue

**Multiple Worker Nodes**
- Airflow Workers


## Airflow UI


- Tree View
- Graph View
- Gantt: See bootlenecks
- Code: The code of the DAG

### Context of a task

- Rendered
- Log

### Task Actions
- Run
- Clear
- Mark Failed: Past | Future | Upstream | Downstream
- Mark Success: Past | Future | Upstream | Downstream

- Dag Runs

## Airflow CLI

 $ airflow db init: Initialize the metastore.
 $ airflow db reset: Delete all the metadata.
 $ airflow db upgrade: Upgrade the schemas

 $ airflow webserver: Start the web server
 $ airflow scheduler:
 $ airflow celery worker:

 $ airflow dags list: list the Dags
 $ airflow dags trigger example_bash_operator -e 2021-01-01
 $ airflow dags list-runs -d example_bash_operator
 $ airflow dags backfill -s 2021-01-01 -e 2021-01-05 --reset-dagruns

 $ airflow tasks list example_bash_operator

 $ airflow tasks test example_bash_operator runme_0 





# Operators

## HTTP Operator

## 

## Airflow Connections

Admin > Connections

### Http Connection

- Conn Id: forex_api
- Conn Type: HTTP
- Host: https://gist.github.com/



### File Sensor

- Conn Id: forex_path
- Conn Type: File Path
- Extra: {"path": "/opt/airflow/dags/files"}

### Hive Operator

- Conn Id: hive_conn
- Conn Type: Hive Server 2 Thrift
- Host: hive-server
- Login: hive
- Password: hive
- Port: 10000

### SparkSubmit Operator

- Conn Id: spark_conn
- Conn Type: Spark
- Host: spark://spark-master
- Port: 7077


# Mastering Airflow Dags

## 1- Start_date and schedule_interval parameters demystified


### start_date
- The date from which tasks of your DAG can be scheduled and triggered.
- Datetime Object
- Can be in the past or in the future
- As a best practice set the start_date globally at the DAG level (through default_args) and don't dynamic values such as datetime.now().

### end_date

- The date at which your DAG/Task should stop being scheduled.
- Set to None by Default
- Same recommendations than start_date.

### execution_date 
- Corresponds to the beginning of the processed period (start_date - scheduled_interval).

### schedule_interval

- The interval of time from the min(start date) at which your dag should be triggered.
- Cron expressions (ex: 0 * * * *)

## DagRun

- The scheduler creates a DagRun object;
- Describes an instance of a given DAG in time;
- Contains tasks to execute;
- Atomic, Idempotent;


## Backfill and Catchup


airflow.cfg: catchup_by_default = True


## Timezone

A timezone is a region of the globe that observes a uniform standard time.
Most of the timezonez on land are offset from Coordinated Universal Time (UTC) by a whole number of hours (UTC-12:00 to UTC+14:00)

**datetime aware**: Python datetime.datetime objects with the tzinfo attribute set;
**datetime naive**: Python datetime.datetime objects without the tzinfo attribute set;

- Always use aware datetime objects
- datetime.datetime() in python gives naive datetime objects by default
- Important airflow.timezone to create your aware datetime objects
- Let Airflow does the conversation for you.

### Timezones in airflow

- Airflow supports timezones;
- Datetime information stored in UTC;
- User interface always shows in datetime in UTC;
- Up to the developer to deal with de datetime;
- The timezone is set in airflow.cfg to UTC by default;
- Airflow uses the pendulum python library to deal with timezones;

### DST (Daylight Saving Time)

When the schedule_interval is set with a time delta, Airflow assumes you always will want to run the specific interval.




### How to make Tasks dependent


- depends_on_past:
    - Defined at task level
    - If previous tasks instance failed, the current task is not executed.
    - Consequently, the current task has no status;
    - First tasks instance with start_date allowed to run;



- wait_for_downstream
    - Defined at the tasks level.
    - An instance of task X will wait for tasks immediately downstream of the previous instance of task X to finish successfully before it runs.


### DAG Folders

- Folder where your Airflow Dags are
- Defined with the parameter dags_folder
- The path must be absolute
- By default $AIRFLOW_HOME/dags
- Problem: Too many DAGs, DAGs using external files;


### DagBags

- A DagBag is a collection of DAGs, parsed out of a folder tree and has a high-level configuration settings.
- Make easier to run distinct environment (dev/staging/prod)
- One system can run multiple independent settings set.
- Allo to add new DAG folders by creating a script in the default DAGs folder
- .airflowignore specifies the directorir or files in the DAGs folder that Airflow should ignore.
- Equivalent to the .gitignore file.
- Airflow looks for DAG or airflow in files. You can avoid wasting scans by using the .airflowignore file
- As best practice, always put a .airflowignore file in your DAGs folder.



## Web Server


Flask > Guinicorn Server > Master Process
- Worker 1
- Worker 2
- Worker 3
- Worker 4

web_server_master_timeout = 120
web_server_worker_timeout = 120

workers = 4
workers_class = 

logging_level = INFO


## How to deal with failures in your DAGs

Detection on DAGs

DAG level
- dagrun_timeout
- sla_miss_callback
- on_failure_callbak
- on_success_callback

DAGRun max_active_runs
If max_active_runs isn't set, Airflow use max_active_runs_per_dag in airflow.cfg

Task Failure Detection

- email
- email_on_failure
- email_on_retry
- retries
- retry delay
- retry_exponential_backoff
- max_retry_delay
- execution_timeout
- on_failure_callbak
- on_success_callback
- on_retry_callback



Triggers

- all_success
- all_failed
- all_done
- one_failed
- one_success
- none_failed
- none_skipped

