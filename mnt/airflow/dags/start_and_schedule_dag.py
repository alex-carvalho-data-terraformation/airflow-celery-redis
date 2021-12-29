from airflow import DAG
from airflow.operators.dummy import DummyOperator
from datetime import datetime, timedelta

default_args = {
    'start_date': datetime(2019, 3, 29, 1),
    'owner': 'airflow'
}

with DAG(dag_id='start_and_schedule_dag',
         schedule_interval=timedelta(hours=1),  # "0 * * * *",
         catchup=False,
         default_args=default_args) as dag:
    dummy_task_1 = DummyOperator(task_id="dummy_task_1")

    dummy_task_2 = DummyOperator(task_id="dummy_task_2")

    dummy_task_1 >> dummy_task_2

    # Logs to help you (printed from the web server log)
    run_dates = dag.get_run_dates(start_date=dag.start_date)
    next_execution_date = run_dates[-1] if len(run_dates) != 0 else None
    print(f'[DAG:start_and_schedule_dag]'
          f' start date {dag.default_args["start_date"]}'
          f' - schedule_interval{dag.schedule_interval}'
          f' - last execution_date {dag.get_latest_execution_date}'
          f' - next execution_date {next_execution_date}')
