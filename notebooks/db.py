# db.py : one place for the database connection. Every analysis cell imports run_query from here.
import os
import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

DB_USER = "postgres"
DB_HOST = "localhost"
DB_PORT = 5432
DB_NAME = "olist"
DB_PASSWORD = os.environ.get("OLIST_DB_PASSWORD")  # read from your computer, never typed into the file

if not DB_PASSWORD:
    raise RuntimeError("OLIST_DB_PASSWORD is not set. Set it once with setx, then reopen VS Code / Command Prompt.")

engine = create_engine(
    URL.create("postgresql+psycopg2", username=DB_USER, password=DB_PASSWORD,
               host=DB_HOST, port=DB_PORT, database=DB_NAME)
)

def run_query(sql: str) -> pd.DataFrame:
    """Run a SELECT query and return the result as a DataFrame."""
    with engine.connect() as conn:
        return pd.read_sql(text(sql), conn)