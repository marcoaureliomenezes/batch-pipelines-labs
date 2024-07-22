



deploy_airflow_services:
	docker-compose -f services/airflow_services.yml up -d

stop_airflow_services:
	docker-compose -f services/airflow_services.yml down


watch_airflow_logs:
	docker-compose -f services/airflow_services.yml logs -f

	