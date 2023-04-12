#!/usr/bin/env bash

# Downloads DDL SQL of EDW and preps it for use in chatgpt

set -eo
set -x

DOWNLOAD_SQL="select ddl from v_generate_tbl_ddl where schemaname in ('analytics_cs')"
RAW_DDL_FILE="greenhouse/edw/raw_ddl.sql"
SCRUBBED_DDL_FILE="greenhouse/edw/scrub_ddl.sql"

download_ddl_sql() {
	PGPASSWORD="$PROD_REDSHIFT_PW" psql \
		--host="${PROD_REDSHIFT_HOST}" \
		--port="${PROD_REDSHIFT_PORT}" \
		--username="${PROD_REDSHIFT_UN}" \
		-d "${PROD_REDSHIFT_DB}" \
		-c "${DOWNLOAD_SQL}" \
		-A -t > greenhouse/edw/raw_ddl.sql

}

scrub_ddl_sql() {
	cat "${RAW_DDL_FILE}" | sed 's/greenhouse/company/g' > "${SCRUBBED_DDL_FILE}"
}

main() {
	download_ddl_sql
	scrub_ddl_sql
}

main
