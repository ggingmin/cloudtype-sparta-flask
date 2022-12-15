FROM python:3.9-slim-buster

RUN addgroup --system --gid 1000 worker
RUN adduser --system --uid 1000 --ingroup worker --disabled-password worker
USER worker:worker
WORKDIR /home/worker


COPY --chown=worker:worker requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

ENV PATH="/home/${USER}/.local/bin:${PATH}"

COPY --chown=worker:worker . .


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