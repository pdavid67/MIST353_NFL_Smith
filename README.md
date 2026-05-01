## NFL Playoffs App

Local Streamlit + FastAPI app for the MIST353 NFL database project.

### Local setup

1. Create/update `API/.env` with your local SQL Server connection values:

```text
DB_SERVER=localhost
DB_NAME=MIST353_NFL_Smith
DB_TRUSTED_CONNECTION=true
```

If your local SQL Server uses SQL login instead of Windows auth:

```text
DB_LOGIN=your_sql_login
DB_PASSWORD=your_sql_password
DB_TRUSTED_CONNECTION=false
```

2. Run the SQL scripts in this order:

```text
DATA/CreateTablesSmith.sql
DATA/InsertDataSmith.sql
DATA/DatabaseProgrammingObjectsSmith.sql
```

3. Install dependencies:

```powershell
pip install -r requirements.txt
```

4. Start the API:

```powershell
uvicorn API.nfl_playoffs_api:app --reload
```

5. In another terminal, start the UI:

```powershell
streamlit run UI/nfl_playoffs_ui.py
```

Use **Validate User** first. Only users with the `NFLAdmin` role can schedule games.
