workers = 4
bind = "127.0.0.1:8000"
access_log_format = '%(h)s %(l)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s'
logconfig = "/etc/gunicorn_logging.ini"
