FROM python:3.12.3-alpine3.20

ARG caldav_recurring_task_scheduler_repo=Neraud/caldav-recurring-task-scheduler
ARG caldav_recurring_task_scheduler_version=1b6cb6e328c895459573326a3868030bd099c215

ENV CONFIG_PATH=/data/config.yaml
ENV LOG_LEVEL=INFO
ENV RUN_DATE=""
ENV RUN_USER ""
ENV DRY_RUN="N"

RUN adduser app -D

RUN mkdir -p /opt/caldav_recurring_task_scheduler && \
    wget -q -O- https://github.com/${caldav_recurring_task_scheduler_repo}/archive/${caldav_recurring_task_scheduler_version}.tar.gz  | tar xz --strip-components=1 -C /opt/caldav_recurring_task_scheduler && \
    chown -R app:app /opt/caldav_recurring_task_scheduler

RUN chmod +x /opt/caldav_recurring_task_scheduler/entrypoint.sh

USER app

# Workaround for https://github.com/yaml/pyyaml/issues/601 to avoid "AttributeError: cython_sources"
RUN python3 -m pip install "Cython<3.0" "pyyaml==6.0" --no-build-isolation

RUN python3 -m pip install /opt/caldav_recurring_task_scheduler

ENTRYPOINT [ "/opt/caldav_recurring_task_scheduler/entrypoint.sh" ]
