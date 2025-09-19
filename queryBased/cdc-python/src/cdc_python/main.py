import schedule
import time
import psycopg
import csv
import os
from datetime import datetime

class DatabaseScheduler:
    def __init__(self, connection_string, output_dir="data"):
        self.connection_string = connection_string
        self.output_dir = output_dir

        os.makedirs(output_dir, exist_ok=True)

    def query_users_to_csv(self):
        try:
            with psycopg.connect(self.connection_string) as connection:
                with connection.cursor() as cursor:
                    print("Querying users...")
                    records = cursor.execute("SELECT * FROM users").fetchall()
                    column_names = [column.name for column in cursor.description]

                    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                    filename = f"{self.output_dir}/users_{timestamp}.csv"

                    with open(filename, 'w', newline='', encoding='utf-8') as csvfile:
                        writer = csv.writer(csvfile)
                        writer.writerow(column_names)
                        writer.writerows(records)
        except Exception as e:
            print(f"Error: {e}")
    def start_scheduler(self):
        schedule.every(5).seconds.do(self.query_users_to_csv)

        print("Scheduler started")
        while True:
            schedule.run_pending()
            time.sleep(1)

def main():
    db_scheduler = DatabaseScheduler("dbname=database  user=postgres password=postgres host=localhost port=5430")
    db_scheduler.start_scheduler()


if __name__ == '__main__':
    main()
