import os
from typing import Optional

def get_env_variable(var_name: str, default: Optional[str] = None) -> str:
    """Get the environment variable or raise exception."""
    try:
        return os.environ[var_name]
    except KeyError:
        if default is not None:
            return default
        else:
            error_msg = "The environment variable {} was missing, abort...".format(
                var_name
            )
            raise EnvironmentError(error_msg)

DATABASE_USER = get_env_variable("DATABASE_USER")
DATABASE_PASSWORD = get_env_variable("DATABASE_PASSWORD")
DATABASE_HOST = get_env_variable("DATABASE_HOST")
DATABASE_PORT = get_env_variable("DATABASE_PORT")
DATABASE_DB = get_env_variable("DATABASE_DB")

SQLALCHEMY_DATABASE_URI = "postgresql://%s:%s@%s:%s/%s" % (
    DATABASE_USER,
    DATABASE_PASSWORD,
    DATABASE_HOST,
    DATABASE_PORT,
    DATABASE_DB,
)

WEBSERVER_THREADS = get_env_variable("WEBSERVER_THREADS")
SUPERSET_WEBSERVER_PORT = get_env_variable("PORT")
SUPERSET_WEBSERVER_TIMEOUT = 300
SECRET_KEY = get_env_variable("SECRET_KEY")

PUBLIC_ROLE_LIKE = "Gamma-copy"

FEATURE_FLAGS = {
     "ENABLE_TEMPLATE_PROCESSING": True,
     "DASHBOARD_RBAC": True
}