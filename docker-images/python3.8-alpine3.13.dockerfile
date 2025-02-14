FROM python:3.8-alpine3.13

LABEL maintainer="D.B.A <davidba941@gmail.com>"

RUN apk add --no-cache --virtual .build-deps gcc python3-dev \
    libc-dev make \
    && pip install --no-cache-dir "uvicorn[standard]" gunicorn \
    && apk del .build-deps gcc libc-dev make

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

COPY ./gunicorn_conf.py /gunicorn_conf.py

COPY ./start-reload.sh /start-reload.sh
RUN chmod +x /start-reload.sh

COPY ./app /app
WORKDIR /app/

ENV PYTHONPATH=/app

EXPOSE 80

# Run the start script, it will check for an /app/prestart.sh script (e.g. for migrations)
# And then will start Gunicorn with Uvicorn
CMD ["/start.sh"]
