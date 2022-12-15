FROM python:3.9-slim-buster

ENV PYTHONUNBUFFERED 1

ARG UID=1000
ARG GID=1000

RUN groupadd -g "${GID}" python \
  && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" python
USER python:python
WORKDIR /home/python


COPY --chown=python:python requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

ENV PATH="/home/${USER}/.local/bin:${PATH}"

COPY --chown=python:python . .


ARG FLASK_ENV
ARG DB_USERNAME
ARG DB_PASSWORD
ARG DB_URL

ENV FLASK_ENV=${FLASK_ENV}
ENV DB_USERNAME=${DB_USERNAME}
ENV DB_PASSWORD=${DB_PASSWORD}
ENV DB_URL=${DB_URL}

EXPOSE 5000

CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]